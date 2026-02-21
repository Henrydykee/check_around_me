import '../utils/app_config.dart';

class ApiUrls {
  static String get baseUrl => AppConfig.baseUrl;

  // Auth endpoints
  static String get register => "$baseUrl/auth/register";
  static String get login => "$baseUrl/auth/login";
  static String get requestPasswordReset => "$baseUrl/auth/request-password-reset";
  static String get getCurrentUser => "$baseUrl/auth/me";
  static String get logout => "$baseUrl/auth/logout";
  static String getUserById(String userId) => "$baseUrl/users/$userId";
  static String getUserProfileById(String userId) => "$baseUrl/users/$userId/profile";
  static String get updateUser => "$baseUrl/users/me";
  static String get getUserSettings => "$baseUrl/users/me/settings";

  // Review endpoints
  static String get createReview => "$baseUrl/reviews";
  static String getBusinessReviews(String businessId) => "$baseUrl/businesses/$businessId/reviews";

  // Message endpoints
  static String get sendMessage => "$baseUrl/messages";
  static String getConversationMessages(String conversationId) => "$baseUrl/conversations/$conversationId/messages";

  // Business endpoints
  static String get createBusiness => '$baseUrl/businesses';
  static String get listBusinesses => "$baseUrl/businesses";
  static String getBusinessById(String businessId) => "$baseUrl/businesses/$businessId";
  static String get listMyBusinesses => "$baseUrl/businesses/my";

  // Category endpoints
  static String get createCategory => "$baseUrl/categories";
  static String get getAllCategories => "$baseUrl/categories";
  static String get getPopularCategories => "$baseUrl/categories/popular";
  static String getCategoryById(String categoryId) => "$baseUrl/categories/$categoryId";

  // Conversation endpoints
  static String get getOrCreateConversation => "$baseUrl/conversations";
  static String getUserConversations(String userId) => "$baseUrl/users/$userId/conversations";

  // Location endpoints
  static String get getCountries => "$baseUrl/locations/countries";

  // Notification endpoints
  static String get getNotifications => "$baseUrl/notifications";
  static String markNotificationAsRead(String notificationId) => "$baseUrl/notifications/$notificationId/read";
  static String get markAllNotificationsAsRead => "$baseUrl/notifications/read-all";

  // Booking endpoints
  static String get createBooking => "$baseUrl/bookings";
  static String createBookingPayment(String bookingId) => "$baseUrl/bookings/$bookingId/payment";
  static String updateBookingStatus(String bookingId) => "$baseUrl/bookings/$bookingId/status";
  static String get updateBookingStatusLegacy => "${baseUrl.replaceAll('/v1', '')}/updateBookingStatus";
  static String getBookingById(String bookingId) => "$baseUrl/bookings/$bookingId";
  static String get listMyBookings => "$baseUrl/bookings/my";
  static String listBusinessBookings(String businessId) => "$baseUrl/businesses/$businessId/bookings";
  static String get verifyBookingPayment => "$baseUrl/bookings/verify-payment";

  // Upload endpoints
  static String get uploadImages => "${baseUrl.replaceAll('/v1', '')}/upload/images";
}