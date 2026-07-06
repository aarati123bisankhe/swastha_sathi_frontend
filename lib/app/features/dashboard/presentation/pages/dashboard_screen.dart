// import 'package:flutter/material.dart';
// import 'package:swasthasathi/app/features/auth/domain/entities/auth_user.dart';

// class DashboardScreen extends StatelessWidget {
//   const DashboardScreen({super.key, this.user});

//   final AuthUser? user;

//   @override
//   Widget build(BuildContext context) {
//     final name = _firstName(user?.fullName) ?? 'Aarati';
//     final bloodGroup = user?.bloodGroup?.trim().isNotEmpty == true
//         ? user!.bloodGroup!.trim()
//         : 'O+';

//     return Scaffold(
//       backgroundColor: const Color(0xFFDCEAF5),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           'Namaste, $name 👋',
//                           style: const TextStyle(
//                             fontSize: 20,
//                             fontWeight: FontWeight.w600,
//                             color: Colors.black,
//                           ),
//                         ),
//                         const SizedBox(height: 2),
//                         const Text(
//                           'Take care, stay healthy!',
//                           style: TextStyle(
//                             fontSize: 15,
//                             color: Colors.black87,
//                             fontWeight: FontWeight.w400,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   Container(
//                     margin: const EdgeInsets.only(top: 8),
//                     padding: const EdgeInsets.all(8),
//                     child: const Icon(
//                       Icons.notifications,
//                       color: Color(0xFF15396B),
//                       size: 34,
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 22),
//               _StatusCard(bloodGroup: bloodGroup),
//               const SizedBox(height: 24),
//               const _OfflineBanner(),
//               const SizedBox(height: 28),
//               _SectionHeader(
//                 title: 'Quick Emergency Actions',
//                 actionLabel: 'View all',
//                 onActionTap: () {},
//               ),
//               const SizedBox(height: 16),
//               LayoutBuilder(
//                 builder: (context, constraints) {
//                   final tileWidth = (constraints.maxWidth - 36) / 4;
//                   return Wrap(
//                     spacing: 12,
//                     runSpacing: 12,
//                     children: const [
//                       _ActionTile(
//                         title: 'Call\nAmbulance',
//                         icon: Icons.emergency_outlined,
//                         colors: [Color(0xFFFF6B6B), Color(0xFFF64545)],
//                       ),
//                       _ActionTile(
//                         title: 'Blood\nRequest',
//                         icon: Icons.water_drop,
//                         colors: [Color(0xFFFF3838), Color(0xFFE1142D)],
//                       ),
//                       _ActionTile(
//                         title: 'Emergency\nSMS',
//                         icon: Icons.sms_outlined,
//                         colors: [Color(0xFF58B4FF), Color(0xFF1F6FD7)],
//                       ),
//                       _ActionTile(
//                         title: 'Share\nLocation',
//                         icon: Icons.location_on,
//                         colors: [Color(0xFF5BCC5C), Color(0xFF1BA64A)],
//                       ),
//                     ].map((tile) => SizedBox(width: tileWidth, child: tile)).toList(),
//                   );
//                 },
//               ),
//               const SizedBox(height: 28),
//               const Text(
//                 'Health Features',
//                 style: TextStyle(
//                   fontSize: 22,
//                   fontWeight: FontWeight.w500,
//                   color: Color(0xFF333333),
//                 ),
//               ),
//               const SizedBox(height: 18),
//               LayoutBuilder(
//                 builder: (context, constraints) {
//                   const firstRowSpacing = 10.67;
//                   const secondRowSpacing = 16.0;
//                   final firstRowWidth =
//                       (constraints.maxWidth - (firstRowSpacing * 3)) / 4;
//                   final secondRowWidth =
//                       (constraints.maxWidth - secondRowSpacing) / 4;

