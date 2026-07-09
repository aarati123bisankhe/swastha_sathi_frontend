import 'dart:io';

import 'package:flutter/material.dart';
import 'package:swasthasathi/app/core/localization/app_text.dart';
import 'package:swasthasathi/app/core/services/profile_sync_service.dart';
import 'package:swasthasathi/app/features/auth/domain/entities/auth_user.dart';
import 'package:swasthasathi/app/features/dashboard/presentation/pages/notification_screen.dart';
import 'package:swasthasathi/app/features/dashboard/presentation/pages/personal_information_screen.dart';
import 'package:swasthasathi/app/features/dashboard/presentation/widgets/dashboard_bottom_nav.dart';

class RecordScreen extends StatefulWidget {
  const RecordScreen({super.key, this.user});

  final AuthUser? user;

  @override
  State<RecordScreen> createState() => _RecordScreenState();
}

class _RecordScreenState extends State<RecordScreen> {
  final ProfileSyncService _profileSyncService = ProfileSyncService.instance;

  late HealthRecordData _record;
  PersonalInformationData? _personalInfo;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _record = HealthRecordData.fromUser(widget.user);
    _personalInfo = _buildFallbackPersonalInfo();
    _loadRecord();
  }

  @override
  Widget build(BuildContext context) {
    final personalInfo = _personalInfo ?? _buildFallbackPersonalInfo();
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 18, 20, 120),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _RecordHeader(user: widget.user),
                    const SizedBox(height: 18),
                    _ProfileSummaryCard(
                      record: _record,
                      personalInfo: personalInfo,
                    ),
                    const SizedBox(height: 18),
                    _RecordInfoGrid(record: _record),
                    const SizedBox(height: 15),
                    _RecentActivityCard(record: _record),
                    const SizedBox(height: 13),
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: _saveOffline,
                            child: _RecordActionButton(
                              label: context.tx(
                                'Save Offline',
                                'अफलाइन सुरक्षित गर्नुहोस्',
                              ),
                              icon: Icons.download_rounded,
                              backgroundColor: Color(0xFF45AA3A),
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: GestureDetector(
                            onTap: _editRecord,
                            child: _RecordActionButton(
                              label: context.tx(
                                'Edit Records',
                                'रेकर्ड सम्पादन गर्नुहोस्',
                              ),
                              icon: Icons.edit_outlined,
                              backgroundColor: Color(0xFF1E84EA),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
      ),
      bottomNavigationBar: DashboardBottomNav(
        activeTab: DashboardNavTab.record,
        user: widget.user,
      ),
    );
  }

  Future<void> _loadRecord() async {
    final record = await _profileSyncService.loadHealthRecord(widget.user);
    final personalInfo = await _profileSyncService.loadPersonalInformation(
      widget.user,
    );

    if (!mounted) return;

    setState(() {
      _record = record;
      _personalInfo = personalInfo;
      _loading = false;
    });
  }

  PersonalInformationData _buildFallbackPersonalInfo() {
    return PersonalInformationData(
      fullName: _record.username,
      birthDate: '12 May 2002',
      gender: 'Female',
      bloodGroup: _record.bloodGroup,
      phoneNumber: _record.emergencyContactNumber,
      email: widget.user?.email ?? 'anisha@gmail.com',
      address: widget.user?.district ?? 'Kathmandu, Nepal',
      profileImageUrl: widget.user?.profileUrl,
    );
  }

  Future<void> _editRecord() async {
    final updated = await Navigator.of(context).push<HealthRecordData>(
      MaterialPageRoute<HealthRecordData>(
        builder: (context) => EditHealthRecordScreen(initialRecord: _record),
      ),
    );

    if (updated == null || !mounted) return;

    setState(() {
      _record = updated;
    });

    try {
      final syncedRecord = await _profileSyncService.saveHealthRecord(
        record: updated,
        user: widget.user,
      );
      final personalInfo = await _profileSyncService.loadPersonalInformation(
        widget.user,
      );

      if (!mounted) return;

      setState(() {
        _record = syncedRecord;
        _personalInfo = personalInfo;
      });

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(
              context.tx(
                'Health record updated successfully.',
                'स्वास्थ्य रेकर्ड सफलतापूर्वक अद्यावधिक भयो।',
              ),
            ),
            behavior: SnackBarBehavior.floating,
          ),
        );
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(error.toString().replaceFirst('Exception: ', '')),
            behavior: SnackBarBehavior.floating,
          ),
        );
    }
  }

  Future<void> _saveOffline() async {
    try {
      final savedRecord = await _profileSyncService.saveHealthRecord(
        record: _record,
        user: widget.user,
      );
      final personalInfo = await _profileSyncService.loadPersonalInformation(
        widget.user,
      );

      if (mounted) {
        setState(() {
          _record = savedRecord;
          _personalInfo = personalInfo;
        });
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(
              context.tx(
                'Health record saved offline successfully.',
                'स्वास्थ्य रेकर्ड अफलाइन सफलतापूर्वक सुरक्षित भयो।',
              ),
            ),
            behavior: SnackBarBehavior.floating,
          ),
        );
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(error.toString().replaceFirst('Exception: ', '')),
            behavior: SnackBarBehavior.floating,
          ),
        );
    }
  }
}

