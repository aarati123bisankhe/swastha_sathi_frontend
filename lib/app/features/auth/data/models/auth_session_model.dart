import 'package:swasthasathi/app/features/auth/data/models/auth_user_model.dart';
import 'package:swasthasathi/app/features/auth/domain/entities/auth_session.dart';

class AuthSessionModel extends AuthSession {
  const AuthSessionModel({required super.token, required super.user});

  factory AuthSessionModel.fromJson(Map<String, dynamic> json) {
    return AuthSessionModel(
      token: (json['token'] ?? '').toString(),
      user: AuthUserModel.fromJson(
        Map<String, dynamic>.from(json['data'] as Map),
      ),
    );
  }
}
