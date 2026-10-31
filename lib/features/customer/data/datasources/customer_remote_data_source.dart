import 'package:dio/dio.dart';
import '../../../../core/constants/api_constants.dart';
import '../models/banners/banners_response.dart';
import '../models/categories/category_model.dart';
import '../models/categories/save_interests_request_model.dart';
import '../models/categories/user_interests_model.dart';
import '../../domain/entities/customer_profile.dart';
import '../models/notifications/notifications_response.dart';
import '../models/settings/account_settings_model.dart';
import '../models/stories/recommended_stories_response.dart';
import '../models/stores/follow_response.dart';
import '../models/stores/following_stores_response.dart';
import '../models/stores/map_stores_response.dart';
import '../models/stores/recommended_stores_response.dart';
import '../models/stores/store_ads_response.dart';
import '../models/stores/store_profile_model.dart';

// يجلب ويحفظ بيانات الزبون من الخادم.
class CustomerRemoteDataSource {
  final Dio dio;

  CustomerRemoteDataSource(this.dio);

  // يجلب كل التصنيفات المتاحة لشاشة الاهتمامات.
  Future<List<CategoryModel>> getCategories() async {
    final response = await dio.get(ApiConstants.categories);
    return (response.data as List)
        .map((e) => CategoryModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  // يجلب اهتمامات الزبون المحفوظة.
  Future<UserInterestsModel> getMyInterests() async {
    final response = await dio.get(ApiConstants.meInterests);
    return UserInterestsModel.fromJson(response.data as Map<String, dynamic>);
  }

  // يحفظ التصنيفات المختارة (يستبدل القائمة كاملة).
  Future<UserInterestsModel> saveMyInterests(
    SaveInterestsRequestModel request,
  ) async {
    final response = await dio.put(
      ApiConstants.meInterests,
      data: request.toJson(),
    );
    return UserInterestsModel.fromJson(response.data as Map<String, dynamic>);
  }

  // يجلب صفحة من المتاجر المقترحة، المطابقة لاهتمامات الزبون أولًا.
  Future<RecommendedStoresResponse> getRecommendedStores({int page = 1}) async {
    final response = await dio.get(
      ApiConstants.recommendedStores,
      queryParameters: {'page': page},
    );
    return RecommendedStoresResponse.fromJson(
      response.data as Map<String, dynamic>,
    );
  }

  // يجلب صفحة من القصص النشطة للمتاجر التي يتابعها الزبون فقط.
  // شكل القصة نفس شكلها في recommended.
  Future<RecommendedStoriesResponse> getFollowingStories({int page = 1}) async {
    final response = await dio.get(
      ApiConstants.followingStories,
      queryParameters: {'page': page},
    );
    return RecommendedStoriesResponse.fromJson(
      response.data as Map<String, dynamic>,
    );
  }

  // يجلب المتاجر الظاهرة داخل حدود الخريطة.
  Future<MapStoresResponse> getMapStores({
    required double south,
    required double north,
    required double west,
    required double east,
  }) async {
    final response = await dio.get(
      ApiConstants.storesMap,
      queryParameters: {
        'south': south,
        'north': north,
        'west': west,
        'east': east,
      },
    );
    return MapStoresResponse.fromJson(response.data);
  }

  // يجلب بانرات الإعلانات النشطة في الرئيسية.
  Future<BannersResponse> getBanners() async {
    final response = await dio.get(ApiConstants.banners);
    return BannersResponse.fromJson(response.data as Map<String, dynamic>);
  }

  // يجلب صفحة من القصص النشطة، المطابقة لاهتمامات الزبون أولًا.
  Future<RecommendedStoriesResponse> getRecommendedStories({
    int page = 1,
  }) async {
    final response = await dio.get(
      ApiConstants.recommendedStories,
      queryParameters: {'page': page},
    );
    return RecommendedStoriesResponse.fromJson(
      response.data as Map<String, dynamic>,
    );
  }

  // يفتح القصة فيسجّل الخادم مشاهدة واحدة لكل زبون. محتوى الرد غير مطلوب.
  Future<void> viewStory(String storyId) async {
    await dio.get(ApiConstants.storyDetails(storyId));
  }

  // يسجّل إعجاب الزبون بالقصة.
  Future<void> likeStory(String storyId) async {
    await dio.post(ApiConstants.storyLike(storyId));
  }

  // يلغي إعجاب الزبون بالقصة.
  Future<void> unlikeStory(String storyId) async {
    await dio.delete(ApiConstants.storyLike(storyId));
  }

  // يجلب بيانات صفحة المتجر (يسجّل الخادم زيارة).
  Future<StoreProfileModel> getStoreProfile(String storeId) async {
    final response = await dio.get(ApiConstants.storeProfile(storeId));
    return StoreProfileModel.fromJson(response.data as Map<String, dynamic>);
  }

  // يجلب قصص المتجر النشطة. الرد {items, total} فيُقرأ بنفس قارئ القصص.
  Future<RecommendedStoriesResponse> getStoreStories(String storeId) async {
    final response = await dio.get(ApiConstants.storeStories(storeId));
    return RecommendedStoriesResponse.fromJson(
      response.data as Map<String, dynamic>,
    );
  }

  // يجلب إعلانات المتجر النشطة.
  Future<StoreAdsResponse> getStoreAds(String storeId) async {
    final response = await dio.get(ApiConstants.storeAds(storeId));
    return StoreAdsResponse.fromJson(response.data as Map<String, dynamic>);
  }

  // يرسل بلاغًا عن المتجر كاملًا. [reason]: price_mismatch |
  // fake_or_expired | inappropriate_content (الخادم يرفض غيرها).
  Future<void> reportStore(String storeId, String reason) async {
    await dio.post(ApiConstants.storeReport(storeId), data: {'reason': reason});
  }

  // يوقف إشعارات متجر يتابعه الزبون أو يفعّلها (زر الجرس).
  // الرد: {storeId, isMuted, message}. الخادم يرجع 404 إن لم يكن متابِعًا.
  Future<bool> setStoreNotificationsMuted(String storeId, bool isMuted) async {
    final response = await dio.patch(
      ApiConstants.storeNotifications(storeId),
      data: {'isMuted': isMuted},
    );
    final data = response.data;
    return data is Map ? ((data['isMuted'] as bool?) ?? isMuted) : isMuted;
  }

  // يعلّم الإشعار مقروءًا. الخادم يرجع 404 إن لم يجده.
  Future<void> markNotificationRead(String id) async {
    await dio.patch(ApiConstants.notificationRead(id));
  }

  // يجلب إشعارات الزبون.
  Future<NotificationsResponse> getNotifications() async {
    final response = await dio.get(ApiConstants.notifications);
    return NotificationsResponse.fromJson(
      response.data as Map<String, dynamic>,
    );
  }

  // عدد الإشعارات غير المقروءة. الرد: {success, count}.
  Future<int> getUnreadNotificationsCount() async {
    final response = await dio.get(ApiConstants.unreadNotificationsCount);
    final data = response.data;
    return data is Map ? ((data['count'] as num?)?.toInt() ?? 0) : 0;
  }

  // يجلب بيانات الزبون وتفضيلات إشعاراته.
  Future<AccountSettingsModel> getAccountSettings() async {
    final response = await dio.get(ApiConstants.meSettings);
    return AccountSettingsModel.fromJson(response.data as Map<String, dynamic>);
  }

  // يرفع صورة الزبون: POST api/me/avatar بـ form-data، الحقل avatar.
  // نسمّي الملف باسم إنجليزي ثابت لأن التخزين يرفض الأسماء العربية والمسافات،
  // ونلغي Content-Type: application/json الافتراضي حتى يُرسل كـ multipart.
  // يرجع رابط الصورة الجديد إن وُجد في الرد.
  Future<String?> uploadAvatar(String filePath) async {
    final extension = filePath.toLowerCase().endsWith('.png') ? 'png' : 'jpg';
    final form = FormData.fromMap({
      'avatar': await MultipartFile.fromFile(
        filePath,
        filename: 'avatar.$extension',
      ),
    });
    final response = await dio.post(
      ApiConstants.meAvatar,
      data: form,
      options: Options(contentType: Headers.multipartFormDataContentType),
    );
    final data = response.data;
    if (data is! Map) return null;
    final profile = data['profile'];
    final nested = data['data'];
    return (data['avatarUrl'] ??
        (profile is Map ? profile['avatarUrl'] : null) ??
        (nested is Map ? nested['avatarUrl'] : null) ??
        data['url']) as String?;
  }

  // يحفظ الإعدادات؛ إن رجع الخادم الإعدادات المحفوظة نقرأها، وإلا نعيد ما أرسلناه.
  Future<AccountSettingsModel?> updateAccountSettings(
    AccountSettings settings,
  ) async {
    final response = await dio.put(
      ApiConstants.meSettings,
      data: AccountSettingsModel.toUpdateJson(settings),
    );
    final data = response.data;
    return data is Map<String, dynamic> && data['profile'] != null
        ? AccountSettingsModel.fromJson(data)
        : null;
  }

  // يرسل رسالة للدعم الفني: {title (3–120 حرفًا), message}.
  // contactMethod اختياري في الخادم ولا يوجد في التصميم فلا نرسله.
  Future<void> sendSupportRequest({
    required String title,
    required String message,
  }) async {
    await dio.post(
      ApiConstants.supportRequests,
      data: {'title': title, 'message': message},
    );
  }

  // يجلب صفحة من المتاجر التي يتابعها الزبون.
  Future<FollowingStoresResponse> getFollowingStores({int page = 1}) async {
    final response = await dio.get(
      ApiConstants.followingStores,
      queryParameters: {'page': page},
    );
    return FollowingStoresResponse.fromJson(
      response.data as Map<String, dynamic>,
    );
  }

  // يتابع المتجر ويرجع حالة المتابعة وعدد المتابعين الحقيقي.
  Future<FollowResponse> followStore(String storeId) async {
    final response = await dio.post(ApiConstants.storeFollow(storeId));
    return FollowResponse.fromJson(response.data, fallbackFollowing: true);
  }

  // يلغي متابعة المتجر.
  Future<FollowResponse> unfollowStore(String storeId) async {
    final response = await dio.delete(ApiConstants.storeFollow(storeId));
    return FollowResponse.fromJson(response.data, fallbackFollowing: false);
  }
}
