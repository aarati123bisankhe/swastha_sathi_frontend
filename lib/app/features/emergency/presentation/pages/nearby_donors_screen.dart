import 'package:flutter/material.dart';
import 'package:swasthasathi/app/features/auth/domain/entities/auth_user.dart';
import 'package:swasthasathi/app/features/dashboard/presentation/pages/notification_screen.dart';
import 'package:swasthasathi/app/features/dashboard/presentation/widgets/dashboard_bottom_nav.dart';

class NearbyDonorsScreen extends StatelessWidget {
  const NearbyDonorsScreen({super.key, this.user});

  final AuthUser? user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 120),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.of(context).pop(),
                          child: const Padding(
                            padding: EdgeInsets.only(top: 7, right: 10),
                            child: Icon(
                              Icons.arrow_back_ios_new_rounded,
                              color: Color(0xFF6B7080),
                              size: 18,
                            ),
                          ),
                        ),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.opacity,
                                    color: Color(0xFFE2121B),
                                    size: 22,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    'Nearby Donors',
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w800,
                                      color: Color(0xFF231A77),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Find blood donor near you who are available help.',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
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
              ),
              const SizedBox(height: 20),
              const _DonorListTile(
                name: 'Sushant Shrestha',
                bloodGroup: 'O+',
                location: 'Kathmandu, Nepal',
                lastDonated: 'Last donated 3 month ago',
                avatarAsset: 'assets/images/donor_avatar_1.png',
              ),
              const SizedBox(height: 11),
              const _DonorListTile(
                name: 'Aanjali Thapa',
                bloodGroup: 'A+',
                location: 'Lalitpur, Nepal',
                lastDonated: 'Last donated 1 month ago',
                avatarAsset: 'assets/images/donor_avatar_2.png',
              ),
              const SizedBox(height: 11),
              const _DonorListTile(
                name: 'Yamsung Rai',
                bloodGroup: 'B+',
                location: 'Bhaktapur, Nepal',
                lastDonated: 'Last donated 1 month ago',
                avatarAsset: 'assets/images/donor_avatar_3.png',
              ),
              const SizedBox(height: 11),
              const _DonorListTile(
                name: 'Aryan Jung Rana',
                bloodGroup: 'A+',
                location: 'Lalitpur, Nepal',
                lastDonated: 'Last donated 5 month ago',
                avatarAsset: 'assets/images/donor_avatar_4.png',
              ),
              const SizedBox(height: 11),
              const _DonorListTile(
                name: 'Pratina Karki',
                bloodGroup: 'B+',
                location: 'Lalitpur, Nepal',
                lastDonated: 'Last donated 1 month ago',
                avatarAsset: 'assets/images/donor_avatar_5.png',
              ),
              const SizedBox(height: 11),
              const _DonorListTile(
                name: 'Renuka Sharma',
                bloodGroup: 'A+',
                location: 'Kathmandu, Nepal',
                lastDonated: 'Last donated 3 month ago',
                avatarAsset: 'assets/images/donor_avatar_6.png',
              ),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(24, 24, 20, 24),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  gradient: const LinearGradient(
                    colors: [Color(0xFFF9FBFF), Color(0xFFF2ECFF)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  border: Border.all(color: const Color(0xFFE2DDF8)),
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.verified_user_rounded,
                      color: Color(0xFF6246EA),
                      size: 46,
                    ),
                    SizedBox(width: 18),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Blood Donors Save Lives',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            'You\'re one donation can save up to three lives.',
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF616161),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Learn more about blood donation',
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF5B59FF),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: DashboardBottomNav(
        activeTab: DashboardNavTab.home,
        user: user,
      ),
    );
  }
}

class _DonorListTile extends StatelessWidget {
  const _DonorListTile({
    required this.name,
    required this.bloodGroup,
    required this.location,
    required this.lastDonated,
    required this.avatarAsset,
  });

  final String name;
  final String bloodGroup;
  final String location;
  final String lastDonated;
  final String avatarAsset;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.34),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFF9FA1E6), width: 1.3),
      ),
      child: Row(
        children: [
          CircleAvatar(radius: 24, backgroundImage: AssetImage(avatarAsset)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        name,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5B4BC),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Text(
                        bloodGroup,
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFFFF4040),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    const Icon(
                      Icons.location_on,
                      color: Color(0xFF17345F),
                      size: 14,
                    ),
                    const SizedBox(width: 3),
                    Text(
                      location,
                      style: const TextStyle(
                        fontSize: 10,
                        color: Color(0xFF555555),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(
                      Icons.flag_outlined,
                      color: Color(0xFFB17272),
                      size: 12,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      lastDonated,
                      style: const TextStyle(
                        fontSize: 9,
                        color: Color(0xFF6B6B6B),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
            decoration: BoxDecoration(
              color: const Color(0xFFE7FAEA),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Container(
                  width: 7,
                  height: 7,
                  decoration: const BoxDecoration(
                    color: Color(0xFF09B84E),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 5),
                const Text(
                  'Available Now',
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF00B04A),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            width: 34,
            height: 34,
            decoration: const BoxDecoration(
              color: Color(0xFFFF1026),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.call, color: Colors.white, size: 16),
          ),
        ],
      ),
    );
  }
}
