

class TrendingProduct {
  final String name;
  final String weight;
  final double price;
  final double? originalPrice;
  final String imageUrl;
  final int? discountPercent;

  const TrendingProduct({
    required this.name,
    required this.weight,
    required this.price,
    this.originalPrice,
    required this.imageUrl,
    this.discountPercent,
  });
}

// ── NEW: New Arrival model (same shape, separate list for clarity) ──────────
class NewArrivalProduct {
  final String name;
  final String weight;
  final double price;
  final double? originalPrice;
  final String imageUrl;
  final int? discountPercent;

  const NewArrivalProduct({
    required this.name,
    required this.weight,
    required this.price,
    this.originalPrice,
    required this.imageUrl,
    this.discountPercent,
  });
}

class SubCategory {
  final String name;
  final String imageUrl;
  const SubCategory({required this.name, required this.imageUrl});
}

class Category {
  final String name;
  final String description;
  final String imageUrl;
  final List<SubCategory> subCategories;
  const Category({
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.subCategories,
  });
}

// ── Static Data ───────────────────────────────────────────────────────────────

const List<Map<String, String>> homeBanners = [
  {
    'imageUrl':
    'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=800',
    'label': 'Vegi',
    'discount': '30% Off',
    'subtitle': 'On all vegetables products',
  },
  {
    'imageUrl':
    'https://images.unsplash.com/photo-1610348725531-843dff563e2c?w=800',
    'label': 'Fruit',
    'discount': '20% Off',
    'subtitle': 'On seasonal fresh fruits',
  },
  {
    'imageUrl':
    'https://images.unsplash.com/photo-1607623814075-e51df1bdc82f?w=800',
    'label': 'Meat',
    'discount': '15% Off',
    'subtitle': 'On all meat products',
  },
  {
    'imageUrl':
    'https://images.unsplash.com/photo-1533089860892-a7c6f0a88666?w=800',
    'label': 'Dairy',
    'discount': '10% Off',
    'subtitle': 'On dairy & cheese items',
  },
];

const List<TrendingProduct> trendingProducts = [
  TrendingProduct(
    name: 'Strawberries',
    weight: '2 kg',
    price: 2825,
    imageUrl:
    'https://foodal.com/wp-content/uploads/2015/03/Make-Strawberry-Season-Last-All-Year.jpg',
  ),
  TrendingProduct(
    name: 'Nestle Every Day Kashmiri Chai',
    weight: '150 gm',
    price: 335,
    imageUrl:
    'https://pictures.grocerapps.com/original/grocerapp-nestle-every-day-kashmiri-chai-6786404e50319.jpeg',
  ),
  TrendingProduct(
    name: 'Peach',
    weight: '500 gram',
    price: 807,
    imageUrl:
    'https://pictures.grocerapps.com/original/grocerapp-peach--5f080b971820d.jpeg',
  ),
  TrendingProduct(
    name: 'Milk Bottle',
    weight: '150 ml',
    price: 800,
    imageUrl:
    'https://media.post.rvohealth.io/wp-content/uploads/2022/05/soy-milk-bottle-732-549-feature-thumb-732x549.jpg',
  ),
  TrendingProduct(
    name: 'Hamdard Ispaghol Sachet',
    weight: '4.5 gm',
    price: 32,
    originalPrice: 40,
    imageUrl:
    'https://vitaminshouse.com/cdn/shop/files/Marhaba_Ispaghol_Psyllium_Husk_300g_-_Vitamins_House-558518_533x.jpg?v=1745189506',
    discountPercent: 20,
  ),
  TrendingProduct(
    name: 'Marhaba Joshanda Herbal',
    weight: '30 piece',
    price: 570,
    originalPrice: 600,
    imageUrl:
    'https://pictures.grocerapps.com/original/grocerapp-marhaba-joshanda-herbal-tea-1x30pcs-61e7a0e72c99d.jpeg',
    discountPercent: 5,
  ),
  TrendingProduct(
    name: 'Water Melon',
    weight: '4.5 - 5.5 kg',
    price: 560,
    imageUrl:
    'https://snaped.fns.usda.gov/sites/default/files/styles/crop_ratio_7_5/public/seasonal-produce/2018-05/watermelon.jpg.webp?itok=4TjwcpU9',
  ),
  TrendingProduct(
    name: 'Dawn Bread Classic',
    weight: '400 gm',
    price: 120,
    originalPrice: 130,
    imageUrl:
    'https://images.unsplash.com/photo-1509440159596-0249088772ff?w=300',
    discountPercent: 8,
  ),
  TrendingProduct(
    name: 'Olpers Full Cream Milk',
    weight: '1 Litre',
    price: 195,
    imageUrl:
    'https://images.unsplash.com/photo-1550583724-b2692b85b150?w=300',
  ),
  TrendingProduct(
    name: 'Fresher Orange Juice',
    weight: '1 Litre',
    price: 280,
    originalPrice: 320,
    imageUrl:
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQKd15w5UMzks6hFftWTbtJ7ZO_JuHyVpC6iA&s',
    discountPercent: 12,
  ),
  TrendingProduct(
    name: 'Tapal Danedar Tea',
    weight: '450 gm',
    price: 650,
    imageUrl:
    'https://images.unsplash.com/photo-1544787219-7f47ccb76574?w=300',
  ),
  TrendingProduct(
    name: 'Qarshi Jam-E-Shirin',
    weight: '1500 ml',
    price: 1600,
    imageUrl:
    'https://img.drz.lazcdn.com/static/pk/p/10924c06d89a493330b34c844d72f13b.png_720x720q80.png',
  ),
  TrendingProduct(
    name: 'Tapal Green Tea Tropical Peach',
    weight: '30 Tea Bags',
    price: 350,
    imageUrl:
    'https://pictures.grocerapps.com/original/grocerapp-tapal-green-tea-tropical-peach-61c9601b04824.jpeg',
  ),
  TrendingProduct(
    name: 'Tomato',
    weight: '1 kg',
    price: 70,
    imageUrl:
    'https://pictures.grocerapps.com/original/grocerapp-tomato--627e4dd24cc6a.jpeg',
  ),
];

