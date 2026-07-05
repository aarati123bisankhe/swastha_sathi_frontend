import 'package:flutter/material.dart';
import 'package:swasthasathi/app/features/auth/domain/entities/auth_user.dart';
import 'package:swasthasathi/app/features/dashboard/presentation/widgets/dashboard_bottom_nav.dart';

class RecordScreen extends StatelessWidget {
  const RecordScreen({super.key, this.user});

  final AuthUser? user;

  @override
  Widget build(BuildContext context) {
    final fullName = user?.fullName.trim().isNotEmpty == true
        ? user!.fullName.trim()
        : 'Anisha Sharma';
    final bloodGroup = user?.bloodGroup?.trim().isNotEmpty == true
        ? user!.bloodGroup!.trim()
        : 'O+ Positive';
    final emergencyNumber = user?.phoneNumber.trim().isNotEmpty == true
        ? user!.phoneNumber.trim()
        : '+977 9865432369';

    return Scaffold(
      backgroundColor: const Color(0xFFDCEAF5),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 120),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _RecordHeader(),
              const SizedBox(height: 18),
              _ProfileSummaryCard(
                fullName: fullName,
                emergencyNumber: emergencyNumber,
              ),
              const SizedBox(height: 18),
              _RecordInfoGrid(
                bloodGroup: bloodGroup,
                emergencyNumber: emergencyNumber,
              ),
              const SizedBox(height: 15),
              const _RecentActivityCard(),
              const SizedBox(height: 15),
              const Row(
                children: [
                  Expanded(
                    child: _RecordActionButton(
                      label: 'Save Offline',
                      icon: Icons.download_rounded,
                      backgroundColor: Color(0xFF45AA3A),
                    ),
                  ),
                  SizedBox(width: 14),
                  Expanded(
                    child: _RecordActionButton(
                      label: 'Edit Records',
                      icon: Icons.edit_outlined,
                      backgroundColor: Color(0xFF1E84EA),
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
        user: user,
      ),
    );
  }
}

class _RecordHeader extends StatelessWidget {
  const _RecordHeader();

  @override
  Widget build(BuildContext context) {
    return const Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Health Record',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF24229A),
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Your Personal Medical Information',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 4),
          child: Icon(Icons.notifications, color: Color(0xFF193767), size: 30),
        ),
      ],
    );
  }
}

class _ProfileSummaryCard extends StatelessWidget {
  const _ProfileSummaryCard({
    required this.fullName,
    required this.emergencyNumber,
  });

  final String fullName;
  final String emergencyNumber;

  @override
  Widget build(BuildContext context) {
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
            child: const Icon(
              Icons.person_rounded,
              size: 78,
              color: Color(0xFF4A2A1E),
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
                  fullName,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF27323A),
                  ),
                ),
                const SizedBox(height: 20),
                const Row(
                  children: [
                    Expanded(
                      child: _ProfileMetaBlock(label: 'Age', value: '22 Years'),
                    ),
                    Expanded(
                      child: _ProfileMetaBlock(
                        label: 'Health Status',
                        value: 'Healthy',
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
  const _RecordInfoGrid({
    required this.bloodGroup,
    required this.emergencyNumber,
  });

  final String bloodGroup;
  final String emergencyNumber;

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
                subtitle: bloodGroup,
                cardHeight: 84,
              ),
            ),
            const SizedBox(width: 16),
            const Expanded(
              child: _RecordInfoCard(
                icon: Icons.warning_amber_rounded,
                iconBackground: Color(0xFFE3E3A9),
                iconColor: Color(0xFF121212),
                title: 'Allergies',
                subtitle: 'Dust Mit Allergy',
                cardHeight: 84,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            const Expanded(
              child: _RecordInfoCard(
                icon: Icons.medication_rounded,
                iconBackground: Color(0xFFF5DE97),
                iconColor: Color(0xFFD98317),
                title: 'Medications',
                subtitle: 'Over-the-Counter\n(OTC) Medications',
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _RecordInfoCard(
                icon: Icons.call,
                iconBackground: const Color(0xFFC6E1C7),
                iconColor: const Color(0xFF4E5750),
                title: 'Emergency Contacts',
                subtitle: emergencyNumber,
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
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF35383D),
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
                  const Spacer(),
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
  const _RecentActivityCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF9F4F4),
        borderRadius: BorderRadius.circular(24),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Recent Health Activity',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Color(0xFF24229A),
            ),
          ),
          SizedBox(height: 14),
          _ActivityItem(
            icon: Icons.work_rounded,
            iconBackground: Color(0xFFF7B0B0),
            title: 'Last Checkup',
            subtitle: '12 Oct 2023 - Dr.Verma',
          ),
          _ActivityItem(
            icon: Icons.vaccines_rounded,
            iconBackground: Color(0xFFAED0F8),
            title: 'Vaccination Status',
            subtitle: 'Fully Vaccination (COVID 19)',
          ),
          _ActivityItem(
            icon: Icons.edit_note_rounded,
            iconBackground: Color(0xFFF8F19A),
            title: 'Medical Notes',
            subtitle: 'Routine Checkup Complete',
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
      height: 64,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(32),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white, size: 28),
          const SizedBox(width: 10),
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