class _RecordHeader extends StatelessWidget {
  const _RecordHeader({this.user});

  final AuthUser? user;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.tx('Health Record', 'स्वास्थ्य रेकर्ड'),
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF24229A),
                ),
              ),
              SizedBox(height: 4),
              Text(
                context.tx(
                  'Your Personal Medical Information',
                  'तपाईंको व्यक्तिगत स्वास्थ्य जानकारी',
                ),
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (context) => NotificationScreen(user: user),
              ),
            );
          },
          child: const Padding(
            padding: EdgeInsets.only(top: 4),
            child: Icon(
              Icons.notifications,
              color: Color(0xFF193767),
              size: 30,
            ),
          ),
        ),
      ],
    );
  }
}

class _ProfileSummaryCard extends StatelessWidget {
  const _ProfileSummaryCard({required this.record, required this.personalInfo});

  final HealthRecordData record;
  final PersonalInformationData personalInfo;

  @override
  Widget build(BuildContext context) {
    ImageProvider<Object>? imageProvider;
    if (personalInfo.profileImagePath != null &&
        personalInfo.profileImagePath!.isNotEmpty) {
      imageProvider = FileImage(File(personalInfo.profileImagePath!));
    } else if (personalInfo.profileImageUrl != null &&
        personalInfo.profileImageUrl!.isNotEmpty) {
      imageProvider = NetworkImage(personalInfo.profileImageUrl!);
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          colors: [Color(0xFFB3DCF0), Color(0xFFD9E0E5)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 116,
            height: 116,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [Color(0xFF9BC0F6), Color(0xFF87A6D8)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: ClipOval(
              child: imageProvider != null
                  ? Image(image: imageProvider, fit: BoxFit.cover)
                  : const Icon(
                      Icons.person_rounded,
                      size: 78,
                      color: Color(0xFF4A2A1E),
                    ),
            ),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Username',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF4A545E),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  record.username,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF27323A),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: _ProfileMetaBlock(
                        label: 'Age',
                        value: '${record.age} Years',
                      ),
                    ),
                    Expanded(
                      child: _ProfileMetaBlock(
                        label: 'Health Status',
                        value: record.healthStatus,
                        highlight: true,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileMetaBlock extends StatelessWidget {
  const _ProfileMetaBlock({
    required this.label,
    required this.value,
    this.highlight = false,
  });

  final String label;
  final String value;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFF4A545E),
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 2),
        Row(
          children: [
            if (highlight)
              const Padding(
                padding: EdgeInsets.only(right: 4),
                child: Icon(
                  Icons.check_box_rounded,
                  color: Color(0xFF10B91D),
                  size: 18,
                ),
              ),
            Flexible(
              child: Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF27323A),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _RecordInfoGrid extends StatelessWidget {
  const _RecordInfoGrid({required this.record});

  final HealthRecordData record;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _RecordInfoCard(
                icon: Icons.bloodtype,
                iconBackground: const Color(0xFFEAB6B6),
                iconColor: const Color(0xFFE21818),
                title: 'Blood Group',
                subtitle: record.bloodGroup,
                cardHeight: 84,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _RecordInfoCard(
                icon: Icons.warning_amber_rounded,
                iconBackground: const Color(0xFFE3E3A9),
                iconColor: const Color(0xFF121212),
                title: 'Allergies',
                subtitle: record.allergies,
                cardHeight: 84,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _RecordInfoCard(
                icon: Icons.medication_rounded,
                iconBackground: const Color(0xFFF5DE97),
                iconColor: const Color(0xFFD98317),
                title: 'Medications',
                subtitle: record.medications,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _RecordInfoCard(
                icon: Icons.call,
                iconBackground: const Color(0xFFC6E1C7),
                iconColor: const Color(0xFF4E5750),
                title: 'Emergency Contacts',
                subtitle: record.emergencyContactNumber,
                compactTitle: true,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _RecordInfoCard extends StatelessWidget {
  const _RecordInfoCard({
    required this.icon,
    required this.iconBackground,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    this.cardHeight = 98,
    this.compactTitle = false,
  });

  final IconData icon;
  final Color iconBackground;
  final Color iconColor;
  final String title;
  final String subtitle;
  final double cardHeight;
  final bool compactTitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: cardHeight,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF9F4F4),
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
            color: Color(0x24000000),
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: iconBackground,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 30),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF35383D),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: compactTitle ? 11.5 : 11.5,
                      height: 1.25,
                      color: const Color(0xFF35383D),
                      fontWeight: compactTitle
                          ? FontWeight.w500
                          : FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RecentActivityCard extends StatelessWidget {
  const _RecentActivityCard({required this.record});

  final HealthRecordData record;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF9F4F4),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Recent Health Activity',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Color(0xFF24229A),
            ),
          ),
          const SizedBox(height: 14),
          _ActivityItem(
            icon: Icons.work_rounded,
            iconBackground: const Color(0xFFF7B0B0),
            title: 'Last Checkup',
            subtitle: record.lastCheckup,
          ),
          _ActivityItem(
            icon: Icons.vaccines_rounded,
            iconBackground: const Color(0xFFAED0F8),
            title: 'Vaccination Status',
            subtitle: record.vaccinationStatus,
          ),
          _ActivityItem(
            icon: Icons.edit_note_rounded,
            iconBackground: const Color(0xFFF8F19A),
            title: 'Medical Notes',
            subtitle: record.medicalNotes,
          ),
        ],
      ),
    );
  }
}

class _ActivityItem extends StatelessWidget {
  const _ActivityItem({
    required this.icon,
    required this.iconBackground,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final Color iconBackground;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: iconBackground,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: const Color(0xFF303030), size: 22),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF35383D),
                  ),
                ),
                const SizedBox(height: 1),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 10.5,
                    color: Color(0xFF454B52),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RecordActionButton extends StatelessWidget {
  const _RecordActionButton({
    required this.label,
    required this.icon,
    required this.backgroundColor,
  });

  final String label;
  final IconData icon;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 28),
          const SizedBox(width: 10),
          Expanded(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(
                label,
                maxLines: 1,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class EditHealthRecordScreen extends StatefulWidget {
  const EditHealthRecordScreen({super.key, required this.initialRecord});

  final HealthRecordData initialRecord;

  @override
  State<EditHealthRecordScreen> createState() => _EditHealthRecordScreenState();
}

class _EditHealthRecordScreenState extends State<EditHealthRecordScreen> {
  late final TextEditingController _usernameController;
  late final TextEditingController _ageController;
  late final TextEditingController _healthStatusController;
  late final TextEditingController _bloodGroupController;
  late final TextEditingController _allergiesController;
  late final TextEditingController _medicationsController;
  late final TextEditingController _emergencyContactController;
  late final TextEditingController _lastCheckupController;
  late final TextEditingController _vaccinationStatusController;
  late final TextEditingController _medicalNotesController;

  @override
  void initState() {
    super.initState();
    final record = widget.initialRecord;
    _usernameController = TextEditingController(text: record.username);
    _ageController = TextEditingController(text: record.age.toString());
    _healthStatusController = TextEditingController(text: record.healthStatus);
    _bloodGroupController = TextEditingController(text: record.bloodGroup);
    _allergiesController = TextEditingController(text: record.allergies);
    _medicationsController = TextEditingController(text: record.medications);
    _emergencyContactController = TextEditingController(
      text: record.emergencyContactNumber,
    );
    _lastCheckupController = TextEditingController(text: record.lastCheckup);
    _vaccinationStatusController = TextEditingController(
      text: record.vaccinationStatus,
    );
    _medicalNotesController = TextEditingController(text: record.medicalNotes);
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _ageController.dispose();
    _healthStatusController.dispose();
    _bloodGroupController.dispose();
    _allergiesController.dispose();
    _medicationsController.dispose();
    _emergencyContactController.dispose();
    _lastCheckupController.dispose();
    _vaccinationStatusController.dispose();
    _medicalNotesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        foregroundColor: const Color(0xFF24229A),
        title: Text(
          context.tx(
            'Edit Health Record',
            'स्वास्थ्य रेकर्ड सम्पादन गर्नुहोस्',
          ),
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        child: Column(
          children: [
            _EditField(label: 'Username', controller: _usernameController),
            _EditField(label: 'Age', controller: _ageController),
            _EditField(
              label: 'Health Status',
              controller: _healthStatusController,
            ),
            _EditField(label: 'Blood Group', controller: _bloodGroupController),
            _EditField(label: 'Allergies', controller: _allergiesController),
            _EditField(
              label: 'Medications',
              controller: _medicationsController,
              maxLines: 2,
            ),
            _EditField(
              label: 'Emergency Contact Number',
              controller: _emergencyContactController,
            ),
            _EditField(
              label: 'Last Checkup',
              controller: _lastCheckupController,
            ),
            _EditField(
              label: 'Vaccination Status',
              controller: _vaccinationStatusController,
            ),
            _EditField(
              label: 'Medical Notes',
              controller: _medicalNotesController,
              maxLines: 3,
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _saveChanges,
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF1E84EA),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                child: Text(
                  context.tx('Save Changes', 'परिवर्तन सुरक्षित गर्नुहोस्'),
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _saveChanges() {
    final updated = widget.initialRecord.copyWith(
      username: _usernameController.text.trim(),
      age: int.tryParse(_ageController.text.trim()) ?? widget.initialRecord.age,
      healthStatus: _healthStatusController.text.trim(),
      bloodGroup: _bloodGroupController.text.trim(),
      allergies: _allergiesController.text.trim(),
      medications: _medicationsController.text.trim(),
      emergencyContactNumber: _emergencyContactController.text.trim(),
      lastCheckup: _lastCheckupController.text.trim(),
      vaccinationStatus: _vaccinationStatusController.text.trim(),
      medicalNotes: _medicalNotesController.text.trim(),
    );

    Navigator.of(context).pop(updated);
  }
}

class _EditField extends StatelessWidget {
  const _EditField({
    required this.label,
    required this.controller,
    this.maxLines = 1,
  });

  final String label;
  final TextEditingController controller;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}

class HealthRecordData {
  const HealthRecordData({
    required this.username,
    required this.age,
    required this.healthStatus,
    required this.bloodGroup,
    required this.allergies,
    required this.medications,
    required this.emergencyContactNumber,
    required this.lastCheckup,
    required this.vaccinationStatus,
    required this.medicalNotes,
  });

  factory HealthRecordData.fromUser(AuthUser? user) {
    return HealthRecordData(
      username: user?.fullName.trim().isNotEmpty == true
          ? user!.fullName.trim()
          : 'Anisha Sharma',
      age: 22,
      healthStatus: 'Healthy',
      bloodGroup: user?.bloodGroup?.trim().isNotEmpty == true
          ? user!.bloodGroup!.trim()
          : 'O+ Positive',
      allergies: 'Dust Mite Allergy',
      medications: 'Over-the-Counter (OTC) Medications',
      emergencyContactNumber: user?.phoneNumber.trim().isNotEmpty == true
          ? user!.phoneNumber.trim()
          : '+977 9865432369',
      lastCheckup: '12 Oct 2023 - Dr.Verma',
      vaccinationStatus: 'Fully Vaccination (COVID 19)',
      medicalNotes: 'Routine Checkup Complete',
    );
  }

  factory HealthRecordData.fromJson(Map<String, dynamic> json) {
    return HealthRecordData(
      username: json['username'] as String? ?? 'Anisha Sharma',
      age: json['age'] as int? ?? 22,
      healthStatus: json['healthStatus'] as String? ?? 'Healthy',
      bloodGroup: json['bloodGroup'] as String? ?? 'O+ Positive',
      allergies: json['allergies'] as String? ?? 'Dust Mite Allergy',
      medications:
          json['medications'] as String? ??
          'Over-the-Counter (OTC) Medications',
      emergencyContactNumber:
          json['emergencyContactNumber'] as String? ?? '+977 9865432369',
      lastCheckup: json['lastCheckup'] as String? ?? '12 Oct 2023 - Dr.Verma',
      vaccinationStatus:
          json['vaccinationStatus'] as String? ??
          'Fully Vaccination (COVID 19)',
      medicalNotes:
          json['medicalNotes'] as String? ?? 'Routine Checkup Complete',
    );
  }

  final String username;
  final int age;
  final String healthStatus;
  final String bloodGroup;
  final String allergies;
  final String medications;
  final String emergencyContactNumber;
  final String lastCheckup;
  final String vaccinationStatus;
  final String medicalNotes;

  HealthRecordData copyWith({
    String? username,
    int? age,
    String? healthStatus,
    String? bloodGroup,
    String? allergies,
    String? medications,
    String? emergencyContactNumber,
    String? lastCheckup,
    String? vaccinationStatus,
    String? medicalNotes,
  }) {
    return HealthRecordData(
      username: username ?? this.username,
      age: age ?? this.age,
      healthStatus: healthStatus ?? this.healthStatus,
      bloodGroup: bloodGroup ?? this.bloodGroup,
      allergies: allergies ?? this.allergies,
      medications: medications ?? this.medications,
      emergencyContactNumber:
          emergencyContactNumber ?? this.emergencyContactNumber,
      lastCheckup: lastCheckup ?? this.lastCheckup,
      vaccinationStatus: vaccinationStatus ?? this.vaccinationStatus,
      medicalNotes: medicalNotes ?? this.medicalNotes,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'age': age,
      'healthStatus': healthStatus,
      'bloodGroup': bloodGroup,
      'allergies': allergies,
      'medications': medications,
      'emergencyContactNumber': emergencyContactNumber,
      'lastCheckup': lastCheckup,
      'vaccinationStatus': vaccinationStatus,
      'medicalNotes': medicalNotes,
    };
  }
}