// ── New Arrivals (static fallback — replaced by Firestore stream in screen) ──
const List<NewArrivalProduct> newArrivalProducts = [
  NewArrivalProduct(
    name: 'Anmol Plain Greek Yogurt',
    weight: '200 gm',
    price: 595,
    imageUrl:
    'https://images.unsplash.com/photo-1488477181946-6428a0291777?w=300',
  ),
  NewArrivalProduct(
    name: 'Dipitt Buffalo Sauce',
    weight: '300 ml',
    price: 320,
    originalPrice: 380,
    imageUrl:
    'https://pictures.grocerapps.com/original/grocerapp-dipitt-buffalo-sauce-5f1edb41cd431.jpeg',
    discountPercent: 16,
  ),
  NewArrivalProduct(
    name: 'National Banana Custard',
    weight: '300 gm',
    price: 180,
    imageUrl:
    'https://pictures.grocerapps.com/original/grocerapp-national-banana-custard-powder-5f4c8c837fd35.jpeg',
  ),
  NewArrivalProduct(
    name: 'Bakea Vanilla Cake Mix',
    weight: '500 gm',
    price: 420,
    originalPrice: 480,
    imageUrl:
    'https://pictures.grocerapps.com/original/grocerapp-bakea-vanilla-cake-mix-66bb03e04f181.jpeg',
    discountPercent: 12,
  ),
  NewArrivalProduct(
    name: 'Nestle Milk Pak',
    weight: '1 Litre',
    price: 210,
    imageUrl:
    'https://pictures.grocerapps.com/original/grocerapp-nestle-milk-pak-full-cream-5e6d203d58540.jpeg',
  ),
  NewArrivalProduct(
    name: 'Golden Bite Ispagol',
    weight: '50 gm',
    price: 335,
    imageUrl:
    'https://pictures.grocerapps.com/original/grocerapp-golden-bite-ispagol-chilka-50g-693334dbdd412.jpeg',
  ),
  NewArrivalProduct(
    name: 'Shangrila Habanero Ketchup',
    weight: '800 gm',
    price: 290,
    originalPrice: 340,
    imageUrl:
    'https://pictures.grocerapps.com/original/grocerapp-shangrila-habanero-ketchup-hot--68fb6a6d21e69.png',
    discountPercent: 15,
  ),
  NewArrivalProduct(
    name: 'Kausar Basmati Rice',
    weight: '5 kg',
    price: 1450,
    imageUrl:
    'https://pictures.grocerapps.com/original/grocerapp-kausar-steamed-basmati-rice-66127bf2b07c6.jpeg',
  ),
];

