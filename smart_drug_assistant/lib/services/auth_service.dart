import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_config.dart';
import 'token_storage.dart';

/// Result class for auth operations
class AuthResult {
  final bool success;
  final String? errorMessage;
  final Map<String, dynamic>? data;

  AuthResult({required this.success, this.errorMessage, this.data});
}

/// Service for authentication operations (login, signup, etc.)
class AuthService {
  /// Login with email and password
  /// Returns AuthResult with success status and any error message
  static Future<AuthResult> login(String email, String password) async {
    try {
      // FastAPI OAuth2 expects form data, not JSON
      final response = await http.post(
        Uri.parse(ApiConfig.loginEndpoint),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {
          'username': email, // FastAPI OAuth2 uses 'username' field for email
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final token = data['access_token'];

        // Save the token
        await TokenStorage.saveToken(token);

        return AuthResult(success: true, data: data);
      } else if (response.statusCode == 401) {
        return AuthResult(
          success: false,
          errorMessage: 'Invalid email or password',
        );
      } else {
        final error = jsonDecode(response.body);
        return AuthResult(
          success: false,
          errorMessage: error['detail'] ?? 'Login failed',
        );
      }
    } catch (e) {
      return AuthResult(
        success: false,
        errorMessage:
            'Connection error. Please check your internet connection.',
      );
    }
  }

  /// Register a new user
  static Future<AuthResult> signup({
    required String email,
    required String password,
    required String fullName,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConfig.registerEndpoint),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
          'full_name': fullName,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return AuthResult(success: true, data: data);
      } else if (response.statusCode == 400) {
        final error = jsonDecode(response.body);
        return AuthResult(
          success: false,
          errorMessage: error['detail'] ?? 'Registration failed',
        );
      } else {
        final error = jsonDecode(response.body);
        return AuthResult(
          success: false,
          errorMessage: error['detail'] ?? 'Registration failed',
        );
      }
    } catch (e) {
      return AuthResult(
        success: false,
        errorMessage:
            'Connection error. Please check your internet connection.',
      );
    }
  }

  /// Get current user info
  static Future<AuthResult> getCurrentUser() async {
    try {
      final token = await TokenStorage.getToken();
      if (token == null) {
        return AuthResult(success: false, errorMessage: 'Not logged in');
      }

      final response = await http.get(
        Uri.parse(ApiConfig.currentUserEndpoint),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return AuthResult(success: true, data: data);
      } else {
        return AuthResult(
          success: false,
          errorMessage: 'Failed to get user info',
        );
      }
    } catch (e) {
      return AuthResult(success: false, errorMessage: 'Connection error');
    }
  }

  /// Logout - clear stored token
  static Future<void> logout() async {
    await TokenStorage.deleteToken();
  }
}
