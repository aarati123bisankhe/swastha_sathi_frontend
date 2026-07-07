import 'package:flutter/material.dart';
import 'package:swasthasathi/app/features/auth/domain/entities/auth_user.dart';
import 'package:swasthasathi/app/features/dashboard/presentation/pages/notification_screen.dart';
import 'package:swasthasathi/app/features/dashboard/presentation/widgets/dashboard_bottom_nav.dart';

class ShareLocationScreen extends StatefulWidget {
  const ShareLocationScreen({super.key, this.user});

  final AuthUser? user;

  @override
  State<ShareLocationScreen> createState() => _ShareLocationScreenState();
}

class _ShareLocationScreenState extends State<ShareLocationScreen> {
  bool _isSharing = false;

  @override
  Widget build(BuildContext context) {
    final district = widget.user?.district.trim().isNotEmpty == true
        ? widget.user!.district.trim()
        : 'Kathmandu';

    return Scaffold(
      backgroundColor: const Color(0xFFDCEAF5),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 120),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Transform.translate(
                      offset: const Offset(-8, 0),
                      child: const Padding(
                        padding: EdgeInsets.only(top: 8, right: 10),
                        child: Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: Color(0xFF193767),
                          size: 18,
                        ),
                      ),
                    ),
                  ),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Share Location',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF21146F),
                          ),
                        ),
                        SizedBox(height: 1),
                        Text(
                          'Share your real-time location for quick help',
                          style: TextStyle(
                            fontSize: 12,
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
                          builder: (context) =>
                              NotificationScreen(user: widget.user),
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
              _LocationStatusCard(district: district, isSharing: _isSharing),
              const SizedBox(height: 18),
              _MapPreviewCard(district: district),
              const SizedBox(height: 18),
              const Text(
                'Share with',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 12),
              const Row(
                children: [
                  Expanded(
                    child: _ShareOptionCard(
                      icon: Icons.people,
                      iconColor: Color(0xFF19B95A),
                      label: 'Emergency\nContacts',
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: _ShareOptionCard(
                      icon: Icons.emergency,
                      iconColor: Color(0xFFFF2231),
                      label: 'Call\nAmbulance',
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: _ShareOptionCard(
                      icon: Icons.local_hospital,
                      iconColor: Color(0xFF2581F4),
                      label: 'Nearby\nHospitals',
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: _ShareOptionCard(
                      icon: Icons.chat,
                      iconColor: Color(0xFF18C45E),
                      label: 'Send via\nWhatsApp',
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: _ShareOptionCard(
                      icon: Icons.more_horiz,
                      iconColor: Color(0xFF9EA8D4),
                      label: 'More\nOptions',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              const _SecureShareInfoCard(),
              const SizedBox(height: 15),
              Center(
                child: SizedBox(
                  width: 300,
                  child: FilledButton.icon(
                    onPressed: _startSharing,
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFF0EAF4C),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(22),
                      ),
                    ),
                    icon: const Icon(Icons.send_rounded, size: 18),
                    label: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Share Live Location',
                          style: TextStyle(
                            fontSize: 14.5,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 0),
                        Transform.translate(
                          offset: const Offset(0, -2),
                          child: const Text(
                            'Share my location in real-time',
                            style: TextStyle(
                              fontSize: 9.5,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFFF1FFF5),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 13),
              Center(
                child: SizedBox(
                  width: 300,
                  child: OutlinedButton.icon(
                    onPressed: _stopSharing,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFFFF1212),
                      side: const BorderSide(color: Color(0xFFFF2D2D)),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(22),
                      ),
                    ),
                    icon: const Icon(Icons.stop_rounded, size: 17),
                    label: const Text(
                      'Stop Sharing Location',
                      style: TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: DashboardBottomNav(
        activeTab: DashboardNavTab.emergency,
        user: widget.user,
      ),
    );
  }

  void _startSharing() {
    setState(() {
      _isSharing = true;
    });
    _showFeedback('Live location shared successfully.');
  }

  void _stopSharing() {
    setState(() {
      _isSharing = false;
    });
    _showFeedback('Location sharing stopped.');
  }

  void _showFeedback(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }
}

class _LocationStatusCard extends StatelessWidget {
  const _LocationStatusCard({required this.district, required this.isSharing});

  final String district;
  final bool isSharing;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [Color(0xFFF7FFFA), Color(0xFFF1FFF4)],
        ),
        border: Border.all(color: const Color(0xFFA7C4AD)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x16000000),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [Color(0xFF11D76C), Color(0xFF08A849)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: const Icon(
              Icons.location_on_rounded,
              color: Colors.white,
              size: 26,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Your Location',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF10BF5A),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '$district, Bagmati Province',
                  style: const TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF293255),
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  'Accuracy: High (10 m)',
                  style: TextStyle(
                    fontSize: 10,
                    color: Color(0xFF79849B),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFE6FBEA),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.circle,
                      color: Color(0xFF13C65B),
                      size: 10,
                    ),
                    const SizedBox(width: 7),
                    Text(
                      isSharing ? 'Live' : 'Ready',
                      style: const TextStyle(
                        color: Color(0xFF13B954),
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 6),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.gps_fixed_rounded,
                    color: Color(0xFF959DB2),
                    size: 16,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    isSharing ? 'GPS Active' : 'GPS Ready',
                    style: const TextStyle(
                      color: Color(0xFF14B95B),
                      fontSize: 10.5,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MapPreviewCard extends StatelessWidget {
  const _MapPreviewCard({required this.district});

  final String district;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: Container(
        height: 220,
        decoration: BoxDecoration(
          color: const Color(0xFFF6F4F3),
          border: Border.all(color: const Color(0xFFC8D2DD)),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Stack(
          children: [
            Positioned.fill(child: CustomPaint(painter: _MapPatternPainter())),
            const Positioned(
              top: 18,
              left: 34,
              child: _MapLabel(label: 'Thamel'),
            ),
            const Positioned(
              top: 28,
              right: 42,
              child: _MapPlaceMarker(
                label: 'Kathmandu\nDurbar Square',
                color: Color(0xFF9A61F2),
                icon: Icons.account_balance,
              ),
            ),
            const Positioned(
              top: 94,
              left: 22,
              child: _MapPlaceMarker(
                label: 'Garden of Dreams',
                color: Color(0xFF1FB864),
                icon: Icons.park,
              ),
            ),
            const Positioned(
              top: 106,
              right: 28,
              child: _MapLabel(label: 'Pashupatinath Temple'),
            ),
            const Positioned(
              bottom: 34,
              left: 56,
              child: _MapLabel(label: 'Lazimpat'),
            ),
            const Positioned(
              bottom: 6,
              left: 126,
              child: _MapLabel(label: 'Jawalakhel'),
            ),
            Positioned(
              left: 0,
              right: 0,
              top: 48,
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x14000000),
                          blurRadius: 12,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        const Text(
                          'You are here',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF293255),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '$district, Nepal',
                          style: const TextStyle(
                            fontSize: 9.5,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF647089),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                  const _LocationPulse(),
                ],
              ),
            ),
            Positioned(
              top: 10,
              left: 174,
              child: Container(
                width: 24,
                height: 24,
                decoration: const BoxDecoration(
                  color: Color(0xFFF56767),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.local_hospital,
                  color: Colors.white,
                  size: 14,
                ),
              ),
            ),
            Positioned(
              bottom: 10,
              right: 18,
              child: Container(
                width: 36,
                height: 36,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x14000000),
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.gps_fixed_rounded,
                  color: Color(0xFF5F6880),
                  size: 18,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ShareOptionCard extends StatelessWidget {
  const _ShareOptionCard({
    required this.icon,
    required this.iconColor,
    required this.label,
  });

  final IconData icon;
  final Color iconColor;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 96,
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFB2B2B2)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: iconColor, size: 28),
          const SizedBox(height: 7),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 9.5,
              height: 1.3,
              fontWeight: FontWeight.w700,
              color: Color(0xFF263143),
            ),
          ),
        ],
      ),
    );
  }
}

class _SecureShareInfoCard extends StatelessWidget {
  const _SecureShareInfoCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          colors: [Color(0xFFF6FBFF), Color(0xFFE9F5FF)],
        ),
        border: Border.all(color: const Color(0xFF8FC1E7)),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: const BoxDecoration(
              color: Color(0xFFE7F2FF),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.shield_rounded,
              color: Color(0xFF2086F3),
              size: 20,
            ),
          ),
          const SizedBox(width: 8),
          const Expanded(
            child: Text(
              'Your location will be shared securely and will help responders reach you faster.',
              style: TextStyle(
                fontSize: 9.5,
                height: 1.2,
                fontWeight: FontWeight.w700,
                color: Color(0xFF4D5E79),
              ),
            ),
          ),
          const SizedBox(width: 6),
          const Icon(Icons.location_on, color: Color(0xFFFF2B48), size: 24),
        ],
      ),
    );
  }
}

