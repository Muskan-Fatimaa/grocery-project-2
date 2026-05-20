import 'package:cloud_firestore/cloud_firestore.dart';

class ProductSeeder {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  static Future<void> seedIfEmpty() async {
    final snapshot = await _db.collection('products').limit(1).get();

    // Only seed if collection is empty
    if (snapshot.docs.isNotEmpty) return;

    final products = [
      // ── Breakfast Essentials ──────────────────────────────────────────
      {
        'name': 'Brown Eggs (12)',
        'weight': '12 pieces',
        'price': 360,
        'imageUrl': 'https://images.unsplash.com/photo-1587486913049-53fc88980cfc?w=300',
        'category': 'Breakfast Essentials',
      },
      {
        'name': 'Dawn Bread Classic',
        'weight': '400 gm',
        'price': 120,
        'originalPrice': 130,
        'discountPercent': 8,
        'imageUrl': 'https://images.unsplash.com/photo-1509440159596-0249088772ff?w=300',
        'category': 'Breakfast Essentials',
      },
      {
        'name': 'Manuka Honey',
        'weight': '250 gm',
        'price': 1200,
        'imageUrl': 'https://images.unsplash.com/photo-1558642452-9d2a7deb7f62?w=300',
        'category': 'Breakfast Essentials',
      },
      {
        'name': 'Nutella Hazelnut Spread',
        'weight': '350 gm',
        'price': 850,
        'originalPrice': 950,
        'discountPercent': 10,
        'imageUrl': 'https://pictures.grocerapps.com/original/grocerapp-nutella-ferrero-chocolate-jar-hazelnut-5f64501f8bb41.jpeg',
        'category': 'Breakfast Essentials',
      },
      {
        'name': 'National Strawberry Jam',
        'weight': '440 gm',
        'price': 280,
        'imageUrl': 'https://pictures.grocerapps.com/original/grocerapp-national-strawberry-jam-5e6be868d7804.jpeg',
        'category': 'Breakfast Essentials',
      },

      // ── Milk & Dairy ──────────────────────────────────────────────────
      {
        'name': 'Olpers Full Cream Milk',
        'weight': '1 Litre',
        'price': 195,
        'imageUrl': 'https://images.unsplash.com/photo-1550583724-b2692b85b150?w=300',
        'category': 'Milk & Dairy',
      },
      {
        'name': 'Greek Yogurt',
        'weight': '400 gm',
        'price': 320,
        'imageUrl': 'https://images.unsplash.com/photo-1488477181946-6428a0291777?w=300',
        'category': 'Milk & Dairy',
      },
      {
        'name': 'Almond Milk',
        'weight': '1 Litre',
        'price': 450,
        'originalPrice': 500,
        'discountPercent': 10,
        'imageUrl': 'https://images.unsplash.com/photo-1600718374662-0483d2b9da44?w=300',
        'category': 'Milk & Dairy',
      },
      {
        'name': 'Dairy Life Burger Cheese',
        'weight': '200 gm',
        'price': 450,
        'imageUrl': 'https://pictures.grocerapps.com/original/grocerapp-dairy-life-burger-cheese-slices-673467662283d.jpeg',
        'category': 'Milk & Dairy',
      },
      {
        'name': 'Nestle Milk Pak Full Cream',
        'weight': '1 Litre',
        'price': 210,
        'originalPrice': 220,
        'discountPercent': 5,
        'imageUrl': 'https://pictures.grocerapps.com/original/grocerapp-nestle-milk-pak-full-cream-5e6d203d58540.jpeg',
        'category': 'Milk & Dairy',
      },

      // ── Fruits & Vegetables ───────────────────────────────────────────
      {
        'name': 'Strawberries',
        'weight': '2 kg',
        'price': 2825,
        'imageUrl': 'https://foodal.com/wp-content/uploads/2015/03/Make-Strawberry-Season-Last-All-Year.jpg',
        'category': 'Fruits & Vegetables',
      },
      {
        'name': 'Water Melon',
        'weight': '4.5 - 5.5 kg',
        'price': 560,
        'imageUrl': 'https://snaped.fns.usda.gov/sites/default/files/styles/crop_ratio_7_5/public/seasonal-produce/2018-05/watermelon.jpg.webp',
        'category': 'Fruits & Vegetables',
      },
      {
        'name': 'Peach',
        'weight': '500 gm',
        'price': 807,
        'imageUrl': 'https://pictures.grocerapps.com/original/grocerapp-peach--5f080b971820d.jpeg',
        'category': 'Fruits & Vegetables',
      },
      {
        'name': 'Tomato',
        'weight': '1 kg',
        'price': 70,
        'imageUrl': 'https://pictures.grocerapps.com/original/grocerapp-tomato--627e4dd24cc6a.jpeg',
        'category': 'Fruits & Vegetables',
      },
      {
        'name': 'Organic Avocado',
        'weight': '1 piece',
        'price': 250,
        'originalPrice': 280,
        'discountPercent': 10,
        'imageUrl': 'https://images.unsplash.com/photo-1523049673857-eb18f1d7b578?w=300',
        'category': 'Fruits & Vegetables',
      },

      // ── Meat & Seafood ────────────────────────────────────────────────
      {
        'name': 'Fresh Chicken',
        'weight': '1 kg',
        'price': 650,
        'imageUrl': 'https://images.unsplash.com/photo-1587593810167-a84920ea0781?w=300',
        'category': 'Meat & Seafood',
      },
      {
        'name': 'Mutton Chops',
        'weight': '500 gm',
        'price': 1200,
        'imageUrl': 'https://images.unsplash.com/photo-1607623814075-e51df1bdc82f?w=300',
        'category': 'Meat & Seafood',
      },
      {
        'name': 'Fresh Fish',
        'weight': '1 kg',
        'price': 900,
        'originalPrice': 1000,
        'discountPercent': 10,
        'imageUrl': 'https://pictures.grocerapps.com/original/grocerapp-fresh-st-strimps-shrimps-small-6992cf2890ec8.jpeg',
        'category': 'Meat & Seafood',
      },

      // ── Daal, Rice, Atta & Cheeni ─────────────────────────────────────
      {
        'name': 'Moong Daal',
        'weight': '1 kg',
        'price': 320,
        'imageUrl': 'https://pictures.grocerapps.com/original/grocerapp-golden-bite-moong-sabut-moti-6932d05bf36cd.jpeg',
        'category': 'Daal, Rice, Atta & Cheeni',
      },
      {
        'name': 'Kausar Basmati Rice',
        'weight': '5 kg',
        'price': 1450,
        'originalPrice': 1600,
        'discountPercent': 9,
        'imageUrl': 'https://pictures.grocerapps.com/original/grocerapp-kausar-steamed-basmati-rice-66127bf2b07c6.jpeg',
        'category': 'Daal, Rice, Atta & Cheeni',
      },
      {
        'name': 'Quinoa',
        'weight': '500 gm',
        'price': 690,
        'imageUrl': 'https://images.unsplash.com/photo-1586201375761-83865001e31c?w=300',
        'category': 'Daal, Rice, Atta & Cheeni',
      },
      {
        'name': 'Sugar (Local)',
        'weight': '1 kg',
        'price': 160,
        'imageUrl': 'https://pictures.grocerapps.com/original/grocerapp-sugar-1-kg-local-68b9c7735d3f1.jpeg',
        'category': 'Daal, Rice, Atta & Cheeni',
      },

      // ── Cooking Oils & Ghee ───────────────────────────────────────────
      {
        'name': 'Olive Oil Extra Virgin',
        'weight': '500 ml',
        'price': 950,
        'originalPrice': 1050,
        'discountPercent': 10,
        'imageUrl': 'https://images.unsplash.com/photo-1474979266404-7eaacbcd87c5?w=300',
        'category': 'Cooking Oils & Ghee',
      },
      {
        'name': 'Sufi Sunflower Oil',
        'weight': '1 Litre',
        'price': 480,
        'imageUrl': 'https://pictures.grocerapps.com/original/grocerapp-sufi-sunflower-cooking-oil-61a0cb81bb70a.jpeg',
        'category': 'Cooking Oils & Ghee',
      },
      {
        'name': 'Desi Ghee',
        'weight': '500 gm',
        'price': 1800,
        'imageUrl': 'https://khaalis.pk/cdn/shop/files/compressed_Artboard_4_copy.png?v=1769152958',
        'category': 'Cooking Oils & Ghee',
      },

      // ── Snacks & Beverages ────────────────────────────────────────────
      {
        'name': 'Nestle Kashmiri Chai',
        'weight': '150 gm',
        'price': 335,
        'imageUrl': 'https://pictures.grocerapps.com/original/grocerapp-nestle-every-day-kashmiri-chai-6786404e50319.jpeg',
        'category': 'Snacks & Beverages',
      },
      {
        'name': 'Tapal Danedar Tea',
        'weight': '450 gm',
        'price': 650,
        'imageUrl': 'https://images.unsplash.com/photo-1544787219-7f47ccb76574?w=300',
        'category': 'Snacks & Beverages',
      },
      {
        'name': 'Fresher Orange Juice',
        'weight': '1 Litre',
        'price': 280,
        'originalPrice': 320,
        'discountPercent': 12,
        'imageUrl': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQKd15w5UMzks6hFftWTbtJ7ZO_JuHyVpC6iA&s',
        'category': 'Snacks & Beverages',
      },
      {
        'name': 'Qarshi Jam-E-Shirin',
        'weight': '1500 ml',
        'price': 1600,
        'imageUrl': 'https://img.drz.lazcdn.com/static/pk/p/10924c06d89a493330b34c844d72f13b.png_720x720q80.png',
        'category': 'Snacks & Beverages',
      },
      {
        'name': 'Tapal Green Tea Tropical Peach',
        'weight': '30 Tea Bags',
        'price': 350,
        'imageUrl': 'https://pictures.grocerapps.com/original/grocerapp-tapal-green-tea-tropical-peach-61c9601b04824.jpeg',
        'category': 'Snacks & Beverages',
      },

      // ── Spices & Herbs ────────────────────────────────────────────────
      {
        'name': 'Dhaniya Powder',
        'weight': '50 gm',
        'price': 60,
        'imageUrl': 'https://pictures.grocerapps.com/original/grocerapp-golden-bite-dhaniya-powder-50g-69390db15ce01.jpeg',
        'category': 'Spices & Herbs',
      },
      {
        'name': 'Turmeric Powder',
        'weight': '100 gm',
        'price': 80,
        'imageUrl': 'https://pictures.grocerapps.com/original/grocerapp-turmeric-powder--5ffd6825512b7.jpeg',
        'category': 'Spices & Herbs',
      },
      {
        'name': 'National Garam Masala',
        'weight': '50 gm',
        'price': 120,
        'imageUrl': 'https://pictures.grocerapps.com/original/grocerapp-national-garam-masala-powder-5e6bc51683be5.jpeg',
        'category': 'Spices & Herbs',
      },

      // ── Sauces & Pastes ───────────────────────────────────────────────
      {
        'name': 'Mitchell Chilli Garlic Sauce',
        'weight': '300 gm',
        'price': 185,
        'imageUrl': 'https://pictures.grocerapps.com/original/grocerapp-mitchells-chilli-garlic-sauce-5ec3a77726bc8.jpeg',
        'category': 'Sauces & Pastes',
      },
      {
        'name': 'Youngs Mayonnaise',
        'weight': '500 gm',
        'price': 320,
        'imageUrl': 'https://pictures.grocerapps.com/original/grocerapp-youngs-mayoonaise-5ea04c26e7e60.jpeg',
        'category': 'Sauces & Pastes',
      },
      {
        'name': 'Dipitt Buffalo Sauce',
        'weight': '300 ml',
        'price': 420,
        'originalPrice': 480,
        'discountPercent': 12,
        'imageUrl': 'https://pictures.grocerapps.com/original/grocerapp-dipitt-buffalo-sauce-5f1edb41cd431.jpeg',
        'category': 'Sauces & Pastes',
      },

      // ── Baking & Pantry ───────────────────────────────────────────────
      {
        'name': 'Hamdard Ispaghol Sachet',
        'weight': '4.5 gm',
        'price': 32,
        'originalPrice': 40,
        'discountPercent': 20,
        'imageUrl': 'https://vitaminshouse.com/cdn/shop/files/Marhaba_Ispaghol_Psyllium_Husk_300g_-_Vitamins_House-558518_533x.jpg',
        'category': 'Baking & Pantry',
      },
      {
        'name': 'Chia Seeds',
        'weight': '200 gm',
        'price': 380,
        'imageUrl': 'https://images.unsplash.com/photo-1514733670139-4d87a1941d55?w=300',
        'category': 'Baking & Pantry',
      },
      {
        'name': 'Laziza Gulab Jamun Mix',
        'weight': '200 gm',
        'price': 120,
        'imageUrl': 'https://pictures.grocerapps.com/original/grocerapp-laziza-gulab-jumun-mix-5ea3e54b57c2f.jpeg',
        'category': 'Baking & Pantry',
      },
      {
        'name': 'Bakea Vanilla Cake Mix',
        'weight': '500 gm',
        'price': 280,
        'imageUrl': 'https://pictures.grocerapps.com/original/grocerapp-bakea-vanilla-cake-mix-66bb03e04f181.jpeg',
        'category': 'Baking & Pantry',
      },
    ];

    // Upload all products to Firestore
    final batch = _db.batch();
    for (final product in products) {
      final ref = _db.collection('products').doc();
      batch.set(ref, product);
    }
    await batch.commit();

    print('✅ ${products.length} products seeded to Firestore!');
  }
}
