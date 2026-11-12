import 'package:flutter/material.dart';

void main() => runApp(const WenhaApp());

const Color green = Color(0xFF16834A);
const Color lightGreen = Color(0xFFE8F5EC);
const Color pageColor = Color(0xFFF7FAF8);

class WenhaApp extends StatelessWidget {
  const WenhaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'وينه؟',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: green),
        scaffoldBackgroundColor: pageColor,
        fontFamily: 'Roboto',
      ),
      home: const HomePage(),
    );
  }
}

class Product {
  final String name;
  final String price;
  final String shop;
  final String category;
  final IconData icon;

  const Product({
    required this.name,
    required this.price,
    required this.shop,
    required this.category,
    required this.icon,
  });
}

class Shop {
  final String name;
  final String area;
  final IconData icon;

  const Shop(this.name, this.area, this.icon);
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final searchController = TextEditingController();

  int selectedCategory = 0;
  int selectedPage = 0;

  final categories = const [
    'الكل',
    'هواتف',
    'إلكترونيات',
    'إكسسوارات',
    'أجهزة منزلية',
  ];

  final products = const [
    Product(
      name: 'هاتف Samsung A55',
      price: '420,000 د.ع',
      shop: 'مركز الهدى',
      category: 'هواتف',
      icon: Icons.phone_android,
    ),
    Product(
      name: 'هاتف iPhone 15',
      price: '950,000 د.ع',
      shop: 'متجر النور',
      category: 'هواتف',
      icon: Icons.phone_iphone,
    ),
    Product(
      name: 'سماعة بلوتوث',
      price: '35,000 د.ع',
      shop: 'مركز الهدى',
      category: 'إكسسوارات',
      icon: Icons.headphones,
    ),
    Product(
      name: 'ساعة ذكية',
      price: '65,000 د.ع',
      shop: 'متجر النور',
      category: 'إلكترونيات',
      icon: Icons.watch,
    ),
  ];

  final shops = const [
    Shop('مركز الهدى', 'حي الجامعة - النجف', Icons.devices),
    Shop('متجر النور', 'حي الأمير - النجف', Icons.storefront),
    Shop('أسواق المدينة', 'شارع الروان - النجف', Icons.shopping_bag),
  ];

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final query = searchController.text.trim().toLowerCase();

    final filteredProducts = products.where((product) {
      final matchesCategory = selectedCategory == 0 ||
          product.category == categories[selectedCategory];

      final matchesSearch = query.isEmpty ||
          product.name.toLowerCase().contains(query) ||
          product.shop.toLowerCase().contains(query) ||
          product.category.toLowerCase().contains(query);

      return matchesCategory && matchesSearch;
    }).toList();

