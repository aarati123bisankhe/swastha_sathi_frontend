import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swasthasathi/app/core/services/emergency_location_service.dart';
import 'package:swasthasathi/app/core/services/emergency_notification_service.dart';
import 'package:swasthasathi/app/core/services/live_location_sharing_service.dart';
import 'package:swasthasathi/app/features/auth/domain/entities/auth_user.dart';
import 'package:swasthasathi/app/features/dashboard/presentation/pages/notification_screen.dart';
import 'package:swasthasathi/app/features/dashboard/presentation/widgets/dashboard_bottom_nav.dart';
import 'package:swasthasathi/app/features/emergency/presentation/pages/call_ambulance_screen.dart';
import 'package:swasthasathi/app/features/support/presentation/pages/hospital_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class ShareLocationScreen extends StatefulWidget {
  const ShareLocationScreen({super.key, this.user});

  final AuthUser? user;

  @override
  State<ShareLocationScreen> createState() => _ShareLocationScreenState();
}

class _ShareLocationScreenState extends State<ShareLocationScreen> {
  final LiveLocationSharingService _sharingService =
      LiveLocationSharingService.instance;

  EmergencyLocationData? _currentLocation;
  LiveLocationSession? _session;
  bool _isSharing = false;
  bool _isLoadingLocation = true;
  bool _isWorking = false;
  bool _permissionDenied = false;

