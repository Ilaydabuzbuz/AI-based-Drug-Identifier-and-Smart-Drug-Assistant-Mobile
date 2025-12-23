/// API configuration for the mobile app
class ApiConfig {
  // For Android emulator, use 10.0.2.2 to access localhost on host machine
  // For iOS simulator, use localhost or 127.0.0.1
  // For physical devices, use your machine's local IP (e.g., 192.168.x.x)
  static const String baseUrl = 'http://10.0.2.2:8000';

  // Auth endpoints
  static const String loginEndpoint = '$baseUrl/auth/token';
  static const String registerEndpoint = '$baseUrl/users/';
  static const String currentUserEndpoint = '$baseUrl/users/me';
}
