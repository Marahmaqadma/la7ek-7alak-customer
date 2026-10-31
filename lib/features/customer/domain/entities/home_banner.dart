// بانر في رئيسية الزبون؛ الضغط عليه يفتح صفحة المتجر صاحب الإعلان.
class HomeBanner {
  final String imageUrl;
  // بدون متجر لا يفتح البانر شيئًا.
  final String? storeId;

  const HomeBanner({required this.imageUrl, this.storeId});
}
