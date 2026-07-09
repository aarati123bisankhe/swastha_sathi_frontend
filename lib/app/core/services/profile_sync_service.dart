import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swasthasathi/app/core/api/api_client.dart';
import 'package:swasthasathi/app/core/api/api_endpoints.dart';
import 'package:swasthasathi/app/features/auth/domain/entities/auth_user.dart';
import 'package:swasthasathi/app/features/dashboard/presentation/pages/personal_information_screen.dart';
import 'package:swasthasathi/app/features/dashboard/presentation/pages/record_screen.dart';

class ProfileSyncService {
  ProfileSyncService._();

  static const String personalInfoStorageKey = 'personal_information_data';
  static const String healthRecordStorageKey = 'health_record_data';
  static final ProfileSyncService instance = ProfileSyncService._();

  final ApiClient _apiClient = ApiClient();

  Future<PersonalInformationData> loadPersonalInformation(
    AuthUser? user,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(personalInfoStorageKey);

    final fallback = PersonalInformationData(
      fullName: user?.fullName.trim().isNotEmpty == true
          ? user!.fullName.trim()
          : 'Anisha Sharma',
      birthDate: '12 May 2002',
      gender: 'Female',
      bloodGroup: user?.bloodGroup?.trim().isNotEmpty == true
          ? user!.bloodGroup!.trim()
          : 'O+ Positive',
      phoneNumber: user?.phoneNumber.trim().isNotEmpty == true
          ? user!.phoneNumber.trim()
          : '9862573376',
      email: user?.email.trim().isNotEmpty == true
          ? user!.email.trim()
          : 'anisha@gmail.com',
      address: user?.district.trim().isNotEmpty == true
          ? user!.district.trim()
          : 'Kathmandu, Nepal',
      profileImageUrl: user?.profileUrl,
    );

    if (raw == null || raw.isEmpty) {
      return fallback;
    }

    return _mergePersonalInfo(
      fallback,
      PersonalInformationData.fromJson(jsonDecode(raw) as Map<String, dynamic>),
    );
  }

  Future<HealthRecordData> loadHealthRecord(AuthUser? user) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(healthRecordStorageKey);
    final personalInfo = await loadPersonalInformation(user);

    final baseRecord = raw == null || raw.isEmpty
        ? HealthRecordData.fromUser(user)
        : HealthRecordData.fromJson(jsonDecode(raw) as Map<String, dynamic>);

