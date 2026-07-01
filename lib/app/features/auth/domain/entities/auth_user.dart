import 'package:equatable/equatable.dart';

class AuthUser extends Equatable {
  const AuthUser({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.district,
    this.bloodGroup,
    this.profileUrl,
  });

  final String id;
  final String fullName;
  final String email;
  final String phoneNumber;
  final String district;
  final String? bloodGroup;
  final String? profileUrl;

  @override
  List<Object?> get props => [
    id,
    fullName,
    email,
    phoneNumber,
    district,
    bloodGroup,
    profileUrl,
  ];
}
