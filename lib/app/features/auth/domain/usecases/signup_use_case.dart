import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swasthasathi/app/features/auth/domain/entities/auth_user.dart';
import 'package:swasthasathi/app/features/auth/domain/entities/signup_request.dart';
import 'package:swasthasathi/app/features/auth/domain/repositories/auth_repository.dart';

class SignupUseCase {
  const SignupUseCase(this._repository);

  final AuthRepository _repository;

  Future<AuthUser> call(SignupRequest request) {
    return _repository.signup(request);
  }
}

final signupUseCaseProvider = Provider<SignupUseCase>((ref) {
  return SignupUseCase(ref.read(authRepositoryProvider));
});
