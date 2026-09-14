import 'package:flutter/material.dart';
import 'package:la7ek_7alak/core/theme/app_colors.dart';
import '../widgets/followed_stores_widgets/followed_stores_header.dart';
import '../widgets/followed_stores_widgets/followed_store_card.dart';
import '../widgets/followed_stores_widgets/custom_bottom_nav_bar.dart';

class FollowedStoresPage extends StatefulWidget {
  const FollowedStoresPage({super.key});

  @override
  State<FollowedStoresPage> createState() => _FollowedStoresPageState();
}

class _FollowedStoresPageState extends State<FollowedStoresPage> {
  final List<Map<String, dynamic>> stores = [
    {
      'name': 'بيتزا البرنس',
      'offer': 'آخر عرض: خصم 30% عائلي 🍕',
      'icon': Icons.local_pizza_outlined,
    },
    {
      'name': 'مطعم العمدة',
      'offer': 'آخر عرض: وجبة فردية بـ 15 شيكل 🍗',
      'icon': Icons.fastfood_outlined,
    },
    {
      'name': 'أناقة سبورت',
      'offer': 'آخر عرض: شحن مجاني اليوم 📦',
      'icon': Icons.shopping_bag_outlined,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pageBackground,
      body: SafeArea(
        child: Column(
          children: [
            FollowedStoresHeader(
              onSearchPressed: () {
                // كود البحث مستقبلاً
              },
            ),
            Expanded(
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: stores.length,
                itemBuilder: (context, index) {
                  final store = stores[index];
                  return FollowedStoreCard(
                    storeName: store['name'],
                    storeOffer: store['offer'],
                    storeIcon: store['icon'],
                    onTap: () {
                      // الكود عند الضغط على البطاقة
                    },
                    onStoryTap: () {
                      // الكود عند الضغط على الستوري
                    },
                    onUnfollow: () {
                      setState(() {
                        stores.removeAt(index);
                      });
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const CustomBottomNavBar(),
    );
  }
}
