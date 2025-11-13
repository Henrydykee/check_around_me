class ApiUrls {
  static const String baseUrl = "https://carmaat.fly.dev/api";

  // Auth endpoints
  static const String register = "$baseUrl/auth/register";
  static const String login = "$baseUrl/auth/login";
  static const String verifyEmail = "$baseUrl/auth/verify-email";

  //ADS
  static const String createAd = "$baseUrl/ads";
  static const String getAds = "$baseUrl/ads/search";
  static  String getAdById(String id) => "$baseUrl/ads/$id";
  static  String updateAdById(String id) => "$baseUrl/ads/$id";
  static  String deleteAdById(String id) => "$baseUrl/ads/$id";
  static  String addFavorite(String id) => "$baseUrl/ads/$id/favorite";
  static  String getFavorites="$baseUrl/ads/me/favorites";
  static  String getCities="$baseUrl/cities";
  static  String  uploadImage(String adId)=>"$baseUrl/ads/$adId/images";

  static  String getCarBrands="$baseUrl/brands";
  static  String getCarModels(String brand) =>"$baseUrl/car-models?brand=$brand";

  //chat
  static  String getChats="$baseUrl/chats?status=active&limit=20&offset=0";
  static  String createChat="$baseUrl/chats";
  static String sendMessage(String chatId)=>"$baseUrl/chats/$chatId/messages";
  static String  getMessages(String chatId)=>"$baseUrl/chats/$chatId/messages";


}

