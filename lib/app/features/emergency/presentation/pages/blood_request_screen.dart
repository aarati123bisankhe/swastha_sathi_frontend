// import 'package:flutter/material.dart';
// import 'package:swasthasathi/app/features/auth/domain/entities/auth_user.dart';
// import 'package:swasthasathi/app/features/dashboard/presentation/pages/notification_screen.dart';
// import 'package:swasthasathi/app/features/dashboard/presentation/widgets/dashboard_bottom_nav.dart';

// class BloodRequestScreen extends StatelessWidget {
//   const BloodRequestScreen({super.key, this.user});

//   final AuthUser? user;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFDCEAF5),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.fromLTRB(20, 20, 20, 120),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           'Blood Request',
//                           style: TextStyle(
//                             fontSize: 26,
//                             fontWeight: FontWeight.w800,
//                             color: Color(0xFF152984),
//                           ),
//                         ),
//                         SizedBox(height: 4),
//                         Text(
//                           'Find and request blood donors quickly',
//                           style: TextStyle(
//                             fontSize: 16,
//                             color: Colors.black87,
//                             fontWeight: FontWeight.w400,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   GestureDetector(
//                     onTap: () {
//                       Navigator.of(context).push(
//                         MaterialPageRoute<void>(
//                           builder: (context) => NotificationScreen(user: user),
//                         ),
//                       );
//                     },
//                     child: const Padding(
//                       padding: EdgeInsets.only(top: 4),
//                       child: Icon(
//                         Icons.notifications,
//                         color: Color(0xFF193767),
//                         size: 30,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 18),
//               const _BloodRequestHero(),
//               const SizedBox(height: 18),
//               const _BloodRequestFormCard(),
//               const SizedBox(height: 28),
//               const _NearbyDonorsCard(),
//               const SizedBox(height: 28),
//               Center(
//                 child: Container(
//                   width: 290,
//                   height: 78,
//                   decoration: BoxDecoration(
//                     color: const Color(0xFFFF1026),
//                     borderRadius: BorderRadius.circular(24),
//                     boxShadow: const [
//                       BoxShadow(
//                         color: Color(0x26000000),
//                         blurRadius: 12,
//                         offset: Offset(0, 6),
//                       ),
//                     ],
//                   ),
//                   child: const Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       CircleAvatar(
//                         radius: 22,
//                         backgroundColor: Colors.white,
//                         child: Icon(
//                           Icons.opacity,
//                           color: Color(0xFFE70D22),
//                           size: 28,
//                         ),
//                       ),
//                       SizedBox(width: 12),
//                       Text(
//                         'Send Blood Request',
//                         style: TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.w800,
//                           color: Colors.white,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//       bottomNavigationBar: DashboardBottomNav(
//         activeTab: DashboardNavTab.home,
//         user: user,
//       ),
//     );
//   }
// }

