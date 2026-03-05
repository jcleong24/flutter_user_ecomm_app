/**
 * Import function triggers from their respective submodules:
 *
 * import {onCall} from "firebase-functions/v2/https";
 * import {onDocumentWritten} from "firebase-functions/v2/firestore";
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

import {onCall, HttpsError} from "firebase-functions/v2/https";
import {defineSecret} from "firebase-functions/params";
import Stripe from "stripe";

// Secret stored in Google Secret Manager
const STRIPE_SECRET_KEY = defineSecret("STRIPE_SECRET_KEY");

export const createPaymentIntent = onCall(
  {secrets: [STRIPE_SECRET_KEY]},
  async (request) => {
    try {
      const {orderId, amount, currency} = request.data as {
                orderId: string;
                amount: number;
                currency: string;
            };

      if (!orderId) {
        throw new HttpsError("invalid-argument", "orderId is required");
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
        amount,
        currency: currency.toLowerCase(),
        metadata: {orderId},
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

// Start writing functions
// https://firebase.google.com/docs/functions/typescript

// For cost control, you can set the maximum number of containers that can be
// running at the same time. This helps mitigate the impact of unexpected
// traffic spikes by instead downgrading performance. This limit is a
// per-function limit. You can override the limit for each function using the
// `maxInstances` option in the function's options, e.g.
// `onRequest({ maxInstances: 5 }, (req, res) => { ... })`.
// NOTE: setGlobalOptions does not apply to functions using the v1 API. V1
// functions should each use functions.runWith({ maxInstances: 10 }) instead.
// In the v1 API, each function can only serve one request per container, so
// this will be the maximum concurrent request count.
// setGlobalOptions({ maxInstances: 10 });

// export const helloWorld = onRequest((request, response) => {
//   logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });
