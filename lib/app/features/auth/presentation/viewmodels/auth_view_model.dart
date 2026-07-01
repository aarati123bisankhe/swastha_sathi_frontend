import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swasthasathi/app/features/auth/domain/entities/login_request.dart';
import 'package:swasthasathi/app/features/auth/domain/entities/signup_request.dart';
import 'package:swasthasathi/app/features/auth/domain/usecases/login_use_case.dart';
import 'package:swasthasathi/app/features/auth/domain/usecases/signup_use_case.dart';
import 'package:swasthasathi/app/features/auth/presentation/state/auth_state.dart';

final authViewModelProvider = StateNotifierProvider<AuthViewModel, AuthState>((
  ref,
) {
  return AuthViewModel(
    ref.read(loginUseCaseProvider),
    ref.read(signupUseCaseProvider),
  );
});

class AuthViewModel extends StateNotifier<AuthState> {
  AuthViewModel(this._loginUseCase, this._signupUseCase)
    : super(const AuthState());

  final LoginUseCase _loginUseCase;
  final SignupUseCase _signupUseCase;

  static const _tokenKey = 'auth_token';
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<bool> login({required String email, required String password}) async {
    state = state.copyWith(
      isLoading: true,
      clearErrorMessage: true,
      clearSuccessMessage: true,
    );

    try {
      final session = await _loginUseCase(
        LoginRequest(email: email.trim(), password: password),
      );
      await _storage.write(key: _tokenKey, value: session.token);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_tokenKey, session.token);

      state = state.copyWith(
        isLoading: false,
        currentUser: session.user,
        successMessage: 'Login successful.',
        clearErrorMessage: true,
      );
      return true;
    } catch (error) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: error.toString().replaceFirst('Exception: ', ''),
        clearSuccessMessage: true,
      );
      return false;
    }
  }

  Future<bool> signup({
    required String fullName,
    required String email,
    required String password,
    required String phoneNumber,
    required String district,
    String? bloodGroup,
  }) async {
    state = state.copyWith(
      isLoading: true,
      clearErrorMessage: true,
      clearSuccessMessage: true,
    );

    try {
      final user = await _signupUseCase(
        SignupRequest(
          fullName: fullName.trim(),
          email: email.trim(),
          password: password,
          phoneNumber: phoneNumber.trim(),
          district: district.trim(),
          bloodGroup: bloodGroup?.trim().isEmpty ?? true
              ? null
              : bloodGroup?.trim(),
        ),
      );

      state = state.copyWith(
        isLoading: false,
        currentUser: user,
        successMessage: 'Registration successful. Please log in.',
        clearErrorMessage: true,
      );
      return true;
    } catch (error) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: error.toString().replaceFirst('Exception: ', ''),
        clearSuccessMessage: true,
      );
      return false;
    }
  }

  void clearMessages() {
    state = state.copyWith(clearErrorMessage: true, clearSuccessMessage: true);
  }
}
