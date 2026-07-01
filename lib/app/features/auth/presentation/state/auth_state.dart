import 'package:equatable/equatable.dart';
import 'package:swasthasathi/app/features/auth/domain/entities/auth_user.dart';

class AuthState extends Equatable {
  const AuthState({
    this.isLoading = false,
    this.errorMessage,
    this.successMessage,
    this.currentUser,
  });

  final bool isLoading;
  final String? errorMessage;
  final String? successMessage;
  final AuthUser? currentUser;

  AuthState copyWith({
    bool? isLoading,
    String? errorMessage,
    String? successMessage,
    AuthUser? currentUser,
    bool clearErrorMessage = false,
    bool clearSuccessMessage = false,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearErrorMessage
          ? null
          : errorMessage ?? this.errorMessage,
      successMessage: clearSuccessMessage
          ? null
          : successMessage ?? this.successMessage,
      currentUser: currentUser ?? this.currentUser,
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    errorMessage,
    successMessage,
    currentUser,
  ];
}
