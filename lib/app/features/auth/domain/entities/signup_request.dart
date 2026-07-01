import 'package:equatable/equatable.dart';

class SignupRequest extends Equatable {
  const SignupRequest({
    required this.fullName,
    required this.email,
    required this.password,
    required this.phoneNumber,
    required this.district,
    this.bloodGroup,
  });

  final String fullName;
  final String email;
  final String password;
  final String phoneNumber;
  final String district;
  final String? bloodGroup;

  @override
  List<Object?> get props => [
    fullName,
    email,
    password,
    phoneNumber,
    district,
    bloodGroup,
  ];
}