    return _syncRecordWithProfile(baseRecord, personalInfo);
  }

  Future<PersonalInformationData> savePersonalInformation({
    required PersonalInformationData data,
    required AuthUser? user,
  }) async {
    var updatedData = data;

    if (_shouldUploadProfileImage(updatedData.profileImagePath)) {
      updatedData = await _uploadProfileImage(updatedData);
    }

    if (user?.id.trim().isNotEmpty == true) {
      updatedData = await _updateProfileOnBackend(user!.id.trim(), updatedData);
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      personalInfoStorageKey,
      jsonEncode(updatedData.toJson()),
    );

    final currentRecord = await loadHealthRecord(user);
    final syncedRecord = _syncRecordWithProfile(currentRecord, updatedData);
    await prefs.setString(
      healthRecordStorageKey,
      jsonEncode(syncedRecord.toJson()),
    );

    return updatedData;
  }

  Future<HealthRecordData> saveHealthRecord({
    required HealthRecordData record,
    required AuthUser? user,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(healthRecordStorageKey, jsonEncode(record.toJson()));

    final personalInfo = await loadPersonalInformation(user);
    final updatedPersonalInfo = personalInfo.copyWith(
      fullName: record.username,
      bloodGroup: record.bloodGroup,
      phoneNumber: record.emergencyContactNumber,
    );

    final savedPersonalInfo = await savePersonalInformation(
      data: updatedPersonalInfo,
      user: user,
    );

    return _syncRecordWithProfile(record, savedPersonalInfo);
  }

  Future<PersonalInformationData> _uploadProfileImage(
    PersonalInformationData data,
  ) async {
    final imageFile = File(data.profileImagePath!);
    final bytes = await imageFile.readAsBytes();
    final fileName = imageFile.uri.pathSegments.isNotEmpty
        ? imageFile.uri.pathSegments.last
        : data.profileImagePath!.split(Platform.pathSeparator).last;
    final extension = fileName.contains('.')
        ? '.${fileName.split('.').last.toLowerCase()}'
        : '';

    try {
      final response = await _apiClient.post(
        ApiEndpoints.profileUploadPhoto,
        data: {
          'fileName': fileName,
          'mimeType': _mimeTypeForExtension(extension),
          'base64Data': base64Encode(bytes),
        },
      );

      final body = Map<String, dynamic>.from(response.data as Map);
      final uploaded = Map<String, dynamic>.from(body['data'] as Map);
      final profileUrl = ApiEndpoints.uploadUrl(
        uploaded['profileUrl']?.toString() ?? '',
      );

      return data.copyWith(
        clearProfileImagePath: true,
        profileImageUrl: profileUrl,
      );
    } on DioException catch (error) {
      throw Exception(_messageFromError(error));
    }
  }

  Future<PersonalInformationData> _updateProfileOnBackend(
    String userId,
    PersonalInformationData data,
  ) async {
    try {
      final response = await _apiClient.put(
        ApiEndpoints.profileUpdate(userId),
        data: {
          'fullname': data.fullName,
          'email': data.email,
          'phonenumber': data.phoneNumber,
          'district': data.address,
          'bloodgroup': data.bloodGroup,
          if (data.profileImageUrl?.trim().isNotEmpty == true)
            'profileUrl': _toRelativeUploadPath(data.profileImageUrl!),
        },
      );

      final body = Map<String, dynamic>.from(response.data as Map);
      final updatedUser = Map<String, dynamic>.from(body['data'] as Map);
      final updatedProfileUrl = updatedUser['profileUrl']?.toString();

      return data.copyWith(
        profileImageUrl: updatedProfileUrl == null || updatedProfileUrl.isEmpty
            ? data.profileImageUrl
            : ApiEndpoints.uploadUrl(updatedProfileUrl),
      );
    } on DioException catch (error) {
      throw Exception(_messageFromError(error));
    }
  }

  PersonalInformationData _mergePersonalInfo(
    PersonalInformationData fallback,
    PersonalInformationData saved,
  ) {
    return PersonalInformationData(
      fullName: saved.fullName,
      birthDate: saved.birthDate,
      gender: saved.gender,
      bloodGroup: saved.bloodGroup,
      phoneNumber: saved.phoneNumber,
      email: saved.email,
      address: saved.address,
      profileImagePath: saved.profileImagePath,
      profileImageUrl: _normalizeProfileImageUrl(
        saved.profileImageUrl ?? fallback.profileImageUrl,
      ),
    );
  }

  HealthRecordData _syncRecordWithProfile(
    HealthRecordData record,
    PersonalInformationData profile,
  ) {
    return record.copyWith(
      username: profile.fullName,
      bloodGroup: profile.bloodGroup,
      emergencyContactNumber: profile.phoneNumber,
    );
  }

  bool _shouldUploadProfileImage(String? profileImagePath) {
    if (profileImagePath == null || profileImagePath.trim().isEmpty) {
      return false;
    }

    return !profileImagePath.startsWith('http') &&
        !profileImagePath.startsWith('/uploads/');
  }

  String _mimeTypeForExtension(String extension) {
    switch (extension) {
      case '.png':
        return 'image/png';
      case '.webp':
        return 'image/webp';
      case '.gif':
        return 'image/gif';
      default:
        return 'image/jpeg';
    }
  }

  String _toRelativeUploadPath(String value) {
    final uri = Uri.tryParse(value);
    if (uri != null && uri.path.isNotEmpty) {
      return uri.path;
    }
    return value;
  }

  String? _normalizeProfileImageUrl(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null;
    }
    if (value.startsWith('http')) {
      return value;
    }
    return ApiEndpoints.uploadUrl(value);
  }

  String _messageFromError(DioException error) {
    final data = error.response?.data;
    if (data is Map && data['message'] != null) {
      return data['message'].toString();
    }
    return error.message ?? 'Something went wrong. Please try again.';
  }
}
