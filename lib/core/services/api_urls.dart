class ApiUrls {
  static const String baseUrl = "https://beta.checkaroundme.com/api/v1";

  // Auth endpoints
  static const String register = "$baseUrl/auth/register";
  static const String login = "$baseUrl/auth/login";
  static const String requestPasswordReset = "$baseUrl/auth/request-password-reset";
  static const String getCurrentUser = "$baseUrl/auth/me";
  static const String logout = "$baseUrl/auth/logout";
  static String getUserById(String userId) => "$baseUrl/users/$userId";
  static String getUserProfileById(String userId) => "$baseUrl/users/$userId/profile";
  static const String updateUser = "$baseUrl/users/me";
  static const String getUserSettings = "$baseUrl/users/me/settings";

  // Review endpoints
  static const String createReview = "$baseUrl/reviews";
  static String getBusinessReviews(String businessId) => "$baseUrl/businesses/$businessId/reviews";

  // Message endpoints
  static const String sendMessage = "$baseUrl/messages";
  static String getConversationMessages(String conversationId) => "$baseUrl/conversations/$conversationId/messages";

  // Business endpoints
  static const String createBusiness = "$baseUrl/businesses";
  static const String listBusinesses = "$baseUrl/businesses";
  static String getBusinessById(String businessId) => "$baseUrl/businesses/$businessId";
  static const String listMyBusinesses = "$baseUrl/businesses/my";

  // Category endpoints
  static const String createCategory = "$baseUrl/categories";
  static const String getAllCategories = "$baseUrl/categories";
  static String getCategoryById(String categoryId) => "$baseUrl/categories/$categoryId";

  // Conversation endpoints
  static const String getOrCreateConversation = "$baseUrl/conversations";
  static String getUserConversations(String userId) => "$baseUrl/users/$userId/conversations";

  // Location endpoints
  static const String getCountries = "$baseUrl/locations/countries";

  // Notification endpoints
  static const String getNotifications = "$baseUrl/notifications";
  static String markNotificationAsRead(String notificationId) => "$baseUrl/notifications/$notificationId/read";
  static const String markAllNotificationsAsRead = "$baseUrl/notifications/read-all";

  // Booking endpoints
  static const String createBooking = "$baseUrl/bookings";
  static String createBookingPayment(String bookingId) => "$baseUrl/bookings/$bookingId/payment";
  static String updateBookingStatus(String bookingId) => "$baseUrl/bookings/$bookingId/status";
  static String getBookingById(String bookingId) => "$baseUrl/bookings/$bookingId";
  static const String listMyBookings = "$baseUrl/bookings/my";
  static String listBusinessBookings(String businessId) => "$baseUrl/businesses/$businessId/bookings";
  static const String verifyBookingPayment = "$baseUrl/bookings/verify-payment";
}