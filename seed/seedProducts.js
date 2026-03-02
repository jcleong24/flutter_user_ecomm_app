const admin = require('firebase-admin');
const serviceAccount = require('./serviceAccountKey.json');

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
});

const db = admin.firestore();

const products = [
//   {
//     id: "product_1",
//     name: "Nike Air Max",
//     description: "Comfortable running shoes",
//     price: 399.0,
//     stockQty: 12,
//     imageUrl: "https://picsum.photos/400?1",
//   },
//   {
//     id: "product_2",
//     name: "Leather Backpack",
//     description: "Premium leather backpack",
//     price: 259.0,
//     stockQty: 8,
//     imageUrl: "https://picsum.photos/400?2",
//   },
//   {
//     id: "product_3",
//     name: "Wireless Headphones",
//     description: "Noise cancelling headphones",
//     price: 499.0,
//     stockQty: 20,
//     imageUrl: "https://picsum.photos/400?3",
//   },
//   {
//     id: "product_4",
//     name: "Smart Watch",
//     description: "Track your fitness daily",
//     price: 699.0,
//     stockQty: 15,
//     imageUrl: "https://picsum.photos/400?4",
//   },
//   {
//     id: "product_5",
//     name: "Gaming Mouse",
//     description: "High precision gaming mouse",
//     price: 129.0,
//     stockQty: 30,
//     imageUrl: "https://picsum.photos/400?5",
//   },
//   {
//     id: "product_6",
//     name: "Mechanical Keyboard",
//     description: "RGB mechanical keyboard",
//     price: 349.0,
//     stockQty: 18,
//     imageUrl: "https://picsum.photos/400?6",
//   },
//   {
//     id: "product_7",
//     name: "Bluetooth Speaker",
//     description: "Portable speaker with deep bass",
//     price: 199.0,
//     stockQty: 25,
//     imageUrl: "https://picsum.photos/400?7",
//   },
//   {
//     id: "product_8",
//     name: "Running Shorts",
//     description: "Lightweight sports shorts",
//     price: 89.0,
//     stockQty: 40,
//     imageUrl: "https://picsum.photos/400?8",
//   },
//   {
//     id: "product_9",
//     name: "Sunglasses",
//     description: "UV protection sunglasses",
//     price: 149.0,
//     stockQty: 22,
//     imageUrl: "https://picsum.photos/400?9",
//   },
//   {
//     id: "product_10",
//     name: "Laptop Sleeve",
//     description: "Water-resistant laptop sleeve",
//     price: 79.0,
//     stockQty: 35,
//     imageUrl: "https://picsum.photos/400?10",
//   },
//   {
//     id: "product_11",
//     name: "Adidas Sport Shoes",
//     description: "Lightweight running shoes",
//     price: 499.0,
//     stockQty: 8,
//     imageUrl: "https://picsum.photos/400?11",
//   },
  {
    id: "product_12",
    name: "Luka Running Shoes",
    description: "NBA Lightweight running shoes",
    price: 4999.0,
    stockQty: 5,
    imageUrl: "https://picsum.photos/400?12",
  },
];

async function seed() {
  for (const product of products) {
    await db.collection('products').doc(product.id).set({
      name: product.name,
      description: product.description,
      price: product.price,
      stockQty: product.stockQty,
      imageUrl: product.imageUrl,
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
    });

    console.log(`Added ${product.name}`);
  }

  console.log("✅ Seeding complete!");
  process.exit();
}

seed();