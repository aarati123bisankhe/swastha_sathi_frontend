import 'package:swasthasathi/app/features/auth/domain/entities/auth_user.dart';

class AuthUserModel extends AuthUser {
  const AuthUserModel({
    required super.id,
    required super.fullName,
    required super.email,
    required super.phoneNumber,
    required super.district,
    super.bloodGroup,
    super.profileUrl,
  });

  factory AuthUserModel.fromJson(Map<String, dynamic> json) {
    return AuthUserModel(
      id: (json['_id'] ?? json['id'] ?? '').toString(),
      fullName: (json['fullname'] ?? json['fullName'] ?? '').toString(),
      email: (json['email'] ?? '').toString(),
      phoneNumber: (json['phonenumber'] ?? json['phoneNumber'] ?? '')
          .toString(),
      district: (json['district'] ?? '').toString(),
      bloodGroup: _nullableString(json['bloodGroup'] ?? json['bloodgroup']),
      profileUrl: _nullableString(json['profileUrl']),
    );
  }

  static String? _nullableString(dynamic value) {
    final stringValue = value?.toString().trim();
    if (stringValue == null || stringValue.isEmpty || stringValue == 'null') {
      return null;
    }
    return stringValue;
  }
}
