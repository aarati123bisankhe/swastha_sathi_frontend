import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swasthasathi/app/features/auth/domain/entities/auth_session.dart';
import 'package:swasthasathi/app/features/auth/domain/entities/login_request.dart';
import 'package:swasthasathi/app/features/auth/domain/repositories/auth_repository.dart';

class LoginUseCase {
  const LoginUseCase(this._repository);

  final AuthRepository _repository;

  Future<AuthSession> call(LoginRequest request) {
    return _repository.login(request);
  }
}

final loginUseCaseProvider = Provider<LoginUseCase>((ref) {
  return LoginUseCase(ref.read(authRepositoryProvider));
});
