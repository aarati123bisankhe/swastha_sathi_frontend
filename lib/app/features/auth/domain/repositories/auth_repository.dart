import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swasthasathi/app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:swasthasathi/app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:swasthasathi/app/features/auth/domain/entities/auth_session.dart';
import 'package:swasthasathi/app/features/auth/domain/entities/auth_user.dart';
import 'package:swasthasathi/app/features/auth/domain/entities/login_request.dart';
import 'package:swasthasathi/app/features/auth/domain/entities/signup_request.dart';

abstract class AuthRepository {
  Future<AuthSession> login(LoginRequest request);
  Future<AuthUser> signup(SignupRequest request);
}

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(ref.read(authRemoteDataSourceProvider));
});
