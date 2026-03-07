/**
 * Import function triggers from their respective submodules:
 *
 * import {onCall} from "firebase-functions/v2/https";
 * import {onDocumentWritten} from "firebase-functions/v2/firestore";
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

import { onCall, HttpsError, onRequest } from "firebase-functions/v2/https";
import { defineSecret } from "firebase-functions/params";
import Stripe from "stripe";
import * as admin from "firebase-admin";

admin.initializeApp();

const STRIPE_SECRET_KEY = defineSecret("STRIPE_SECRET_KEY");
const STRIPE_WEBHOOK_SECRET = defineSecret("STRIPE_WEBHOOK_SECRET");

export const createPaymentIntent = onCall(
  { secrets: [STRIPE_SECRET_KEY] },
  async (request) => {
    try {
      const { orderId, transactionId, amount, currency } = request.data as {
        orderId: string;
        transactionId: string;
        amount: number;
        currency: string;
      };

      if (!orderId) {
        throw new HttpsError("invalid-argument", "orderId is required");
      }
      if (!transactionId) {
        throw new HttpsError("invalid-argument", "transactionId is required");
      }
      if (!currency) {
        throw new HttpsError("invalid-argument", "currency is required");
      }
      if (typeof amount !== "number" || amount <= 0) {
        throw new HttpsError("invalid-argument", "amount must be > 0");
      }

      const stripe = new Stripe(STRIPE_SECRET_KEY.value(), {
        apiVersion: "2026-02-25.clover",
      });

      const intent = await stripe.paymentIntents.create({
        amount: Math.round(amount),
        currency: currency.toLowerCase(),
        metadata: {
          orderId,
          transactionId,
        },
        automatic_payment_methods: {
          enabled: true,
        },
      });

      if (!intent.client_secret) {
        throw new HttpsError("internal", "Failed to create payment intent");
      }
      return {
        clientSecret: intent.client_secret,
        paymentIntentId: intent.id,
      };
    } catch (error: any) {
      console.error("createPaymentIntent error: ", error);
      throw new HttpsError("internal", error?.message ?? "Unknown error");
    }
  }
);

// Creating stripe webhook to update order status in firestore
export const stripeWebhook = onRequest(
  { secrets: [STRIPE_WEBHOOK_SECRET, STRIPE_SECRET_KEY] },
  async (request, response) => {
    const stripe = new Stripe(STRIPE_SECRET_KEY.value(), {
      apiVersion: "2026-02-25.clover",
    });

    const signature = request.headers["stripe-signature"];
    if (!signature || typeof signature !== "string") {
      response.status(400).send("Missing Stripe-Signature header");
      return;
    }

    let event: Stripe.Event;

    try {
      event = stripe.webhooks.constructEvent(
        request.rawBody,
        signature,
        STRIPE_WEBHOOK_SECRET.value(),
      );
    } catch (error: any) {
      console.error("Webhook signature verification failed: ", error);
      response.status(400).send(`Webhook Error: ${error.message}`);
      return;
    }

    try {
      switch (event.type) {
        case "payment_intent.succeeded": {
          const paymentIntent = event.data.object as Stripe.PaymentIntent;
          const orderId = paymentIntent.metadata?.orderId;
          const transactionId = paymentIntent.metadata?.transactionId;

          if (!orderId || !transactionId) {
            throw new Error("Missing orderId or transactionId in metadata");
          }

          const orderRef = admin.firestore().collection("orders").doc(orderId);
          const txnRef = orderRef.collection("payment_transactions").doc(transactionId);

          await txnRef.update({
            status: "APPROVED",
            responseCode: "00",
            responseMessage: "APPROVED (WEBHOOK)",
            stripePaymentIntentId: paymentIntent.id,
            updatedAt: admin.firestore.FieldValue.serverTimestamp(),
          });

          await orderRef.update({
            status: "PAID",
            updatedAt: admin.firestore.FieldValue.serverTimestamp(),
          })

          break;
        }

        case "payment_intent.payment_failed": {
          const paymentIntent = event.data.object as Stripe.PaymentIntent;
          const orderId = paymentIntent.metadata?.orderId;
          const transactionId = paymentIntent.metadata?.transactionId;

          if (!orderId || !transactionId) {
            throw new Error("Missing orderId or transactionId in metadata");
          }

          const failureMessage = paymentIntent.last_payment_error?.message || "Payment failed";

          const orderRef = admin.firestore().collection("orders").doc(orderId);
          const txnRef = orderRef.collection("payment_transactions").doc(transactionId);

          await txnRef.update({
            status: "DECLINED",
            responseCode: "05",
            responseMessage: failureMessage,
            stripePaymentIntentId: paymentIntent.id,
            updatedAt: admin.firestore.FieldValue.serverTimestamp(),
          })

          await orderRef.update({
            status: "failed",
            updatedAt: admin.firestore.FieldValue.serverTimestamp(),
          });

          break;
        }

        default: {
          console.log(`Unhandled event type: ${event.type}`);
        }
      }
      response.json({ received: true });
    } catch (error: any) {
      console.error("stripeWebhook error: ", error);
      response.status(500).send(error?.message ?? "Unknown error");
    }
  }
)