//                   return Column(
//                     children: [
//                       Row(
//                         children: const [
//                           _FeatureTile(
//                             title: 'Symptom\nChecker',
//                             icon: Icons.health_and_safety,
//                             iconColor: Color(0xFF1E88E5),
//                           ),
//                           _FeatureTile(
//                             title: 'First Aid\nGuide',
//                             icon: Icons.medical_services,
//                             iconColor: Color(0xFFFF2D55),
//                           ),
//                           _FeatureTile(
//                             title: 'Hospital',
//                             icon: Icons.local_hospital,
//                             iconColor: Color(0xFF1E88E5),
//                           ),
//                           _FeatureTile(
//                             title: 'Doctor',
//                             icon: Icons.person,
//                             iconColor: Color(0xFF12B886),
//                           ),
//                         ].asMap().entries.map((entry) {
//                           return Padding(
//                             padding: EdgeInsets.only(
//                               right: entry.key == 3 ? 0 : firstRowSpacing,
//                             ),
//                             child: SizedBox(
//                               width: firstRowWidth,
//                               child: entry.value,
//                             ),
//                           );
//                         }).toList(),
//                       ),
//                       const SizedBox(height: 16),
//                       Row(
//                         children: [
//                           SizedBox(
//                             width: secondRowWidth,
//                             child: const _FeatureTile(
//                               title: 'Health\nRecord',
//                               icon: Icons.assignment,
//                               iconColor: Color(0xFF7C4DFF),
//                             ),
//                           ),
//                           const SizedBox(width: secondRowSpacing),
//                           SizedBox(
//                             width: secondRowWidth,
//                             child: const _FeatureTile(
//                               title: 'Awarness\nVideo',
//                               icon: Icons.videocam,
//                               iconColor: Color(0xFF7C4DFF),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   );
//                 },
//               ),
//               const SizedBox(height: 26),
//               const _HealthTipCard(),
//             ],
//           ),
//         ),
//       ),
//       bottomNavigationBar: const _DashboardBottomNav(),
//     );
//   }

//   String? _firstName(String? fullName) {
//     if (fullName == null) return null;
//     final trimmed = fullName.trim();
//     if (trimmed.isEmpty) return null;
//     return trimmed.split(RegExp(r'\s+')).first;
//   }
// }

// class _StatusCard extends StatelessWidget {
//   const _StatusCard({required this.bloodGroup});

