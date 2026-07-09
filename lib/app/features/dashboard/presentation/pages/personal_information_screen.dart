import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:swasthasathi/app/core/localization/app_text.dart';
import 'package:swasthasathi/app/features/auth/domain/entities/auth_user.dart';
import 'package:swasthasathi/app/features/dashboard/presentation/widgets/dashboard_bottom_nav.dart';

class PersonalInformationData {
  const PersonalInformationData({
    required this.fullName,
    required this.birthDate,
    required this.gender,
    required this.bloodGroup,
    required this.phoneNumber,
    required this.email,
    required this.address,
    this.profileImagePath,
    this.profileImageUrl,
  });

  final String fullName;
  final String birthDate;
  final String gender;
  final String bloodGroup;
  final String phoneNumber;
  final String email;
  final String address;
  final String? profileImagePath;
  final String? profileImageUrl;

  PersonalInformationData copyWith({
    String? fullName,
    String? birthDate,
    String? gender,
    String? bloodGroup,
    String? phoneNumber,
    String? email,
    String? address,
    String? profileImagePath,
    String? profileImageUrl,
    bool clearProfileImagePath = false,
    bool clearProfileImageUrl = false,
  }) {
    return PersonalInformationData(
      fullName: fullName ?? this.fullName,
      birthDate: birthDate ?? this.birthDate,
      gender: gender ?? this.gender,
      bloodGroup: bloodGroup ?? this.bloodGroup,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      address: address ?? this.address,
      profileImagePath: clearProfileImagePath
          ? null
          : profileImagePath ?? this.profileImagePath,
      profileImageUrl: clearProfileImageUrl
          ? null
          : profileImageUrl ?? this.profileImageUrl,
    );
  }

  factory PersonalInformationData.fromJson(Map<String, dynamic> json) {
    return PersonalInformationData(
      fullName: json['fullName'] as String? ?? 'Anisha Sharma',
      birthDate: json['birthDate'] as String? ?? '12 May 2002',
      gender: json['gender'] as String? ?? 'Female',
      bloodGroup: json['bloodGroup'] as String? ?? 'O+ Positive',
      phoneNumber: json['phoneNumber'] as String? ?? '9862573376',
      email: json['email'] as String? ?? 'anisha@gmail.com',
      address: json['address'] as String? ?? 'Kathmandu, Nepal',
      profileImagePath: json['profileImagePath'] as String?,
      profileImageUrl: json['profileImageUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'birthDate': birthDate,
      'gender': gender,
      'bloodGroup': bloodGroup,
      'phoneNumber': phoneNumber,
      'email': email,
      'address': address,
      'profileImagePath': profileImagePath,
      'profileImageUrl': profileImageUrl,
    };
  }
}

class PersonalInformationScreen extends StatefulWidget {
  const PersonalInformationScreen({
    super.key,
    required this.initialData,
    this.user,
  });

  final PersonalInformationData initialData;
  final AuthUser? user;

  @override
  State<PersonalInformationScreen> createState() =>
      _PersonalInformationScreenState();
}

class _PersonalInformationScreenState extends State<PersonalInformationScreen> {
  final ImagePicker _picker = ImagePicker();
  late PersonalInformationData _data;

  @override
  void initState() {
    super.initState();
    _data = widget.initialData;
  }

  Future<void> _pickProfileImage(ImageSource source) async {
    final image = await _picker.pickImage(source: source);
    if (image == null || !mounted) return;

    setState(() {
      _data = _data.copyWith(
        profileImagePath: image.path,
        clearProfileImageUrl: true,
      );
    });
  }

