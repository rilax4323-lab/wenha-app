import 'package:flutter/material.dart';

void main() => runApp(const WenhaApp());

class WenhaApp extends StatelessWidget {
  const WenhaApp({super.key});

  @override
  Widget build(BuildContext context) {
    const green = Color(0xFF16834A);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'وينه؟',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: green),
        scaffoldBackgroundColor: const Color(0xFFF7FAF8),
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      home: const HomePage(),
    );
  }
}

class Shop {
  final String name;
  final String area;
  final String category;
  final IconData icon;
  const Shop(this.name, this.area, this.category, this.icon);
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final searchController = TextEditingController();
  final shops = const [
    Shop('متجر النور', 'حي الأمير - النجف', 'مواد منزلية', Icons.storefront),
    Shop('أسواق المدينة', 'شارع الروان - النجف', 'مواد غذائية', Icons.shopping_basket),
    Shop('مركز الهدى', 'حي الجامعة - النجف', 'إلكترونيات', Icons.devices),
  ];

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final q = searchController.text.trim();
    final filtered = shops.where((s) =>
      q.isEmpty || '${s.name} ${s.area} ${s.category}'.contains(q)).toList();

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF16834A),
          foregroundColor: Colors.white,
          title: const Row(
            children: [
              Icon(Icons.location_on_outlined, size: 27),
              SizedBox(width: 7),
              Text('وينه؟', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 23)),
            ],
          ),
          actions: [
            IconButton(
              tooltip: 'الحساب',
              onPressed: () => _message('تسجيل حساب المحل سيكون متاحاً في النسخة القادمة'),
              icon: const Icon(Icons.person_outline),
            ),
          ],
        ),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text('دَوّر على المنتج أو المحل', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            const Text('اعرف وين تلقاه وقارن الأسعار في النجف', style: TextStyle(color: Colors.black54)),
            const SizedBox(height: 18),
            TextField(
              controller: searchController,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                hintText: 'اكتب اسم المنتج أو المحل أو المنطقة',
                prefixIcon: const Icon(Icons.search, color: Color(0xFF16834A)),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 22),
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: const Color(0xFFE5F4EB),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Row(
                children: [
                  Icon(Icons.store_mall_directory_outlined, size: 42, color: Color(0xFF16834A)),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('محلات النجف بمكان واحد', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                        SizedBox(height: 4),
                        Text('ابحث واكتشف المحلات القريبة منك'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),
            const Text('محلات مقترحة', style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            if (filtered.isEmpty)
              const Padding(
                padding: EdgeInsets.all(22),
                child: Center(child: Text('ما لقينا نتائج. جرّب كلمة ثانية.')),
              ),
            ...filtered.map((shop) => Card(
              color: Colors.white,
              elevation: 0.5,
              margin: const EdgeInsets.only(bottom: 10),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: const Color(0xFFE5F4EB),
                  child: Icon(shop.icon, color: const Color(0xFF16834A)),
                ),
                title: Text(shop.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text('${shop.category} • ${shop.area}'),
                trailing: const Icon(Icons.chevron_left),
                onTap: () => _message('هذا محل تجريبي. ستُضاف بيانات المحلات الحقيقية بعد التسجيل والتحقق.'),
              ),
            )),
            const SizedBox(height: 14),
            OutlinedButton.icon(
              onPressed: () => _message('سيتم تفعيل إضافة المحلات بعد تجهيز الحسابات وقاعدة البيانات.'),
              icon: const Icon(Icons.add_business),
              label: const Text('أضف محلك إلى وينه؟'),
            ),
            const SizedBox(height: 12),
            const Text(
              'تنبيه: المحلات الظاهرة حالياً بيانات تجريبية وليست نقاط بيع حقيقية.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }

  void _message(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }
}
