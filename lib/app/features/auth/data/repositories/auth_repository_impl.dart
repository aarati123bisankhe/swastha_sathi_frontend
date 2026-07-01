import 'package:swasthasathi/app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:swasthasathi/app/features/auth/domain/entities/auth_session.dart';
import 'package:swasthasathi/app/features/auth/domain/entities/auth_user.dart';
import 'package:swasthasathi/app/features/auth/domain/entities/login_request.dart';
import 'package:swasthasathi/app/features/auth/domain/entities/signup_request.dart';
import 'package:swasthasathi/app/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl(this._remoteDataSource);

  final AuthRemoteDataSource _remoteDataSource;

  @override
  Future<AuthSession> login(LoginRequest request) {
    return _remoteDataSource.login(request);
  }

  @override
  Future<AuthUser> signup(SignupRequest request) {
    return _remoteDataSource.signup(request);
  }
}
