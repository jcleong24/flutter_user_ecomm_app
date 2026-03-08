const admin = require('firebase-admin');
const serviceAccount = require('./serviceAccountKey.json');

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
});

const db = admin.firestore();

const products = [
  {
    id: 'product_1',
    name: 'Nike Air Max',
    description: 'Comfortable running shoes',
    price: 399.0,
    stockQty: 12,
    thumbnailUrl: 'https://picsum.photos/seed/nike_air_max_1/600/600',
    imageUrls: [
      'https://picsum.photos/seed/nike_air_max_1/600/600',
      'https://picsum.photos/seed/nike_air_max_2/600/600',
      'https://picsum.photos/seed/nike_air_max_3/600/600',
    ],
  },
  {
    id: 'product_2',
    name: 'Leather Backpack',
    description: 'Premium leather backpack',
    price: 259.0,
    stockQty: 8,
    thumbnailUrl: 'https://picsum.photos/seed/leather_backpack_1/600/600',
    imageUrls: [
      'https://picsum.photos/seed/leather_backpack_1/600/600',
      'https://picsum.photos/seed/leather_backpack_2/600/600',
      'https://picsum.photos/seed/leather_backpack_3/600/600',
    ],
  },
  {
    id: 'product_3',
    name: 'Wireless Headphones',
    description: 'Noise cancelling headphones',
    price: 499.0,
    stockQty: 20,
    thumbnailUrl: 'https://picsum.photos/seed/headphones_1/600/600',
    imageUrls: [
      'https://picsum.photos/seed/headphones_1/600/600',
      'https://picsum.photos/seed/headphones_2/600/600',
      'https://picsum.photos/seed/headphones_3/600/600',
    ],
  },
  {
    id: 'product_4',
    name: 'Smart Watch',
    description: 'Track your fitness daily',
    price: 699.0,
    stockQty: 15,
    thumbnailUrl: 'https://picsum.photos/seed/smart_watch_1/600/600',
    imageUrls: [
      'https://picsum.photos/seed/smart_watch_1/600/600',
      'https://picsum.photos/seed/smart_watch_2/600/600',
      'https://picsum.photos/seed/smart_watch_3/600/600',
    ],
  },
  {
    id: 'product_5',
    name: 'Gaming Mouse',
    description: 'High precision gaming mouse',
    price: 129.0,
    stockQty: 30,
    thumbnailUrl: 'https://picsum.photos/seed/gaming_mouse_1/600/600',
    imageUrls: [
      'https://picsum.photos/seed/gaming_mouse_1/600/600',
      'https://picsum.photos/seed/gaming_mouse_2/600/600',
      'https://picsum.photos/seed/gaming_mouse_3/600/600',
    ],
  },
  {
    id: 'product_6',
    name: 'Mechanical Keyboard',
    description: 'RGB mechanical keyboard',
    price: 349.0,
    stockQty: 18,
    thumbnailUrl: 'https://picsum.photos/seed/mechanical_keyboard_1/600/600',
    imageUrls: [
      'https://picsum.photos/seed/mechanical_keyboard_1/600/600',
      'https://picsum.photos/seed/mechanical_keyboard_2/600/600',
      'https://picsum.photos/seed/mechanical_keyboard_3/600/600',
    ],
  },
  {
    id: 'product_7',
    name: 'Bluetooth Speaker',
    description: 'Portable speaker with deep bass',
    price: 199.0,
    stockQty: 25,
    thumbnailUrl: 'https://picsum.photos/seed/bluetooth_speaker_1/600/600',
    imageUrls: [
      'https://picsum.photos/seed/bluetooth_speaker_1/600/600',
      'https://picsum.photos/seed/bluetooth_speaker_2/600/600',
      'https://picsum.photos/seed/bluetooth_speaker_3/600/600',
    ],
  },
  {
    id: 'product_8',
    name: 'Running Shorts',
    description: 'Lightweight sports shorts',
    price: 89.0,
    stockQty: 40,
    thumbnailUrl: 'https://picsum.photos/seed/running_shorts_1/600/600',
    imageUrls: [
      'https://picsum.photos/seed/running_shorts_1/600/600',
      'https://picsum.photos/seed/running_shorts_2/600/600',
      'https://picsum.photos/seed/running_shorts_3/600/600',
    ],
  },
  {
    id: 'product_9',
    name: 'Sunglasses',
    description: 'UV protection sunglasses',
    price: 149.0,
    stockQty: 22,
    thumbnailUrl: 'https://picsum.photos/seed/sunglasses_1/600/600',
    imageUrls: [
      'https://picsum.photos/seed/sunglasses_1/600/600',
      'https://picsum.photos/seed/sunglasses_2/600/600',
      'https://picsum.photos/seed/sunglasses_3/600/600',
    ],
  },
  {
    id: 'product_10',
    name: 'Laptop Sleeve',
    description: 'Water-resistant laptop sleeve',
    price: 79.0,
    stockQty: 35,
    thumbnailUrl: 'https://picsum.photos/seed/laptop_sleeve_1/600/600',
    imageUrls: [
      'https://picsum.photos/seed/laptop_sleeve_1/600/600',
      'https://picsum.photos/seed/laptop_sleeve_2/600/600',
      'https://picsum.photos/seed/laptop_sleeve_3/600/600',
    ],
  },
  {
    id: 'product_11',
    name: 'Adidas Sport Shoes',
    description: 'Lightweight running shoes',
    price: 499.0,
    stockQty: 8,
    thumbnailUrl: 'https://picsum.photos/seed/adidas_sport_shoes_1/600/600',
    imageUrls: [
      'https://picsum.photos/seed/adidas_sport_shoes_1/600/600',
      'https://picsum.photos/seed/adidas_sport_shoes_2/600/600',
      'https://picsum.photos/seed/adidas_sport_shoes_3/600/600',
    ],
  },
  {
    id: 'product_12',
    name: 'Luka Running Shoes',
    description: 'NBA Lightweight running shoes',
    price: 4999.0,
    stockQty: 5,
    thumbnailUrl: 'https://picsum.photos/seed/luka_running_shoes_1/600/600',
    imageUrls: [
      'https://picsum.photos/seed/luka_running_shoes_1/600/600',
      'https://picsum.photos/seed/luka_running_shoes_2/600/600',
      'https://picsum.photos/seed/luka_running_shoes_3/600/600',
    ],
  },
];

async function seed() {
  for (const product of products) {
    await db.collection('products').doc(product.id).set({
      name: product.name,
      description: product.description,
      price: product.price,
      stockQty: product.stockQty,
      imageUrls: product.imageUrls,
      thumbnailUrl: product.imageUrls[0] ?? '',
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
    });

    console.log(`Added ${product.name}`);
  }

  console.log("✅ Seeding complete!");
  process.exit();
}

seed();