  @override
  void initState() {
    super.initState();
    _session = _sharingService.activeSession;
    _isSharing = _sharingService.isSharing;
    _loadCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    final locationLine = _permissionDenied
        ? 'Location permission is required to share your location.'
        : _currentLocation?.cityProvinceLabel ??
              '${_fallbackDistrict()}, Bagmati Province';
    final accuracyLine = _permissionDenied ? '' : 'Accuracy: High';

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
              _LocationStatusCard(
                locationLine: locationLine,
                accuracyLine: accuracyLine,
                isSharing: _isSharing,
                isPermissionDenied: _permissionDenied,
                isLoading: _isLoadingLocation,
              ),
              const SizedBox(height: 18),
              _MapPreviewCard(
                district: _currentLocation?.city ?? _fallbackDistrict(),
                subtitle: _permissionDenied
                    ? 'Location permission is required'
                    : _currentLocation?.addressLabel ??
                          '${_fallbackDistrict()}, Nepal',
                onTap: _isWorking ? null : _openMapPreview,
              ),
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
              Row(
                children: [
                  Expanded(
                    child: _ShareOptionCard(
                      icon: Icons.people,
                      iconColor: const Color(0xFF19B95A),
                      label: 'Emergency\nContacts',
                      onTap: _isWorking ? null : _shareWithEmergencyContacts,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _ShareOptionCard(
                      icon: Icons.emergency,
                      iconColor: const Color(0xFFFF2231),
                      label: 'Call\nAmbulance',
                      onTap: _isWorking ? null : _openAmbulanceSupport,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _ShareOptionCard(
                      icon: Icons.local_hospital,
                      iconColor: const Color(0xFF2581F4),
                      label: 'Nearby\nHospitals',
                      onTap: _openNearbyHospitals,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _ShareOptionCard(
                      icon: Icons.chat,
                      iconColor: const Color(0xFF18C45E),
                      label: 'Send via\nWhatsApp',
                      onTap: _isWorking ? null : _shareViaWhatsApp,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _ShareOptionCard(
                      icon: Icons.more_horiz,
                      iconColor: const Color(0xFF9EA8D4),
                      label: 'More\nOptions',
                      onTap: _isWorking ? null : _shareWithMoreOptions,
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
                    onPressed: _isWorking ? null : _startSharing,
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
                    onPressed: _isWorking ? null : _stopSharing,
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

  Future<void> _loadCurrentLocation() async {
    if (mounted) {
      setState(() {
        _isLoadingLocation = true;
      });
    }

    final location = await EmergencyLocationService.getCurrentLocation(
      fallbackDistrict: widget.user?.district,
    );

    if (!mounted) {
      return;
    }

    setState(() {
      _currentLocation = location;
      _permissionDenied = location == null;
      _isLoadingLocation = false;
    });

    if (location == null) {
      _showFeedback('Location permission is required to share your location.');
    }
  }

  Future<void> _startSharing() async {
    await _runBusyAction(() async {
      final session = await _ensureActiveSession();
      if (session == null) {
        return;
      }

      await EmergencyNotificationService.addLiveLocationSharedNotification();
      _showFeedback('Live location shared successfully.');
    });
  }

  Future<void> _stopSharing() async {
    if (!_isSharing || _session == null) {
      _showFeedback('Location sharing stopped.');
      return;
    }

    await _runBusyAction(() async {
      await _sharingService.stopSharing();

      if (!mounted) {
        return;
      }

      setState(() {
        _isSharing = false;
        _session = null;
      });

      await EmergencyNotificationService.addLocationSharingStoppedNotification();
      _showFeedback('Location sharing stopped.');
    });
  }

  Future<void> _shareWithEmergencyContacts() async {
    await _runBusyAction(() async {
      final contacts = await _loadSavedEmergencyContacts();

      if (contacts.isEmpty) {
        _showFeedback(
          'No emergency contact found. Please add an emergency contact first.',
        );
        return;
      }

      final session = await _ensureActiveSession();
      if (session == null) {
        return;
      }

      final message = _trackingMessage(session.trackingLink);

      await _sharingService.sendShareContact(
        userId: widget.user?.id ?? 'guest',
        shareId: session.shareId,
        trackingLink: session.trackingLink,
        message: message,
      );

      final smsUri = Uri(
        scheme: 'sms',
        path: contacts.join(','),
        queryParameters: {'body': message},
      );

      final launched = await launchUrl(
        smsUri,
        mode: LaunchMode.externalApplication,
      );

      if (!launched) {
        _showFeedback('Unable to open the messaging app right now.');
        return;
      }

      await EmergencyNotificationService.addEmergencyContactsNotifiedNotification();
      _showFeedback('Emergency contacts notified successfully.');
    });
  }

  Future<void> _openAmbulanceSupport() async {
    await _runBusyAction(() async {
      final session = await _ensureActiveSession();
      if (session == null) {
        return;
      }

      await Share.share(
        _trackingMessage(session.trackingLink),
        subject: 'Emergency Ambulance Support',
      );

      if (!mounted) {
        return;
      }

      await Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (context) => CallAmbulanceScreen(user: widget.user),
        ),
      );
    });
  }

  Future<void> _openNearbyHospitals() async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => HospitalScreen(user: widget.user),
      ),
    );
  }

  Future<void> _openMapPreview() async {
    await _runBusyAction(() async {
      var location = _currentLocation;
      location ??= await EmergencyLocationService.getCurrentLocation(
        fallbackDistrict: widget.user?.district,
      );

      if (location == null) {
        if (mounted) {
          setState(() {
            _permissionDenied = true;
            _isLoadingLocation = false;
          });
        }
        final launched = await _launchFallbackMap();
        if (!launched) {
          _showFeedback('Unable to open the map right now.');
        }
        return;
      }

      if (mounted) {
        setState(() {
          _currentLocation = location;
          _permissionDenied = false;
        });
      }

      final launched = await _launchMap(location);
      if (!launched) {
        _showFeedback('Unable to open the map right now.');
      }
    });
  }

  Future<bool> _launchFallbackMap() async {
    final district = _fallbackDistrict();
    final query = '$district, Nepal';
    final googleMapsUri = Uri.https('www.google.com', '/maps/search/', {
      'api': '1',
      'query': query,
    });

    try {
      if (await launchUrl(googleMapsUri, mode: LaunchMode.platformDefault)) {
        return true;
      }
    } catch (_) {}

    try {
      if (await launchUrl(
        googleMapsUri,
        mode: LaunchMode.externalApplication,
      )) {
        return true;
      }
    } catch (_) {}

    return false;
  }

  Future<bool> _launchMap(EmergencyLocationData location) async {
    final googleMapsUri = Uri.https('www.google.com', '/maps/search/', {
      'api': '1',
      'query': '${location.latitude},${location.longitude}',
    });

    try {
      if (await launchUrl(googleMapsUri, mode: LaunchMode.platformDefault)) {
        return true;
      }
    } catch (_) {}

    try {
      if (await launchUrl(
        googleMapsUri,
        mode: LaunchMode.externalApplication,
      )) {
        return true;
      }
    } catch (_) {}

    return false;
  }

  Future<void> _shareViaWhatsApp() async {
    await _runBusyAction(() async {
      final session = await _ensureActiveSession();
      if (session == null) {
        return;
      }

      final message = _trackingMessage(session.trackingLink);
      final whatsappUri = Uri.parse(
        'whatsapp://send?text=${Uri.encodeComponent(message)}',
      );

      final launched = await launchUrl(
        whatsappUri,
        mode: LaunchMode.externalApplication,
      );

      if (launched) {
        return;
      }

      final fallbackUri = Uri.parse(
        'https://wa.me/?text=${Uri.encodeComponent(message)}',
      );

      final fallbackLaunched = await launchUrl(
        fallbackUri,
        mode: LaunchMode.externalApplication,
      );

      if (!fallbackLaunched) {
        _showFeedback('Unable to open WhatsApp right now.');
      }
    });
  }

  Future<void> _shareWithMoreOptions() async {
    await _runBusyAction(() async {
      final session = await _ensureActiveSession();
      if (session == null) {
        return;
      }

      await Share.share(
        _trackingMessage(session.trackingLink),
        subject: 'Emergency Live Location',
      );
    });
  }

  Future<LiveLocationSession?> _ensureActiveSession() async {
    if (_session != null && _isSharing) {
      return _session;
    }

    var location = _currentLocation;
    location ??= await EmergencyLocationService.getCurrentLocation(
      fallbackDistrict: widget.user?.district,
    );

    if (location == null) {
      if (mounted) {
        setState(() {
          _permissionDenied = true;
          _isLoadingLocation = false;
        });
      }
      _showFeedback('Location permission is required to share your location.');
      return null;
    }

    final session = await _sharingService.startSharing(
      user: widget.user,
      location: location,
    );

    if (!mounted) {
      return session;
    }

    setState(() {
      _currentLocation = location;
      _permissionDenied = false;
      _session = session;
      _isSharing = true;
    });

    return session;
  }

  Future<void> _runBusyAction(Future<void> Function() action) async {
    if (_isWorking) {
      return;
    }

    if (mounted) {
      setState(() {
        _isWorking = true;
      });
    }

    try {
      await action();
    } on LiveLocationException catch (error) {
      _showFeedback(error.message);
    } catch (_) {
      _showFeedback('Unable to complete this action right now.');
    } finally {
      if (mounted) {
        setState(() {
          _isWorking = false;
        });
      }
    }
  }

  Future<List<String>> _loadSavedEmergencyContacts() async {
    const storageKey = 'health_record_data';

    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(storageKey);

    if (raw == null || raw.isEmpty) {
      return <String>[];
    }

    final json = jsonDecode(raw) as Map<String, dynamic>;
    final value = (json['emergencyContactNumber'] as String?)?.trim() ?? '';

    if (value.isEmpty) {
      return <String>[];
    }

    return value
        .split(RegExp(r'[,;\n]+'))
        .map((item) => item.trim())
        .where((item) => item.isNotEmpty)
        .toList();
  }

  String _fallbackDistrict() {
    return widget.user?.district.trim().isNotEmpty == true
        ? widget.user!.district.trim()
        : 'Kathmandu';
  }

  String _trackingMessage(String trackingLink) {
    return 'Emergency! I need help. Track my live location here: '
        '$trackingLink';
  }

  void _showFeedback(String message) {
    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
      );
  }
}

class _LocationStatusCard extends StatelessWidget {
  const _LocationStatusCard({
    required this.locationLine,
    required this.accuracyLine,
    required this.isSharing,
    required this.isPermissionDenied,
    required this.isLoading,
  });

  final String locationLine;
  final String accuracyLine;
  final bool isSharing;
  final bool isPermissionDenied;
  final bool isLoading;

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
                  isLoading ? 'Loading current location...' : locationLine,
                  style: const TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF293255),
                  ),
                ),
                const SizedBox(height: 2),
                if (accuracyLine.isNotEmpty)
                  Text(
                    accuracyLine,
                    style: const TextStyle(
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
                      isPermissionDenied
                          ? 'Blocked'
                          : (isSharing ? 'Live' : 'Ready'),
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
                    isPermissionDenied
                        ? 'GPS Off'
                        : (isSharing ? 'GPS Active' : 'GPS Ready'),
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
  const _MapPreviewCard({
    required this.district,
    required this.subtitle,
    required this.onTap,
  });

  final String district;
  final String subtitle;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: Container(
            height: 220,
            decoration: BoxDecoration(
              color: const Color(0xFFF6F4F3),
              border: Border.all(color: const Color(0xFFC8D2DD)),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Stack(
              children: [
                Positioned.fill(
                  child: CustomPaint(painter: _MapPatternPainter()),
                ),
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
                              district,
                              style: const TextStyle(
                                fontSize: 9.5,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF647089),
                              ),
                            ),
                            const SizedBox(height: 2),
                            SizedBox(
                              width: 150,
                              child: Text(
                                subtitle,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 8.5,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF647089),
                                ),
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
                  child: GestureDetector(
                    onTap: onTap,
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
                ),
              ],
            ),
          ),
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
    required this.onTap,
  });

  final IconData icon;
  final Color iconColor;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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

    final highlightPath = Path()
      ..moveTo(0, 118)
      ..quadraticBezierTo(70, 92, 124, 110)
      ..quadraticBezierTo(194, 134, 258, 112)
      ..quadraticBezierTo(314, 92, size.width, 124);
    canvas.drawPath(highlightPath, highlightRoad);

    final verticalHighlight = Path()
      ..moveTo(170, 0)
      ..quadraticBezierTo(146, 76, 158, 126)
      ..quadraticBezierTo(172, 176, 148, size.height);
    canvas.drawPath(verticalHighlight, highlightRoad);

    final riverPath = Path()
      ..moveTo(6, 166)
      ..quadraticBezierTo(54, 138, 94, 162)
      ..quadraticBezierTo(142, 188, 194, 162)
      ..quadraticBezierTo(242, 136, 296, 166)
      ..quadraticBezierTo(324, 182, size.width, 170);
    canvas.drawPath(riverPath, river);

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(18, 82, 56, 36),
        const Radius.circular(12),
      ),
      park,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(238, 20, 68, 44),
        const Radius.circular(12),
      ),
      park,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(228, 164, 58, 34),
        const Radius.circular(12),
      ),
      park,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
