import 'package:equatable/equatable.dart';
import 'package:swasthasathi/app/features/auth/domain/entities/auth_user.dart';

class AuthSession extends Equatable {
  const AuthSession({required this.token, required this.user});

  final String token;
  final AuthUser user;

  @override
  List<Object?> get props => [token, user];
}