class _LocationPulse extends StatelessWidget {
  const _LocationPulse();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 132,
      height: 132,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 118,
            height: 118,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0x332F8FFF),
            ),
          ),
          Container(
            width: 86,
            height: 86,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0x334291FF),
            ),
          ),
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF2086F3),
              border: Border.all(color: Colors.white, width: 4),
            ),
          ),
        ],
      ),
    );
  }
}

class _MapPlaceMarker extends StatelessWidget {
  const _MapPlaceMarker({
    required this.label,
    required this.color,
    required this.icon,
  });

  final String label;
  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          child: Icon(icon, color: Colors.white, size: 14),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 10.5,
            height: 1.2,
            color: color,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _MapLabel extends StatelessWidget {
  const _MapLabel({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 10.5,
        color: Color(0xFF556279),
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

class _MapPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final base = Paint()..color = const Color(0xFFF5F5F5);
    canvas.drawRect(Offset.zero & size, base);

    final road = Paint()
      ..color = const Color(0xFFE0E3E7)
      ..strokeWidth = 2.2
      ..style = PaintingStyle.stroke;

    final highlightRoad = Paint()
      ..color = const Color(0xFFF4C26B)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final river = Paint()
      ..color = const Color(0xFF9BD5FF)
      ..strokeWidth = 3.2
      ..style = PaintingStyle.stroke;

    final park = Paint()..color = const Color(0xFFD8F3DF);

    final gridY = [36.0, 68.0, 102.0, 146.0, 198.0, 240.0, 286.0, 324.0];
    for (final y in gridY) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y + 8), road);
    }

    final gridX = [42.0, 86.0, 132.0, 176.0, 220.0, 266.0, 308.0];
    for (final x in gridX) {
      canvas.drawLine(Offset(x, 0), Offset(x - 12, size.height), road);
    }

    canvas.drawRect(const Rect.fromLTWH(124, 12, 62, 36), park);
    canvas.drawRect(const Rect.fromLTWH(18, 132, 72, 38), park);
    canvas.drawRect(const Rect.fromLTWH(244, 106, 54, 42), park);

    final mainRoad = Path()
      ..moveTo(size.width * .66, size.height)
      ..quadraticBezierTo(
        size.width * .72,
        size.height * .78,
        size.width * .92,
        size.height * .68,
      );
    canvas.drawPath(mainRoad, highlightRoad);

    final riverPath = Path()
      ..moveTo(size.width * .73, 0)
      ..cubicTo(
        size.width * .8,
        size.height * .14,
        size.width * .7,
        size.height * .42,
        size.width * .92,
        size.height,
      );
    canvas.drawPath(riverPath, river);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