// class _BloodRequestHero extends StatelessWidget {
//   const _BloodRequestHero();

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.fromLTRB(20, 22, 20, 20),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(24),
//         gradient: const LinearGradient(
//           colors: [Color(0xFFC70000), Color(0xFFFF1946)],
//           begin: Alignment.centerLeft,
//           end: Alignment.centerRight,
//         ),
//         boxShadow: const [
//           BoxShadow(
//             color: Color(0x22000000),
//             blurRadius: 10,
//             offset: Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Row(
//         children: [
//           const Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   'Urgent Blood\nSupport Saves Lives',
//                   style: TextStyle(
//                     fontSize: 18,
//                     height: 1.15,
//                     fontWeight: FontWeight.w800,
//                     color: Colors.white,
//                   ),
//                 ),
//                 SizedBox(height: 16),
//                 Text(
//                   'Your request can bring\nhope and save a life.',
//                   style: TextStyle(
//                     fontSize: 14,
//                     height: 1.45,
//                     fontWeight: FontWeight.w500,
//                     color: Colors.white,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           SizedBox(
//             width: 150,
//             height: 130,
//             child: Stack(
//               alignment: Alignment.center,
//               children: [
//                 Positioned(
//                   top: 2,
//                   right: 14,
//                   child: Icon(
//                     Icons.favorite,
//                     color: Colors.white.withValues(alpha: 0.22),
//                     size: 34,
//                   ),
//                 ),
//                 Positioned(
//                   top: 18,
//                   left: 8,
//                   child: Icon(
//                     Icons.favorite,
//                     color: Colors.white.withValues(alpha: 0.14),
//                     size: 54,
//                   ),
//                 ),
//                 Positioned(
//                   left: 4,
//                   right: 4,
//                   child: Icon(
//                     Icons.show_chart,
//                     color: Colors.white.withValues(alpha: 0.38),
//                     size: 54,
//                   ),
//                 ),
//                 Container(
//                   width: 92,
//                   height: 110,
//                   decoration: BoxDecoration(
//                     shape: BoxShape.circle,
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.white.withValues(alpha: 0.35),
//                         blurRadius: 20,
//                         spreadRadius: 2,
//                       ),
//                     ],
//                   ),
//                   child: Stack(
//                     alignment: Alignment.center,
//                     children: [
//                       Icon(
//                         Icons.water_drop,
//                         size: 110,
//                         color: Colors.white.withValues(alpha: 0.94),
//                       ),
//                       Container(
//                         width: 42,
//                         height: 42,
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                         child: const Icon(
//                           Icons.add,
//                           color: Color(0xFFE8172E),
//                           size: 32,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _BloodRequestFormCard extends StatelessWidget {
//   const _BloodRequestFormCard();

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.fromLTRB(18, 18, 18, 20),
//       decoration: BoxDecoration(
//         color: const Color(0xFFF9F3F3),
//         borderRadius: BorderRadius.circular(24),
//         boxShadow: const [
//           BoxShadow(
//             color: Color(0x29000000),
//             blurRadius: 12,
//             offset: Offset(0, 5),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: const [
//           Row(
//             children: [
//               Icon(Icons.note_alt_outlined, color: Color(0xFFFF403B), size: 26),
//               SizedBox(width: 8),
//               Text(
//                 'Blood Request Form',
//                 style: TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.w800,
//                   color: Color(0xFF171717),
//                 ),
//               ),
//             ],
//           ),
//           SizedBox(height: 18),
//           Row(
//             children: [
//               Expanded(
//                 child: _FieldBlock(
//                   label: 'Patient Name',
//                   hint: 'Enter Patient Name',
//                   icon: Icons.person_outline,
//                 ),
//               ),
//               SizedBox(width: 16),
//               Expanded(
//                 child: _FieldBlock(
//                   label: 'Blood Group',
//                   hint: 'Enter Patient Name',
//                   icon: Icons.opacity,
//                   trailingIcon: Icons.keyboard_arrow_down,
//                   iconColor: Color(0xFFE51620),
//                 ),
//               ),
//             ],
//           ),
//           SizedBox(height: 14),
//           Row(
//             children: [
//               Expanded(
//                 child: _FieldBlock(
//                   label: 'Hospital Name',
//                   hint: 'Enter Hospital Name',
//                   icon: Icons.local_hospital_outlined,
//                 ),
//               ),
//               SizedBox(width: 16),
//               Expanded(
//                 child: _FieldBlock(
//                   label: 'Location',
//                   hint: 'Select Location',
//                   icon: Icons.location_on,
//                 ),
//               ),
//             ],
//           ),
//           SizedBox(height: 14),
//           Row(
//             children: [
//               Expanded(
//                 child: _FieldBlock(
//                   label: 'Contact Number',
//                   hint: 'Enter Contact Number',
//                   icon: Icons.phone,
//                 ),
//               ),
//               SizedBox(width: 16),
//               Expanded(
//                 child: _FieldBlock(
//                   label: 'Urgency',
//                   hint: 'Select urgency',
//                   icon: Icons.warning_amber_rounded,
//                   trailingIcon: Icons.keyboard_arrow_down,
//                 ),
//               ),
//             ],
//           ),
//           SizedBox(height: 14),
//           SizedBox(
//             width: 280,
//             child: _FieldBlock(
//               label: 'Message (Optional)',
//               hint: 'Enter additional message........',
//               icon: Icons.chat_bubble_outline,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _FieldBlock extends StatelessWidget {
//   const _FieldBlock({
//     required this.label,
//     required this.hint,
//     required this.icon,
//     this.trailingIcon,
//     this.iconColor,
//   });

//   final String label;
//   final String hint;
//   final IconData icon;
//   final IconData? trailingIcon;
//   final Color? iconColor;

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           label,
//           style: const TextStyle(
//             fontSize: 12,
//             fontWeight: FontWeight.w500,
//             color: Colors.black,
//           ),
//         ),
//         const SizedBox(height: 8),
//         Container(
//           height: 46,
//           padding: const EdgeInsets.symmetric(horizontal: 14),
//           decoration: BoxDecoration(
//             color: Colors.white.withValues(alpha: 0.45),
//             borderRadius: BorderRadius.circular(14),
//             border: Border.all(color: const Color(0xFFACA7A7), width: 1.2),
//           ),
//           child: Row(
//             children: [
//               Icon(icon, size: 18, color: iconColor ?? const Color(0xFF4E4E4E)),
//               const SizedBox(width: 8),
//               Expanded(
//                 child: Text(
//                   hint,
//                   maxLines: 1,
//                   overflow: TextOverflow.ellipsis,
//                   style: const TextStyle(
//                     fontSize: 12,
//                     color: Color(0xFF6F6F6F),
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//               ),
//               if (trailingIcon != null)
//                 Icon(trailingIcon, color: const Color(0xFF1E1E1E), size: 20),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }

// class _NearbyDonorsCard extends StatelessWidget {
//   const _NearbyDonorsCard();

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
//       decoration: BoxDecoration(
//         color: const Color(0xFFF9F3F3),
//         borderRadius: BorderRadius.circular(24),
//         boxShadow: const [
//           BoxShadow(
//             color: Color(0x29000000),
//             blurRadius: 12,
//             offset: Offset(0, 5),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: const [
//           Row(
//             children: [
//               Icon(Icons.opacity, color: Color(0xFFE2121B), size: 24),
//               SizedBox(width: 8),
//               Expanded(
//                 child: Text(
//                   'Nearby Donors',
//                   style: TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.w700,
//                     color: Color(0xFF231A77),
//                   ),
//                 ),
//               ),
//               Text(
//                 'View All',
//                 style: TextStyle(
//                   fontSize: 13,
//                   fontWeight: FontWeight.w500,
//                   color: Color(0xFF5B59FF),
//                 ),
//               ),
//             ],
//           ),
//           SizedBox(height: 18),
//           _DonorTile(
//             name: 'Sushant Shrestha',
//             bloodGroup: 'O+',
//             location: 'Kathmandu, Nepal',
//             availability: 'Available Now',
//             avatarAsset: 'assets/images/ambulance_avatar_1.png',
//           ),
//           SizedBox(height: 16),
//           _DonorTile(
//             name: 'Anjali karku',
//             bloodGroup: 'A+',
//             location: 'Lalitpur, Nepal',
//             availability: 'Available Now',
//             avatarAsset: 'assets/images/ambulance_avatar_2.png',
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _DonorTile extends StatelessWidget {
//   const _DonorTile({
//     required this.name,
//     required this.bloodGroup,
//     required this.location,
//     required this.availability,
//     required this.avatarAsset,
//   });

//   final String name;
//   final String bloodGroup;
//   final String location;
//   final String availability;
//   final String avatarAsset;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
//       decoration: BoxDecoration(
//         color: Colors.white.withValues(alpha: 0.76),
//         borderRadius: BorderRadius.circular(18),
//         border: Border.all(color: const Color(0xFFB5A9E1), width: 1.3),
//       ),
//       child: Row(
//         children: [
//           CircleAvatar(radius: 30, backgroundImage: AssetImage(avatarAsset)),
//           const SizedBox(width: 14),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   children: [
//                     Flexible(
//                       child: Text(
//                         name,
//                         overflow: TextOverflow.ellipsis,
//                         style: const TextStyle(
//                           fontSize: 14,
//                           fontWeight: FontWeight.w700,
//                           color: Colors.black,
//                         ),
//                       ),
//                     ),
//                     const SizedBox(width: 8),
//                     Container(
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 10,
//                         vertical: 3,
//                       ),
//                       decoration: BoxDecoration(
//                         color: const Color(0xFFF9C4C9),
//                         borderRadius: BorderRadius.circular(18),
//                       ),
//                       child: Text(
//                         bloodGroup,
//                         style: const TextStyle(
//                           fontSize: 12,
//                           fontWeight: FontWeight.w700,
//                           color: Color(0xFFF33434),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 8),
//                 Row(
//                   children: [
//                     const Icon(
//                       Icons.location_on,
//                       color: Color(0xFF21345A),
//                       size: 16,
//                     ),
//                     const SizedBox(width: 4),
//                     Expanded(
//                       child: Text(
//                         location,
//                         overflow: TextOverflow.ellipsis,
//                         style: const TextStyle(
//                           fontSize: 12,
//                           fontWeight: FontWeight.w500,
//                           color: Color(0xFF616161),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(width: 10),
//           Column(
//             children: [
//               Container(
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 10,
//                   vertical: 7,
//                 ),
//                 decoration: BoxDecoration(
//                   color: const Color(0xFFE5F9E8),
//                   borderRadius: BorderRadius.circular(18),
//                 ),
//                 child: Row(
//                   children: [
//                     Container(
//                       width: 9,
//                       height: 9,
//                       decoration: const BoxDecoration(
//                         color: Color(0xFF0CB451),
//                         shape: BoxShape.circle,
//                       ),
//                     ),
//                     const SizedBox(width: 6),
//                     Text(
//                       availability,
//                       style: const TextStyle(
//                         fontSize: 11,
//                         fontWeight: FontWeight.w700,
//                         color: Color(0xFF0BAA4A),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(width: 10),
//           Container(
//             width: 40,
//             height: 40,
//             decoration: const BoxDecoration(
//               color: Color(0xFFFF1021),
//               shape: BoxShape.circle,
//             ),
//             child: const Icon(Icons.call, color: Colors.white, size: 20),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:swasthasathi/app/features/auth/domain/entities/auth_user.dart';
import 'package:swasthasathi/app/features/dashboard/presentation/pages/notification_screen.dart';
import 'package:swasthasathi/app/features/dashboard/presentation/widgets/dashboard_bottom_nav.dart';

/// Everything for this page — header, hero banner, form, donor list, and
/// the submit button — now lives inside a single StatelessWidget's build
/// method. No separate widget classes; helper methods are used instead
/// where repetition would otherwise cause duplication (form fields, donor
/// tiles).
class BloodRequestScreen extends StatelessWidget {
  const BloodRequestScreen({super.key, this.user});

  final AuthUser? user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFDCEAF5),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 120),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ---------- Header ----------
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Blood Request',
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF152984),
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Find and request blood donors quickly',
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
              ),
              const SizedBox(height: 18),

              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x22000000),
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: Image.asset(
                    'assets/images/blood_request_banner.png',
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 18),

              // ---------- Blood Request Form ----------
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(18, 18, 18, 20),
                decoration: BoxDecoration(
                  color: const Color(0xFFF9F3F3),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x29000000),
                      blurRadius: 12,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(
                          Icons.note_alt_outlined,
                          color: Color(0xFFFF403B),
                          size: 26,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Blood Request Form',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF171717),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    Row(
                      children: [
                        Expanded(
                          child: _buildField(
                            label: 'Patient Name',
                            hint: 'Enter Patient Name',
                            icon: Icons.person_outline,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildField(
                            label: 'Blood Group',
                            hint: 'Enter Patient Name',
                            icon: Icons.opacity,
                            trailingIcon: Icons.keyboard_arrow_down,
                            iconColor: const Color(0xFFE51620),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Expanded(
                          child: _buildField(
                            label: 'Hospital Name',
                            hint: 'Enter Hospital Name',
                            icon: Icons.local_hospital_outlined,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildField(
                            label: 'Location',
                            hint: 'Select Location',
                            icon: Icons.location_on,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Expanded(
                          child: _buildField(
                            label: 'Contact Number',
                            hint: 'Enter Contact Number',
                            icon: Icons.phone,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildField(
                            label: 'Urgency',
                            hint: 'Select urgency',
                            icon: Icons.warning_amber_rounded,
                            trailingIcon: Icons.keyboard_arrow_down,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    SizedBox(
                      width: 280,
                      child: _buildField(
                        label: 'Message (Optional)',
                        hint: 'Enter additional message........',
                        icon: Icons.chat_bubble_outline,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              // ---------- Nearby Donors ----------
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
                decoration: BoxDecoration(
                  color: const Color(0xFFF9F3F3),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x29000000),
                      blurRadius: 12,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.opacity, color: Color(0xFFE2121B), size: 24),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Nearby Donors',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF231A77),
                            ),
                          ),
                        ),
                        Text(
                          'View All',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF5B59FF),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    _buildDonorTile(
                      name: 'Sushant Shrestha',
                      bloodGroup: 'O+',
                      location: 'Kathmandu, Nepal',
                      availability: 'Available Now',
                      avatarAsset: 'assets/images/ambulance_avatar_1.png',
                    ),
                    const SizedBox(height: 16),
                    _buildDonorTile(
                      name: 'Anjali karku',
                      bloodGroup: 'A+',
                      location: 'Lalitpur, Nepal',
                      availability: 'Available Now',
                      avatarAsset: 'assets/images/ambulance_avatar_2.png',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              // ---------- Send Blood Request button ----------
              Center(
                child: Container(
                  width: 290,
                  height: 78,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF1026),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x26000000),
                        blurRadius: 12,
                        offset: Offset(0, 6),
                      ),
                    ],
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 22,
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.opacity,
                          color: Color(0xFFE70D22),
                          size: 28,
                        ),
                      ),
                      SizedBox(width: 12),
                      Text(
                        'Send Blood Request',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
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

  /// Replaces the old `_FieldBlock` widget class — same visual output,
  /// now just a helper method on this single class.
  Widget _buildField({
    required String label,
    required String hint,
    required IconData icon,
    IconData? trailingIcon,
    Color? iconColor,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: 46,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.45),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFACA7A7), width: 1.2),
          ),
          child: Row(
            children: [
              Icon(icon, size: 18, color: iconColor ?? const Color(0xFF4E4E4E)),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  hint,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF6F6F6F),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              if (trailingIcon != null)
                Icon(trailingIcon, color: const Color(0xFF1E1E1E), size: 20),
            ],
          ),
        ),
      ],
    );
  }

  /// Replaces the old `_DonorTile` widget class — same visual output,
  /// now just a helper method on this single class.
  Widget _buildDonorTile({
    required String name,
    required String bloodGroup,
    required String location,
    required String availability,
    required String avatarAsset,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.76),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFB5A9E1), width: 1.3),
      ),
      child: Row(
        children: [
          CircleAvatar(radius: 30, backgroundImage: AssetImage(avatarAsset)),
          const SizedBox(width: 14),
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
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF9C4C9),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Text(
                        bloodGroup,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFFF33434),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(
                      Icons.location_on,
                      color: Color(0xFF21345A),
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        location,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF616161),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFE5F9E8),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 9,
                      height: 9,
                      decoration: const BoxDecoration(
                        color: Color(0xFF0CB451),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      availability,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF0BAA4A),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(width: 10),
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: Color(0xFFFF1021),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.call, color: Colors.white, size: 20),
          ),
        ],
      ),
    );
  }
}
