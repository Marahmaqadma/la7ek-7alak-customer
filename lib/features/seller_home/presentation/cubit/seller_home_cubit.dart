import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

part 'seller_home_state.dart';

// يدير تبويبات التاجر والعروض داخل الذاكرة؛ لا يحفظ العروض في الخادم.
class SellerHomeCubit extends Cubit<SellerHomeState> {
  final ImagePicker imagePicker;

  SellerHomeCubit({ImagePicker? imagePicker})
      : imagePicker = imagePicker ?? ImagePicker(),
        super(const SellerHomeState());

  // يصدر حالة جديدة تحمل رقم التبويب الذي اختاره المستخدم.
  void changeTab(int index) {
    emit(state.copyWith(selectedTabIndex: index));
  }

  // يحذف العرض من القائمة المحلية ويحدّث عدد العروض النشطة.
  void deleteOffer(String offerId) {
    final updatedOffers = state.offers
        .where((offer) => offer.id != offerId)
        .toList(growable: false);

    emit(
      state.copyWith(
        offers: updatedOffers,
        activeOffersCount: updatedOffers.length.toString(),
      ),
    );
  }

  // يختار صورة لمسودة العرض؛ إلغاء الاختيار يبقي المسودة كما هي.
  Future<void> pickDraftOfferImage(ImageSource source) async {
    final image = await imagePicker.pickImage(source: source);

    if (image == null) return;

    emit(state.copyWith(draftOfferImagePath: image.path));
  }

  // يضيف العرض إلى القائمة المحلية ويعود للرئيسية ويفرغ صورة المسودة.
  void publishOffer({
    required String title,
    String? details,
  }) {
    final offer = SellerOffer(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      details: details,
      publishedAt: 'تاريخ النشر: الآن',
      views: '0 مشاهدة',
      imagePath:
          state.draftOfferImagePath ?? 'assets/images/seller_offer_pizza.png',
    );

    // إضافة العرض الجديد في بداية القائمة المحلية؛ لا يوجد طلب حفظ في الخادم هنا.
    final updatedOffers = [offer, ...state.offers];

    emit(
      state.copyWith(
        selectedTabIndex: 0,
        offers: updatedOffers,
        activeOffersCount: updatedOffers.length.toString(),
        // إفراغ صورة المسودة بعد النشر حتى لا تُستخدم تلقائيًا للعرض التالي.
        clearDraftOfferImagePath: true,
      ),
    );
  }
}
