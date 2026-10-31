import 'package:dartz/dartz.dart';
import 'package:la7ek_7alak/core/error/error_handler.dart';
import '../entities/app_notification.dart';
import '../entities/customer_profile.dart';
import '../entities/follow_status.dart';
import '../entities/home_banner.dart';
import '../entities/map_store.dart';
import '../entities/followed_store.dart';
import '../entities/store_category.dart';
import '../entities/store_profile.dart';
import '../entities/store_story.dart';
import '../entities/suggested_store.dart';

abstract class CustomerRepository {
  Future<Either<ErrorHandler, List<StoreCategory>>> getCategories();

  // أرقام التصنيفات التي اختارها الزبون.
  Future<Either<ErrorHandler, List<int>>> getMyInterests();

  // يستبدل اختيارات الزبون كاملة ويرجع المحفوظ فعلًا.
  Future<Either<ErrorHandler, List<int>>> saveMyInterests(
    List<int> categoryIds,
  );

  // المتاجر المقترحة في الرئيسية، المطابقة لاهتمامات الزبون أولًا.
  Future<Either<ErrorHandler, List<SuggestedStore>>> getRecommendedStores();

  // المتاجر ذات الإحداثيات داخل حدود الخريطة الظاهرة.
  Future<Either<ErrorHandler, List<MapStore>>> getMapStores({
    required double south,
    required double north,
    required double west,
    required double east,
  });

  // بانرات الإعلانات النشطة في الرئيسية.
  Future<Either<ErrorHandler, List<HomeBanner>>> getBanners();

  // القصص النشطة مجمّعة حسب المتجر، المطابقة لاهتمامات الزبون أولًا.
  Future<Either<ErrorHandler, List<StoreStory>>> getRecommendedStories();

  // القصص النشطة للمتاجر المتابَعة فقط، مجمّعة حسب المتجر.
  Future<Either<ErrorHandler, List<StoreStory>>> getFollowingStories();

  // يسجّل مشاهدة القصة للزبون.
  Future<Either<ErrorHandler, Unit>> viewStory(String storyId);

  // يسجّل الإعجاب بالقصة أو يلغيه.
  Future<Either<ErrorHandler, Unit>> setStoryLiked(String storyId, bool liked);

  Future<Either<ErrorHandler, StoreProfile>> getStoreProfile(String storeId);

  // قصص المتجر النشطة (تبويب العروض النشطة في صفحة المتجر).
  Future<Either<ErrorHandler, List<StoryItem>>> getStoreStories(String storeId);

  // إعلانات المتجر النشطة (تبويب الإعلانات في صفحة المتجر).
  Future<Either<ErrorHandler, List<StoreAd>>> getStoreAds(String storeId);

  Future<Either<ErrorHandler, Unit>> reportStore(String storeId, String reason);

  // يوقف إشعارات المتجر أو يفعّلها؛ يرجع حالة الكتم من الخادم.
  Future<Either<ErrorHandler, bool>> setStoreNotificationsMuted(
    String storeId,
    bool isMuted,
  );

  // إشعارات الزبون، الأحدث أولًا.
  Future<Either<ErrorHandler, List<AppNotification>>> getNotifications();

  Future<Either<ErrorHandler, int>> getUnreadNotificationsCount();

  Future<Either<ErrorHandler, Unit>> markNotificationRead(String id);

  // اسم الزبون وجواله وتفضيلات إشعاراته.
  Future<Either<ErrorHandler, AccountSettings>> getAccountSettings();

  // يرفع صورة الزبون من مسار على الجهاز؛ يرجع رابطها الجديد إن أرسله الخادم.
  Future<Either<ErrorHandler, String?>> uploadAvatar(String filePath);

  // يحفظ الإعدادات ويرجع ما حُفظ.
  Future<Either<ErrorHandler, AccountSettings>> updateAccountSettings(
    AccountSettings settings,
  );

  Future<Either<ErrorHandler, Unit>> sendSupportRequest({
    required String title,
    required String message,
  });

  // المتاجر التي يتابعها الزبون.
  Future<Either<ErrorHandler, List<FollowedStore>>> getFollowingStores();

  Future<Either<ErrorHandler, FollowStatus>> followStore(String storeId);

  Future<Either<ErrorHandler, FollowStatus>> unfollowStore(String storeId);
}
