import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swasthasathi/app/core/api/api_client.dart';
import 'package:swasthasathi/app/core/api/api_endpoints.dart';
import 'package:swasthasathi/app/features/auth/data/models/auth_session_model.dart';
import 'package:swasthasathi/app/features/auth/data/models/auth_user_model.dart';
import 'package:swasthasathi/app/features/auth/domain/entities/login_request.dart';
import 'package:swasthasathi/app/features/auth/domain/entities/signup_request.dart';

final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  return AuthRemoteDataSource(ref.read(apiClientProvider));
});

class AuthRemoteDataSource {
  const AuthRemoteDataSource(this._apiClient);

  final ApiClient _apiClient;

  Future<AuthSessionModel> login(LoginRequest request) async {
    try {
      final response = await _apiClient.post(
        ApiEndpoints.login,
        data: {'email': request.email, 'password': request.password},
      );

      return AuthSessionModel.fromJson(
        Map<String, dynamic>.from(response.data as Map),
      );
    } on DioException catch (error) {
      throw Exception(_messageFromError(error));
    }
  }

  Future<AuthUserModel> signup(SignupRequest request) async {
    try {
      final response = await _apiClient.post(
        ApiEndpoints.signup,
        data: {
          'fullname': request.fullName,
          'email': request.email,
          'password': request.password,
          'phonenumber': request.phoneNumber,
          'district': request.district,
          if (request.bloodGroup != null) 'bloodgroup': request.bloodGroup,
        },
      );

      final body = Map<String, dynamic>.from(response.data as Map);
      return AuthUserModel.fromJson(
        Map<String, dynamic>.from(body['data'] as Map),
      );
    } on DioException catch (error) {
      throw Exception(_messageFromError(error));
    }
  }

  String _messageFromError(DioException error) {
    final data = error.response?.data;
    if (data is Map && data['message'] != null) {
      return data['message'].toString();
    }
    return error.message ?? 'Something went wrong. Please try again.';
  }
}