const List<Category> homeCategories = [
  Category(
    name: 'Breakfast Essentials',
    description: 'All your breakfast needs from eggs to cheese',
    imageUrl:
    'https://images.unsplash.com/photo-1533089860892-a7c6f0a88666?w=200',
    subCategories: [
      SubCategory(
          name: 'Eggs',
          imageUrl:
          'https://images.unsplash.com/photo-1587486913049-53fc88980cfc?w=200'),
      SubCategory(
          name: 'Bread & Bakery',
          imageUrl:
          'https://images.unsplash.com/photo-1509440159596-0249088772ff?w=200'),
      SubCategory(
          name: 'Cereals',
          imageUrl:
          'https://pictures.grocerapps.com/original/grocerapp--fauji-rice-flakes-5e6bccc6718ce.png'),
      SubCategory(
          name: 'Oats & Porridge',
          imageUrl:
          'https://pictures.grocerapps.com/original/grocerapp-golden-bite-wheat-daliya-1kg-69333685e708f.jpeg'),
      SubCategory(
          name: 'Cakes & Rusks',
          imageUrl:
          'https://pictures.grocerapps.com/original/grocerapp-dawn-cake-way-plain-cake-68f5d3b71eb36.png'),
      SubCategory(
          name: 'Baqarkhani & Pastries',
          imageUrl:
          'https://images.unsplash.com/photo-1555507036-ab1f4038808a?w=200'),
      SubCategory(
          name: 'Jams & Marmalades',
          imageUrl:
          'https://pictures.grocerapps.com/original/grocerapp-national-strawberry-jam-5e6be868d7804.jpeg'),
      SubCategory(
          name: 'Honey',
          imageUrl:
          'https://images.unsplash.com/photo-1558642452-9d2a7deb7f62?w=200'),
      SubCategory(
          name: 'Spreads & Syrups',
          imageUrl:
          'https://pictures.grocerapps.com/original/grocerapp-nutella-ferrero-chocolate-jar-hazelnut-5f64501f8bb41.jpeg'),
      SubCategory(
          name: 'Breakfast Mixes',
          imageUrl:
          'https://pictures.grocerapps.com/original/grocerapp-bakea-pancake-mix-buttermilk-64929f138f375.png'),
    ],
  ),
  Category(
    name: 'Milk & Dairy',
    description: 'All sort of Milk, Cream & Cheese',
    imageUrl:
    'https://images.unsplash.com/photo-1550583724-b2692b85b150?w=200',
    subCategories: [
      SubCategory(
          name: 'Fresh Milk',
          imageUrl:
          'https://images.unsplash.com/photo-1563636619-e9143da7973b?w=200'),
      SubCategory(
          name: 'UHT Milk',
          imageUrl:
          'https://pictures.grocerapps.com/original/grocerapp-nestle-milk-pak-full-cream-5e6d203d58540.jpeg'),
      SubCategory(
          name: 'Cream',
          imageUrl: 'https://nayabazar.pk/images/products/ZRMhaxdrb1SVj6s.webp'),
      SubCategory(
          name: 'Cheese',
          imageUrl:
          'https://pictures.grocerapps.com/original/grocerapp-dairy-life-burger-cheese-slices-673467662283d.jpeg'),
      SubCategory(
          name: 'Yogurt',
          imageUrl:
          'https://static01.nyt.com/images/2018/07/18/dining/18YOGURT1/18YOGURT1-jumbo.jpg'),
      SubCategory(
          name: 'Butter',
          imageUrl:
          'https://www.fitterfly.com/blog/wp-content/uploads/2024/09/Is-Butter-Good-for-Weight-Loss-1200x900.webp'),
    ],
  ),
  Category(
    name: 'Fruits & Vegetables',
    description: 'Fruits, Vegetables & Exotic Vegetables',
    imageUrl:
    'https://images.unsplash.com/photo-1610832958506-aa56368176cf?w=200',
    subCategories: [
      SubCategory(
          name: 'Fresh Fruits',
          imageUrl:
          'https://images.unsplash.com/photo-1619566636858-adf3ef46400b?w=200'),
      SubCategory(
          name: 'Fresh Vegetables',
          imageUrl:
          'https://images.unsplash.com/photo-1540420773420-3366772f4999?w=200'),
      SubCategory(
          name: 'Herbs & Seasonings',
          imageUrl:
          'https://emi.parkview.com/media/Image/Dashboard_835_Herbs_9_23.jpeg'),
      SubCategory(
          name: 'Root Vegetables',
          imageUrl:
          'https://media.post.rvohealth.io/wp-content/uploads/2020/08/root-vegetables-732x549-thumbnail.jpg'),
      SubCategory(
          name: 'Exotic Vegetables',
          imageUrl:
          'https://images.unsplash.com/photo-1518977676601-b53f82aba655?w=200'),
      SubCategory(
          name: 'Salad Leaves',
          imageUrl:
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS1QsgrAVl5-OFDv3VmCxQyDC_R5QYYDfG34A&s'),
    ],
  ),
  Category(
    name: 'Meat & Seafood',
    description: 'Mutton, Beef, Chicken, Fish',
    imageUrl:
    'https://images.unsplash.com/photo-1607623814075-e51df1bdc82f?w=200',
    subCategories: [
      SubCategory(
          name: 'Chicken',
          imageUrl:
          'https://images.unsplash.com/photo-1587593810167-a84920ea0781?w=200'),
      SubCategory(
          name: 'Mutton',
          imageUrl:
          'https://images.unsplash.com/photo-1607623814075-e51df1bdc82f?w=200'),
      SubCategory(
          name: 'Beef',
          imageUrl:
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRv7XjKswZ_X38tKlLskZHQPEB-jnok0FzDyg&s'),
      SubCategory(
          name: 'Fish',
          imageUrl:
          'https://pictures.grocerapps.com/original/grocerapp-fresh-st-strimps-shrimps-small-6992cf2890ec8.jpeg'),
      SubCategory(
          name: 'Seafood',
          imageUrl:
          'https://pictures.grocerapps.com/original/grocerapp-fishermens-fish-biscuit-400-692d2bb2c44ba.jpeg'),
    ],
  ),
  Category(
    name: 'Daal, Rice, Atta & Cheeni',
    description: 'Daalein, Chaawal, Salt, Brown & White Sugar',
    imageUrl:
    'https://images.unsplash.com/photo-1586201375761-83865001e31c?w=200',
    subCategories: [
      SubCategory(
          name: 'Daal',
          imageUrl:
          'https://pictures.grocerapps.com/original/grocerapp-golden-bite-moong-sabut-moti-6932d05bf36cd.jpeg'),
      SubCategory(
          name: 'Rice',
          imageUrl:
          'https://pictures.grocerapps.com/original/grocerapp-kausar-steamed-basmati-rice-66127bf2b07c6.jpeg'),
      SubCategory(
          name: 'Atta & Flour',
          imageUrl:
          'https://images.unsplash.com/photo-1574323347407-f5e1ad6d020b?w=200'),
      SubCategory(
          name: 'Sugar',
          imageUrl:
          'https://pictures.grocerapps.com/original/grocerapp-sugar-1-kg-local-68b9c7735d3f1.jpeg'),
      SubCategory(
          name: 'Salt',
          imageUrl:
          'https://images.unsplash.com/photo-1518110925495-5fe2fda0442c?w=200'),
    ],
  ),
  Category(
    name: 'Cooking Oils & Ghee',
    description: 'All types of Oils and Ghee',
    imageUrl:
    'https://images.unsplash.com/photo-1474979266404-7eaacbcd87c5?w=200',
    subCategories: [
      SubCategory(
          name: 'Cooking Oil',
          imageUrl:
          'https://images.unsplash.com/photo-1474979266404-7eaacbcd87c5?w=200'),
      SubCategory(
          name: 'Desi Ghee',
          imageUrl:
          'https://khaalis.pk/cdn/shop/files/compressed_Artboard_4_copy.png?v=1769152958'),
      SubCategory(
          name: 'Olive Oil',
          imageUrl:
          'https://pictures.grocerapps.com/original/grocerapp-mundial-olive-pomace-oil-1-68fb686019e27.png'),
      SubCategory(
          name: 'Sunflower Oil',
          imageUrl:
          'https://pictures.grocerapps.com/original/grocerapp-sufi-sunflower-cooking-oil-61a0cb81bb70a.jpeg'),
      SubCategory(
          name: 'Canola Oil',
          imageUrl:
          'https://pictures.grocerapps.com/original/grocerapp-dalda-canola-oil-pouch-5e6c9d06584cb.png'),
      SubCategory(
          name: 'Butter & Margarine',
          imageUrl:
          'https://images.unsplash.com/photo-1589985270826-4b7bb135bc9d?w=200'),
    ],
  ),
  Category(
    name: 'Snacks & Beverages',
    description: 'Chips, Drinks, Juices & More',
    imageUrl:
    'https://laxmiexportimport.com/wp-content/uploads/2024/09/Snacks-Beverages%E2%80%8B.jpg',
    subCategories: [
      SubCategory(
          name: 'Chips & Crisps',
          imageUrl:
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ_ZPcoz10uI0F2dhwpa7Xdhmu0dGDFc7yIGA&s'),
      SubCategory(
          name: 'Juices',
          imageUrl:
          'https://nazarjanssupermarket.com/cdn/shop/collections/juices-nazar-jan-s-supermarket_052841f9-44cf-495d-9681-ca3bd628401a.jpg?v=1721313172'),
      SubCategory(
          name: 'Soft Drinks',
          imageUrl:
          'https://images.unsplash.com/photo-1581636625402-29b2a704ef13?w=200'),
      SubCategory(
          name: 'Water',
          imageUrl:
          'https://images.unsplash.com/photo-1548839140-29a749e1cf4d?w=200'),
      SubCategory(
          name: 'Tea & Coffee',
          imageUrl:
          'https://springs.com.pk/cdn/shop/files/100_BTBS_1066x.png?v=1777464491'),
      SubCategory(
          name: 'Biscuits',
          imageUrl:
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSU5CSwsrYYIxRZdclYbFZDIeioixNjSvPs2A&s'),
    ],
  ),
  Category(
    name: 'Spices & Herbs',
    description: 'Spice Mixes, Powdered Spices, Herbs',
    imageUrl:
    'https://www.mccormickscienceinstitute.com/-/media/msi/reports/msispicesherbs.webp?rev=a6424d0faffd4d6bbc22748619e16497',
    subCategories: [
      SubCategory(
          name: 'Golden Bite Dhaniya Powder',
          imageUrl:
          'https://pictures.grocerapps.com/original/grocerapp-golden-bite-dhaniya-powder-50g-69390db15ce01.jpeg'),
      SubCategory(
          name: 'Turmeric Powder',
          imageUrl:
          'https://pictures.grocerapps.com/original/grocerapp-turmeric-powder--5ffd6825512b7.jpeg'),
      SubCategory(
          name: 'National Black Pepper Powder',
          imageUrl:
          'https://pictures.grocerapps.com/original/grocerapp-national-black-pepper-powder-5e6ba27ce8204.jpeg'),
      SubCategory(
          name: 'National Garam Masala Powder',
          imageUrl:
          'https://pictures.grocerapps.com/original/grocerapp-national-garam-masala-powder-5e6bc51683be5.jpeg'),
      SubCategory(
          name: 'National Garlic Powder',
          imageUrl:
          'https://pictures.grocerapps.com/original/grocerapp-national-garlic-powder-5f4ca37c1c5a1.jpeg'),
      SubCategory(
          name: 'Bakea Onion Powder',
          imageUrl:
          'https://pictures.grocerapps.com/original/grocerapp-bakea-onion-powder-66baffbf12c24.jpeg'),
    ],
  ),
  Category(
    name: 'Sauces & Pastes',
    description: 'Sauces, Ketchup, Vinegar and More',
    imageUrl:
    'https://www.chowhound.com/img/gallery/14-popular-store-bought-marinara-sauces-ranked/l-intro-1729185206.jpg',
    subCategories: [
      SubCategory(
          name: 'Mitchell Chilli Garlic Sauce',
          imageUrl:
          'https://pictures.grocerapps.com/original/grocerapp-mitchells-chilli-garlic-sauce-5ec3a77726bc8.jpeg'),
      SubCategory(
          name: 'Shangrila Garlic Chilli Sauce',
          imageUrl:
          'https://pictures.grocerapps.com/original/grocerapp-shangrila-garlic-chilli-sauce-627e4ac25683c.jpeg'),
      SubCategory(
          name: 'National Chilli Garlic Sauce',
          imageUrl:
          'https://pictures.grocerapps.com/original/grocerapp-national-chilli-garlic-sauce-pouch-5e6ced0e42272.jpeg'),
      SubCategory(
          name: 'Shangrila Habanero Ketchup Hot & Spicy',
          imageUrl:
          'https://pictures.grocerapps.com/original/grocerapp-shangrila-habanero-ketchup-hot--68fb6a6d21e69.png'),
      SubCategory(
          name: 'Young Mayonnaise',
          imageUrl:
          'https://pictures.grocerapps.com/original/grocerapp-youngs-mayoonaise-5ea04c26e7e60.jpeg'),
      SubCategory(
          name: 'Dipitt Buffalo Sauce',
          imageUrl:
          'https://pictures.grocerapps.com/original/grocerapp-dipitt-buffalo-sauce-5f1edb41cd431.jpeg'),
    ],
  ),
  Category(
    name: 'Baking & Pantry',
    description: 'Pastas, Canned Food, Custards, Baking Essentials',
    imageUrl:
    'https://iambaker.net/wp-content/uploads/2018/03/pantry-before-650x434.jpg',
    subCategories: [
      SubCategory(
          name: 'Bake Parlor Color Flavored Vermicelli',
          imageUrl:
          'https://pictures.grocerapps.com/original/grocerapp-color-flavored-vermicelli-6238041cd655d.jpeg'),
      SubCategory(
          name: 'Bakea Kheer Mix Vermacilli',
          imageUrl:
          'https://pictures.grocerapps.com/original/grocerapp-bakea-kheer-mix-vermacilli-6492a15bce5f3.png'),
      SubCategory(
          name: 'Bakea Chocomaltine Brownie Mix',
          imageUrl:
          'https://pictures.grocerapps.com/original/grocerapp-bakea-chocomaltine-brownie-mix-64929f8b3965f.png'),
      SubCategory(
          name: 'Laziza Gulab Jumun Mix',
          imageUrl:
          'https://pictures.grocerapps.com/original/grocerapp-laziza-gulab-jumun-mix-5ea3e54b57c2f.jpeg'),
      SubCategory(
          name: 'Bakea Vanilla Cake Mix',
          imageUrl:
          'https://pictures.grocerapps.com/original/grocerapp-bakea-vanilla-cake-mix-66bb03e04f181.jpeg'),
      SubCategory(
          name: 'National Banana Custard Powder',
          imageUrl:
          'https://pictures.grocerapps.com/original/grocerapp-national-banana-custard-powder-5f4c8c837fd35.jpeg'),
    ],
  ),
  Category(
    name: 'Cleaning Products & Repellents',
    description: 'Detergents, Tissue, Repellents, Laundry',
    imageUrl:
    'https://panda.com.pk/cdn/shop/files/Untitleddesign_93.png?v=1773848888&width=1445',
    subCategories: [
      SubCategory(
          name: 'SB Extreme Spiral Poly Pack 6in1',
          imageUrl:
          'https://pictures.grocerapps.com/original/grocerapp-sb-extreme-spiral-poly-pack-6980ae1a6c2aa.jpeg'),
      SubCategory(
          name: 'Sunbrite Nail Saver Single',
          imageUrl:
          'https://pictures.grocerapps.com/original/grocerapp-sunbrite-nail-saver-single-69d4ed67dd379.png'),
      SubCategory(
          name: 'Mr.Muscle Multi Purpose Cleaner',
          imageUrl:
          'https://pictures.grocerapps.com/original/grocerapp-mrmuscle-multi-purpose-cleaner-floral-698d766272221.jpeg'),
      SubCategory(
          name: 'Mr Muscle Glass Streak Free Shine',
          imageUrl:
          'https://pictures.grocerapps.com/original/grocerapp-mr-muscle-platinum-window-and-66614dd9ca58f.png'),
      SubCategory(
          name: 'Super Bleach Liquid',
          imageUrl:
          'https://pictures.grocerapps.com/original/grocerapp-super-bleach-5e6c720185cae.png'),
      SubCategory(
          name: 'Comfort Lily Fresh Fabric Conditioner',
          imageUrl:
          'https://pictures.grocerapps.com/original/grocerapp-comfort-after-wash-fabric-conditioner-60ab8c9fe30f0.jpeg'),
    ],
  ),
];