  Future<void> _showImageOptions() async {
    await showModalBottomSheet<void>(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 26),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Change Profile Picture',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF20196E),
                  ),
                ),
                const SizedBox(height: 14),
                ListTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  leading: const Icon(
                    Icons.photo_camera_outlined,
                    color: Color(0xFF0B73E8),
                  ),
                  title: const Text('Take Photo'),
                  onTap: () {
                    Navigator.of(context).pop();
                    _pickProfileImage(ImageSource.camera);
                  },
                ),
                ListTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  leading: const Icon(
                    Icons.photo_library_outlined,
                    color: Color(0xFF0B73E8),
                  ),
                  title: const Text('Upload from Gallery'),
                  onTap: () {
                    Navigator.of(context).pop();
                    _pickProfileImage(ImageSource.gallery);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _editField({
    required String title,
    required String initialValue,
    required ValueChanged<String> onSaved,
    TextInputType keyboardType = TextInputType.text,
  }) async {
    final controller = TextEditingController(text: initialValue);

    final updatedValue = await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          title: Text(
            'Edit $title',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Color(0xFF20196E),
            ),
          ),
          content: TextField(
            controller: controller,
            keyboardType: keyboardType,
            autofocus: true,
            decoration: InputDecoration(
              hintText: title,
              filled: true,
              fillColor: const Color(0xFFF4F8FE),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF0B73E8),
              ),
              onPressed: () {
                Navigator.of(context).pop(controller.text.trim());
              },
              child: const Text('Update'),
            ),
          ],
        );
      },
    );

    if (updatedValue == null || updatedValue.isEmpty || !mounted) return;

    setState(() {
      onSaved(updatedValue);
    });
  }

  void _saveChanges() {
    Navigator.of(context).pop(_data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(26, 18, 26, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Transform.translate(
                          offset: const Offset(-24, 0),
                          child: IconButton(
                            onPressed: () => Navigator.of(context).pop(),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            icon: const Icon(
                              Icons.arrow_back_ios_new_rounded,
                              color: Color(0xFF7D8491),
                              size: 20,
                            ),
                          ),
                        ),
                        const SizedBox(width: 0),
                        Expanded(
                          child: Transform.translate(
                            offset: const Offset(-20, 0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  context.tx(
                                    'Personal Information',
                                    'व्यक्तिगत जानकारी',
                                  ),
                                  style: TextStyle(
                                    fontSize: 23,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF20196E),
                                  ),
                                ),
                                SizedBox(height: 0),
                                Text(
                                  context.tx(
                                    'Manage your personal details',
                                    'आफ्नो व्यक्तिगत विवरण व्यवस्थापन गर्नुहोस्',
                                  ),
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFF414B55),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    _ProfileSummaryCard(
                      data: _data,
                      onChangePhoto: _showImageOptions,
                    ),
                    const SizedBox(height: 12),
                    _DetailCard(
                      icon: Icons.person_rounded,
                      iconBackground: const Color(0xFFEAF4FF),
                      iconColor: const Color(0xFF1E88F7),
                      label: 'Full Name',
                      value: _data.fullName,
                      onEdit: () => _editField(
                        title: 'Full Name',
                        initialValue: _data.fullName,
                        onSaved: (value) {
                          _data = _data.copyWith(fullName: value);
                        },
                      ),
                    ),
                    const SizedBox(height: 10),
                    _DetailCard(
                      icon: Icons.calendar_month_rounded,
                      iconBackground: const Color(0xFFEAF2FF),
                      iconColor: const Color(0xFF73A7F4),
                      label: 'Birth of Date',
                      value: _data.birthDate,
                      onEdit: () => _editField(
                        title: 'Birth of Date',
                        initialValue: _data.birthDate,
                        onSaved: (value) {
                          _data = _data.copyWith(birthDate: value);
                        },
                      ),
                    ),
                    const SizedBox(height: 10),
                    _DetailCard(
                      icon: Icons.transgender_rounded,
                      iconBackground: const Color(0xFFF4ECFF),
                      iconColor: const Color(0xFF8D6AF6),
                      label: 'Gender',
                      value: _data.gender,
                      onEdit: () => _editField(
                        title: 'Gender',
                        initialValue: _data.gender,
                        onSaved: (value) {
                          _data = _data.copyWith(gender: value);
                        },
                      ),
                    ),
                    const SizedBox(height: 10),
                    _DetailCard(
                      icon: Icons.opacity_rounded,
                      iconBackground: const Color(0xFFF7D8D8),
                      iconColor: const Color(0xFFCF1212),
                      label: 'Blood Group',
                      value: _data.bloodGroup,
                      onEdit: () => _editField(
                        title: 'Blood Group',
                        initialValue: _data.bloodGroup,
                        onSaved: (value) {
                          _data = _data.copyWith(bloodGroup: value);
                        },
                      ),
                    ),
                    const SizedBox(height: 10),
                    _DetailCard(
                      icon: Icons.call_rounded,
                      iconBackground: const Color(0xFFD4E6CB),
                      iconColor: const Color(0xFF4F5855),
                      label: 'Phone Number',
                      value: _data.phoneNumber,
                      onEdit: () => _editField(
                        title: 'Phone Number',
                        initialValue: _data.phoneNumber,
                        keyboardType: TextInputType.phone,
                        onSaved: (value) {
                          _data = _data.copyWith(phoneNumber: value);
                        },
                      ),
                    ),
                    const SizedBox(height: 10),
                    _DetailCard(
                      icon: Icons.email_rounded,
                      iconBackground: const Color(0xFFE8F3FF),
                      iconColor: const Color(0xFF1E88F7),
                      label: 'Email',
                      value: _data.email,
                      onEdit: () => _editField(
                        title: 'Email',
                        initialValue: _data.email,
                        keyboardType: TextInputType.emailAddress,
                        onSaved: (value) {
                          _data = _data.copyWith(email: value);
                        },
                      ),
                    ),
                    const SizedBox(height: 10),
                    _DetailCard(
                      icon: Icons.location_on_rounded,
                      iconBackground: const Color(0xFFEAF4FF),
                      iconColor: const Color(0xFF2A8AF0),
                      label: 'Address',
                      value: _data.address,
                      onEdit: () => _editField(
                        title: 'Address',
                        initialValue: _data.address,
                        onSaved: (value) {
                          _data = _data.copyWith(address: value);
                        },
                      ),
                    ),
                    const SizedBox(height: 15),
                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: FilledButton.icon(
                        onPressed: _saveChanges,
                        style: FilledButton.styleFrom(
                          backgroundColor: const Color(0xFF0B73E8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 0,
                        ),
                        icon: const Icon(Icons.save_outlined, size: 22),
                        label: Text(
                          context.tx(
                            'Save Changes',
                            'परिवर्तन सुरक्षित गर्नुहोस्',
                          ),
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: DashboardBottomNav(
        activeTab: DashboardNavTab.profile,
        user: widget.user,
      ),
    );
  }
}

class _ProfileSummaryCard extends StatelessWidget {
  const _ProfileSummaryCard({required this.data, required this.onChangePhoto});

  final PersonalInformationData data;
  final VoidCallback onChangePhoto;

  @override
  Widget build(BuildContext context) {
    ImageProvider<Object> imageProvider;
    if (data.profileImagePath != null && data.profileImagePath!.isNotEmpty) {
      imageProvider = FileImage(File(data.profileImagePath!));
    } else if (data.profileImageUrl != null &&
        data.profileImageUrl!.isNotEmpty) {
      imageProvider = NetworkImage(data.profileImageUrl!);
    } else {
      imageProvider = const AssetImage(
        'assets/images/family_contact_avatar.png',
      );
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: const LinearGradient(
          colors: [Color(0xFFCDE4FF), Color(0xFFEAF3FF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x24000000),
            blurRadius: 12,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              CircleAvatar(radius: 28, backgroundImage: imageProvider),
              Positioned(
                bottom: -2,
                right: -2,
                child: GestureDetector(
                  onTap: onChangePhoto,
                  child: Container(
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFF2A66D9),
                        width: 1.6,
                      ),
                    ),
                    child: const Icon(
                      Icons.photo_camera_outlined,
                      size: 12,
                      color: Color(0xFF2A66D9),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.fullName,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF33373B),
                  ),
                ),
                const SizedBox(height: 1),
                const Text(
                  'HealthCare Companion users',
                  style: TextStyle(fontSize: 12, color: Color(0xFF434A51)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailCard extends StatelessWidget {
  const _DetailCard({
    required this.icon,
    required this.iconBackground,
    required this.iconColor,
    required this.label,
    required this.value,
    required this.onEdit,
  });

  final IconData icon;
  final Color iconBackground;
  final Color iconColor;
  final String label;
  final String value;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.96),
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color(0x24000000),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: iconBackground,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 21),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF271770),
                  ),
                ),
                const SizedBox(height: 1),
                Text(
                  value,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF21176D),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onEdit,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints.tightFor(width: 28, height: 28),
            icon: const Icon(
              Icons.edit_outlined,
              color: Color(0xFF0B73E8),
              size: 24,
            ),
          ),
        ],
      ),
    );
  }
}