//   final String bloodGroup;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.fromLTRB(20, 16, 20, 18),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(26),
//         gradient: const LinearGradient(
//           colors: [Color(0xFF1E88F7), Color(0xFFBFD9F3), Color(0xFF1786F3)],
//           begin: Alignment.centerLeft,
//           end: Alignment.centerRight,
//         ),
//       ),
//       child: Column(
//         children: [
//           Image.asset(
//             'assets/images/logo.png',
//             height: 110,
//             fit: BoxFit.contain,
//           ),
//           const SizedBox(height: 6),
//           Row(
//             crossAxisAlignment: CrossAxisAlignment.end,
//             children: [
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const Text(
//                       'Blood Group',
//                       style: TextStyle(
//                         fontSize: 16,
//                         color: Colors.white,
//                         fontWeight: FontWeight.w400,
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     Row(
//                       children: [
//                         Text(
//                           bloodGroup,
//                           style: const TextStyle(
//                             fontSize: 23,
//                             color: Colors.white,
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                         const SizedBox(width: 10),
//                         Container(
//                           width: 26,
//                           height: 26,
//                           decoration: const BoxDecoration(
//                             color: Colors.white,
//                             shape: BoxShape.circle,
//                           ),
//                           child: const Icon(
//                             Icons.bloodtype,
//                             color: Color(0xFFFF5A5F),
//                             size: 18,
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 28),
//                     const Text(
//                       'Blood Group',
//                       style: TextStyle(
//                         fontSize: 16,
//                         color: Colors.white,
//                         fontWeight: FontWeight.w400,
//                       ),
//                     ),
//                     const SizedBox(height: 6),
//                     Text(
//                       '🗓 2 week ago',
//                       style: TextStyle(
//                         fontSize: 15,
//                         color: Colors.white.withValues(alpha: 0.92),
//                         fontWeight: FontWeight.w400,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(width: 16),
//               const Column(
//                 crossAxisAlignment: CrossAxisAlignment.end,
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Text(
//                     'Status',
//                     style: TextStyle(
//                       fontSize: 17,
//                       color: Colors.white,
//                       fontWeight: FontWeight.w400,
//                     ),
//                   ),
//                   SizedBox(height: 8),
//                   Text(
//                     'Healthy ✅',
//                     textAlign: TextAlign.right,
//                     style: TextStyle(
//                       fontSize: 15,
//                       color: Colors.white,
//                       fontWeight: FontWeight.w400,
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _OfflineBanner extends StatelessWidget {
//   const _OfflineBanner();

//   @override
//   Widget build(BuildContext context) {
//     return ClipRRect(
//       borderRadius: BorderRadius.circular(24),
//       child: Image.asset(
//         'assets/images/offline_banner.png',
//         width: double.infinity,
//         fit: BoxFit.cover,
//       ),
//     );
//   }
// }

// class _SectionHeader extends StatelessWidget {
//   const _SectionHeader({
//     required this.title,
//     required this.actionLabel,
//     required this.onActionTap,
//   });

//   final String title;
//   final String actionLabel;
//   final VoidCallback onActionTap;

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         Expanded(
//           child: Text(
//             title,
//             style: const TextStyle(
//               fontSize: 22,
//               fontWeight: FontWeight.w500,
//               color: Colors.black,
//             ),
//           ),
//         ),
//         GestureDetector(
//           onTap: onActionTap,
//           child: const Text(
//             'View all',
//             style: TextStyle(
//               fontSize: 18,
//               color: Color(0xFF2D5BFF),
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }

// class _ActionTile extends StatelessWidget {
//   const _ActionTile({
//     required this.title,
//     required this.icon,
//     required this.colors,
//   });

//   final String title;
//   final IconData icon;
//   final List<Color> colors;

//   @override
//   Widget build(BuildContext context) {
//     return AspectRatio(
//       aspectRatio: 0.72,
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 12),
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(22),
//           gradient: LinearGradient(
//             colors: colors,
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//           ),
//           boxShadow: const [
//             BoxShadow(
//               color: Color(0x22000000),
//               blurRadius: 12,
//               offset: Offset(0, 4),
//             ),
//           ],
//         ),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(icon, size: 40, color: Colors.white),
//             const SizedBox(height: 10),
//             Text(
//               title,
//               textAlign: TextAlign.center,
//               style: const TextStyle(
//                 fontSize: 14,
//                 height: 1.15,
//                 color: Colors.white,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class _FeatureTile extends StatelessWidget {
//   const _FeatureTile({
//     required this.title,
//     required this.icon,
//     required this.iconColor,
//   });

//   final String title;
//   final IconData icon;
//   final Color iconColor;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 132,
//       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(20),
//         boxShadow: const [
//           BoxShadow(
//             color: Color(0x26000000),
//             blurRadius: 12,
//             offset: Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(icon, size: 38, color: iconColor),
//           const SizedBox(height: 12),
//           Text(
//             title,
//             textAlign: TextAlign.center,
//             style: const TextStyle(
//               fontSize: 13,
//               height: 1.12,
//               color: Colors.black,
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _HealthTipCard extends StatelessWidget {
//   const _HealthTipCard();

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.fromLTRB(22, 20, 22, 18),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(26),
//         gradient: const LinearGradient(
//           colors: [Color(0xFFEFFAF0), Color(0xFFF7FBF1), Color(0xFFE5F7E8)],
//           begin: Alignment.centerLeft,
//           end: Alignment.centerRight,
//         ),
//         border: Border.all(color: const Color(0xFFE0F0E1)),
//       ),
//       child: Row(
//         children: [
//           const Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   children: [
//                     Icon(Icons.spa, color: Color(0xFF1D9A5A), size: 24),
//                     SizedBox(width: 10),
//                     Text(
//                       'Daily Health Tip',
//                       style: TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.w700,
//                         color: Color(0xFF21895A),
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 12),
//                 Text(
//                   'Drink at least 8 glasses of water daily\n'
//                   'to stay hydrated and maintain good health.',
//                   style: TextStyle(
//                     fontSize: 14,
//                     height: 1.5,
//                     color: Color(0xFF676767),
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(width: 14),
//           Column(
//             children: [
//               Icon(
//                 Icons.local_drink_outlined,
//                 size: 86,
//                 color: Color(0xFF56BFFF),
//               ),
//               SizedBox(height: 16),
//               Row(
//                 children: List.generate(
//                   4,
//                   (index) => Container(
//                     width: 10,
//                     height: 10,
//                     margin: const EdgeInsets.symmetric(horizontal: 4),
//                     decoration: BoxDecoration(
//                       color: index == 0
//                           ? const Color(0xFF18A74B)
//                           : const Color(0xFFD7DDDD),
//                       shape: BoxShape.circle,
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _DashboardBottomNav extends StatelessWidget {
//   const _DashboardBottomNav();

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 106,
//       decoration: const BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceAround,
//         children: const [
//           _BottomNavItem(
//             icon: Icons.home,
//             label: 'Home',
//             active: true,
//           ),
//           _BottomNavItem(
//             icon: Icons.call,
//             label: 'Emergency',
//           ),
//           _BottomNavItem(
//             icon: Icons.headset_mic,
//             label: 'Support',
//           ),
//           _BottomNavItem(
//             icon: Icons.assignment_outlined,
//             label: 'Record',
//           ),
//           _BottomNavItem(
//             icon: Icons.person,
//             label: 'Profile',
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _BottomNavItem extends StatelessWidget {
//   const _BottomNavItem({
//     required this.icon,
//     required this.label,
//     this.active = false,
//   });

//   final IconData icon;
//   final String label;
//   final bool active;

//   @override
//   Widget build(BuildContext context) {
//     final color = active ? const Color(0xFF0B73E8) : const Color(0xFF183B66);
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Icon(icon, size: 40, color: color),
//         const SizedBox(height: 6),
//         Text(
//           label,
//           style: TextStyle(
//             fontSize: 14,
//             fontWeight: FontWeight.w500,
//             color: active ? color : Colors.black,
//           ),
//         ),
//       ],
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:swasthasathi/app/features/auth/domain/entities/auth_user.dart';
import 'package:swasthasathi/app/features/dashboard/presentation/pages/notification_screen.dart';
import 'package:swasthasathi/app/features/dashboard/presentation/widgets/dashboard_bottom_nav.dart';
import 'package:swasthasathi/app/features/emergency/presentation/pages/call_ambulance_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key, this.user});

  final AuthUser? user;

  @override
  Widget build(BuildContext context) {
    final name = _firstName(user?.fullName) ?? 'Aarati';
    final bloodGroup = user?.bloodGroup?.trim().isNotEmpty == true
        ? user!.bloodGroup!.trim()
        : 'O+';

    return Scaffold(
      backgroundColor: const Color(0xFFDCEAF5),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 120),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Namaste, $name 👋',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 0),
                        const Text(
                          'Take care, stay healthy!',
                          style: TextStyle(
                            fontSize: 14,
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
                    child: Container(
                      margin: const EdgeInsets.only(top: 0),
                      padding: const EdgeInsets.all(4),
                      child: const Icon(
                        Icons.notifications,
                        color: Color(0xFF15396B),
                        size: 26,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 3),

              _StatusCard(bloodGroup: bloodGroup),

              const SizedBox(height: 0),

              Transform.translate(
                offset: Offset(0, -22),
                child: _OfflineBanner(),
              ),

              const SizedBox(height: 0),

              Transform.translate(
                offset: const Offset(0, -40),
                child: _SectionHeader(
                  title: 'Quick Emergency Actions',
                  actionLabel: 'View all',
                  onActionTap: () {},
                ),
              ),

              const SizedBox(height: 0),

              Transform.translate(
                offset: const Offset(0, -31),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final tileWidth = (constraints.maxWidth - 39) / 4;

                    return Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children:
                          [
                            _ActionTile(
                              title: 'Call\nAmbulance',
                              icon: Icons.emergency_outlined,
                              colors: const [
                                Color(0xFFFF6B6B),
                                Color(0xFFF64545),
                              ],
                              onTap: () => _openAmbulanceScreen(context),
                            ),
                            const _ActionTile(
                              title: 'Blood\nRequest',
                              icon: Icons.water_drop,
                              colors: [Color(0xFFFF3838), Color(0xFFE1142D)],
                            ),
                            const _ActionTile(
                              title: 'Emergency\nSMS',
                              icon: Icons.sms_outlined,
                              colors: [Color(0xFF58B4FF), Color(0xFF1F6FD7)],
                            ),
                            const _ActionTile(
                              title: 'Share\nLocation',
                              icon: Icons.location_on,
                              colors: [Color(0xFF5BCC5C), Color(0xFF1BA64A)],
                            ),
                          ].map((tile) {
                            return SizedBox(width: tileWidth, child: tile);
                          }).toList(),
                    );
                  },
                ),
              ),

              Transform.translate(
                offset: const Offset(0, -17),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Health Features',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF333333),
                      ),
                    ),

                    const SizedBox(height: 10),

                    LayoutBuilder(
                      builder: (context, constraints) {
                        const firstRowSpacing = 10.67;
                        const secondRowSpacing = 16.0;

                        final firstRowWidth =
                            (constraints.maxWidth - (firstRowSpacing * 3)) / 4;

                        final secondRowWidth =
                            (constraints.maxWidth - secondRowSpacing) / 4;

                        return Column(
                          children: [
                            Row(
                              children:
                                  const [
                                    _FeatureTile(
                                      title: 'Symptom\nChecker',
                                      icon: Icons.health_and_safety,
                                      iconColor: Color(0xFF1E88E5),
                                    ),
                                    _FeatureTile(
                                      title: 'First Aid\nGuide',
                                      icon: Icons.medical_services,
                                      iconColor: Color(0xFFFF2D55),
                                    ),
                                    _FeatureTile(
                                      title: 'Hospital',
                                      icon: Icons.local_hospital,
                                      iconColor: Color(0xFF1E88E5),
                                    ),
                                    _FeatureTile(
                                      title: 'Doctor',
                                      icon: Icons.person,
                                      iconColor: Color(0xFF12B886),
                                    ),
                                  ].asMap().entries.map((entry) {
                                    return Padding(
                                      padding: EdgeInsets.only(
                                        right: entry.key == 3
                                            ? 0
                                            : firstRowSpacing,
                                      ),
                                      child: SizedBox(
                                        width: firstRowWidth,
                                        child: entry.value,
                                      ),
                                    );
                                  }).toList(),
                            ),

                            const SizedBox(height: 10),

                            Row(
                              children: [
                                SizedBox(
                                  width: secondRowWidth,
                                  child: const _FeatureTile(
                                    title: 'Health\nRecord',
                                    icon: Icons.assignment,
                                    iconColor: Color(0xFF7C4DFF),
                                  ),
                                ),
                                const SizedBox(width: secondRowSpacing),
                                SizedBox(
                                  width: secondRowWidth,
                                  child: const _FeatureTile(
                                    title: 'Awareness\nVideo',
                                    icon: Icons.videocam,
                                    iconColor: Color(0xFF7C4DFF),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 5),

              Transform.translate(
                offset: const Offset(0, -23),
                child: const _HealthTipCard(),
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

  String? _firstName(String? fullName) {
    if (fullName == null) return null;

    final trimmed = fullName.trim();

    if (trimmed.isEmpty) return null;

    return trimmed.split(RegExp(r'\s+')).first;
  }

  void _openAmbulanceScreen(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => CallAmbulanceScreen(user: user),
      ),
    );
  }
}

class _StatusCard extends StatelessWidget {
  const _StatusCard({required this.bloodGroup});

  final String bloodGroup;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: SizedBox(
        width: double.infinity,
        height: 155,
        child: Image.asset(
          'assets/images/status_card_banner.png',
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class _OfflineBanner extends StatelessWidget {
  const _OfflineBanner();

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: Image.asset(
        'assets/images/offline_banner.png',
        width: double.infinity,
        fit: BoxFit.cover,
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    required this.actionLabel,
    required this.onActionTap,
  });

  final String title;
  final String actionLabel;
  final VoidCallback onActionTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
        ),

        GestureDetector(
          onTap: onActionTap,
          child: Text(
            actionLabel,
            style: const TextStyle(
              fontSize: 15,
              color: Color(0xFF2D5BFF),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}

class _ActionTile extends StatelessWidget {
  const _ActionTile({
    required this.title,
    required this.icon,
    required this.colors,
    this.onTap,
  });

  final String title;
  final IconData icon;
  final List<Color> colors;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: 96,
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          gradient: LinearGradient(
            colors: colors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: const [
            BoxShadow(
              color: Color(0x22000000),
              blurRadius: 12,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 28, color: Colors.white),

            const SizedBox(height: 6),

            Flexible(
              child: Text(
                title,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 11,
                  height: 1.1,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FeatureTile extends StatelessWidget {
  const _FeatureTile({
    required this.title,
    required this.icon,
    required this.iconColor,
  });

  final String title;
  final IconData icon;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 89,
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(
            color: Color(0x26000000),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 26, color: iconColor),

          const SizedBox(height: 6),

          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 10.5,
              height: 1.12,
              color: Colors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _HealthTipCard extends StatefulWidget {
  const _HealthTipCard();

  @override
  State<_HealthTipCard> createState() => _HealthTipCardState();
}

class _HealthTipCardState extends State<_HealthTipCard> {
  int currentIndex = 0;

  final List<String> tips = [
    'Drink at least 8 glasses of water daily\nto stay hydrated and maintain good health.',
    'Walk at least 20 minutes every day\nto keep your body active and healthy.',
    'Sleep 7-8 hours daily\nto improve energy and immunity.',
    'Eat fruits and vegetables daily\nto maintain good health.',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 120,
          child: PageView.builder(
            itemCount: tips.length,
            onPageChanged: (index) {
              setState(() {
                currentIndex = index;
              });
            },
            itemBuilder: (context, index) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(26),
                child: Image.asset(
                  'assets/images/daily_health_tip_banner.png',
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
