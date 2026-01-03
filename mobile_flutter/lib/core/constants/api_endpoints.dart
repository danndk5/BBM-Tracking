

class ApiEndpoints {
  // Base URL
  static const String baseUrl = 'http://192.168.86.80:8080/api';
  
  // Auth
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  
  // SPBU
  static const String spbu = '/spbu';
  
  // Trip
  static const String trips = '/trips';
  static const String activeTrip = '/trips/active';
  
  // Delivery
  static const String deliveries = '/deliveries';
  static String deliveryTiba(String id) => '/deliveries/$id/tiba';
  static String deliveryMulaiBongkar(String id) => '/deliveries/$id/mulai-bongkar';
  static String deliverySelesaiBongkar(String id) => '/deliveries/$id/selesai-bongkar';
  static const String deliveryNext = '/deliveries/next';
}