part of 'seller_home_cubit.dart';

// بيانات واجهة التاجر؛ تبدأ بقيم وعروض تجريبية لعرض التصميم.
class SellerHomeState {
  final int selectedTabIndex;
  final String storeName;
  final String storeLocation;
  final String storeStatus;
  final String followersCount;
  final String activeOffersCount;
  final String viewsCount;
  final List<SellerOffer> offers;
  final String? draftOfferImagePath;

  const SellerHomeState({
    this.selectedTabIndex = 0,
    this.storeName = 'بيتزا البرنس',
    this.storeLocation = 'وسط مخيم النصيرات - النصيرات',
    this.storeStatus = 'نشط',
    this.followersCount = '1,240',
    this.activeOffersCount = '2',
    this.viewsCount = '3.5K',
    this.draftOfferImagePath,
    // عروض افتراضية لتجربة الواجهة قبل ربط البيانات بخدمة خارجية.
    this.offers = const [
      SellerOffer(
        id: 'family-pizza',
        title: 'خصم 30% على الوجبات العائلية',
        details: 'عرض اليوم على الوجبات العائلية',
        publishedAt: 'تاريخ النشر: اليوم، 12:00 م',
        views: '342 مشاهدة',
        imagePath: 'assets/images/seller_offer_pizza.png',
      ),
      SellerOffer(
        id: 'free-drink',
        title: 'مشروب مجاني مع أي بيتزا وسط',
        details: 'هدية مع كل طلب بيتزا وسط',
        publishedAt: 'تاريخ النشر: أمس، 06:00 م',
        views: '189 مشاهدة',
        imagePath: 'assets/images/seller_offer_drink.png',
      ),
    ],
  });

  // ينشئ نسخة من الحالة بالقيم الجديدة ويحافظ على بقية القيم.
  SellerHomeState copyWith({
    int? selectedTabIndex,
    String? storeName,
    String? storeLocation,
    String? storeStatus,
    String? followersCount,
    String? activeOffersCount,
    String? viewsCount,
    List<SellerOffer>? offers,
    String? draftOfferImagePath,
    bool clearDraftOfferImagePath = false,
  }) {
    return SellerHomeState(
      selectedTabIndex: selectedTabIndex ?? this.selectedTabIndex,
      storeName: storeName ?? this.storeName,
      storeLocation: storeLocation ?? this.storeLocation,
      storeStatus: storeStatus ?? this.storeStatus,
      followersCount: followersCount ?? this.followersCount,
      activeOffersCount: activeOffersCount ?? this.activeOffersCount,
      viewsCount: viewsCount ?? this.viewsCount,
      offers: offers ?? this.offers,
      // العلم المنفصل يسمح بمسح الصورة، لأن null وحدها تعني الاحتفاظ بالقيمة القديمة.
      draftOfferImagePath: clearDraftOfferImagePath
          ? null
          : draftOfferImagePath ?? this.draftOfferImagePath,
    );
  }
}

// البيانات اللازمة لعرض بطاقة عرض واحد وصورته وإحصاءاته.
class SellerOffer {
  final String id;
  final String title;
  final String? details;
  final String publishedAt;
  final String views;
  final String imagePath;

  const SellerOffer({
    required this.id,
    required this.title,
    this.details,
    required this.publishedAt,
    required this.views,
    required this.imagePath,
  });
}
