class ApiConstants {
  static const String baseUrl = "https://la7ek-7alak.onrender.com/";

  // ربط حساب Firebase بالباك إند: يحمل رمز Firebase ويرجع رمز الباك إند.
  static const String firebaseSession = "api/firebase/session";

  // قائمة المدن (عامة، بدون تسجيل دخول) لاختيار المدينة عند التسجيل.
  static const String cities = "api/cities";

  // Authentication
  static const String register = "register";
  static const String login = "login";
  static const String verifyOtp = "verify-otp";
  static const String forgotPassword = "forgot-password";
  static const String resetPassword = "reset-password";

  // Categories & Interests
  static const String categories = "api/categories";
  static const String meInterests = "api/me/interests";

  // Home & Stores & Stories
  static const String recommendedStores = "api/stores/recommended";
  static const String recommendedStories = "api/stories/recommended";
  static const String followingStories = "api/stories/following";
  static const String followingStores = "api/stores/following";
  static const String storesMap = "api/stores/map";
  static const String banners = "api/banners";

  // Notifications
  static const String notifications = "api/notifications";
  static const String unreadNotificationsCount =
      "api/notifications/unread-count";

  // Profile Settings & Support
  static const String meSettings = "api/me/settings";
  static const String meAvatar = "api/me/avatar";
  static const String supportRequests = "api/me/support-requests";

  // Dynamic paths helpers
  static String storyDetails(String id) => "api/stories/$id";
  static String storyLike(String id) => "api/stories/$id/like";
  static String storeProfile(String storeId) => "api/stores/$storeId/profile";
  static String storeFollow(String storeId) => "api/stores/$storeId/follow";
  static String storeStories(String storeId) => "api/stores/$storeId/stories";
  static String storeAds(String storeId) => "api/stores/$storeId/ads";
  static String storeReport(String storeId) => "api/stores/$storeId/reports";
  static String notificationRead(String id) => "api/notifications/$id/read";
  static String storeNotifications(String storeId) =>
      "api/stores/$storeId/notifications";
}