    final filteredShops = shops.where((shop) {
      return query.isEmpty ||
          shop.name.toLowerCase().contains(query) ||
          shop.area.toLowerCase().contains(query);
    }).toList();

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.only(bottom: 20),
            children: [
              _buildHeader(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 22),
                    const Text(
                      'شنو تريد تشتري اليوم؟',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF183B2A),
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'ابحث وقارن الأسعار في محلات النجف',
                      style: TextStyle(color: Colors.black54),
                    ),
                    const SizedBox(height: 16),
                    _buildSearch(),
                    const SizedBox(height: 24),
                    _buildSectionTitle('الأقسام', 'تصفح المنتجات'),
                    const SizedBox(height: 12),
                    _buildCategories(),
                    const SizedBox(height: 25),
                    _buildSectionTitle('منتجات مقترحة', 'عرض الكل'),
                    const SizedBox(height: 12),
                    if (filteredProducts.isEmpty)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.all(24),
                          child: Text('ما لقينا منتجات. جرّب كلمة ثانية.'),
                        ),
                      )
                    else
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: filteredProducts.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 0.78,
                        ),
                        itemBuilder: (context, index) {
                          return _buildProductCard(filteredProducts[index]);
                        },
                      ),
                    const SizedBox(height: 25),
                    _buildSectionTitle('محلات قريبة', 'كل المحلات'),
                    const SizedBox(height: 10),
                    ...filteredShops.map(_buildShopCard),
                    const SizedBox(height: 16),
                    _buildAddShopButton(),
                    const SizedBox(height: 12),
                    const Center(
                      child: Text(
                        'الأسعار والمحلات الظاهرة حالياً تجريبية',
                        style: TextStyle(
                          color: Colors.black45,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: NavigationBar(
          selectedIndex: selectedPage,
          backgroundColor: Colors.white,
          indicatorColor: lightGreen,
          onDestinationSelected: (index) {
            setState(() => selectedPage = index);
            if (index != 0) {
              showMessage('هذا القسم سيتم تفعيله في مرحلة قادمة');
            }
          },
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home, color: green),
              label: 'الرئيسية',
            ),
            NavigationDestination(
              icon: Icon(Icons.favorite_border),
              label: 'المفضلة',
            ),
            NavigationDestination(
              icon: Icon(Icons.map_outlined),
              label: 'الخريطة',
            ),
            NavigationDestination(
              icon: Icon(Icons.person_outline),
              label: 'حسابي',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 25),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF16834A), Color(0xFF086638)],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(25),
        ),
      ),
      child: Row(
        children: [
          const Icon(Icons.location_on_outlined,
              color: Colors.white, size: 29),
          const SizedBox(width: 7),
          const Text(
            'وينه؟',
            style: TextStyle(
              color: Colors.white,
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.16),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              children: [
                Icon(Icons.location_on, color: Colors.white, size: 16),
                SizedBox(width: 4),
                Text(
                  'النجف الأشرف',
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            onPressed: () => showMessage('الحساب سيكون متاحاً قريباً'),
            icon: const Icon(Icons.person_outline, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildSearch() {
    return TextField(
      controller: searchController,
      onChanged: (_) => setState(() {}),
      decoration: InputDecoration(
        hintText: 'ابحث عن هاتف أو منتج أو محل...',
        hintStyle: const TextStyle(fontSize: 13),
        prefixIcon: const Icon(Icons.search, color: green),
        suffixIcon: IconButton(
          onPressed: () {
            searchController.clear();
            setState(() {});
          },
          icon: const Icon(Icons.close, size: 19),
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(vertical: 15),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, String action) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Spacer(),
        TextButton(
          onPressed: () => showMessage('سيتم عرض المزيد قريباً'),
          child: Text(
            action,
            style: const TextStyle(color: green, fontSize: 12),
          ),
        ),
      ],
    );
  }

  Widget _buildCategories() {
    return SizedBox(
      height: 43,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final selected = selectedCategory == index;
          return ChoiceChip(
            label: Text(categories[index]),
            selected: selected,
            onSelected: (_) {
              setState(() => selectedCategory = index);
            },
            selectedColor: green,
            backgroundColor: Colors.white,
            labelStyle: TextStyle(
              color: selected ? Colors.white : Colors.black87,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
            side: BorderSide(
              color: selected ? green : Colors.black12,
            ),
            showCheckmark: false,
          );
        },
      ),
    );
  }

  Widget _buildProductCard(Product product) {
    return InkWell(
      borderRadius: BorderRadius.circular(17),
      onTap: () => showMessage(
        '${product.name} - ${product.price} لدى ${product.shop}',
      ),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(17),
          border: Border.all(color: const Color(0xFFEAF0EC)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: lightGreen,
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Icon(
                  product.icon,
                  size: 55,
                  color: green,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              product.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              product.price,
              style: const TextStyle(
                color: green,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.store_outlined,
                    size: 13, color: Colors.black45),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    product.shop,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 11,
                      color: Colors.black54,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShopCard(Shop shop) {
    return Container(
      margin: const EdgeInsets.only(bottom: 9),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: const Color(0xFFEAF0EC)),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: lightGreen,
          child: Icon(shop.icon, color: green),
        ),
        title: Text(
          shop.name,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        subtitle: Row(
          children: [
            const Icon(Icons.location_on_outlined,
                size: 14, color: Colors.black45),
            const SizedBox(width: 3),
            Text(shop.area, style: const TextStyle(fontSize: 11)),
          ],
        ),
        trailing: const Icon(Icons.chevron_left, color: green),
        onTap: () => showMessage('معلومات المحل التفصيلية ستُضاف لاحقاً'),
      ),
    );
  }

  Widget _buildAddShopButton() {
    return OutlinedButton.icon(
      onPressed: () => showMessage('سيتم تفعيل تسجيل المحلات في مرحلة قادمة'),
      icon: const Icon(Icons.add_business),
      label: const Text('أضف محلك إلى وينه؟'),
      style: OutlinedButton.styleFrom(
        foregroundColor: green,
        side: const BorderSide(color: green),
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    );
  }
}
