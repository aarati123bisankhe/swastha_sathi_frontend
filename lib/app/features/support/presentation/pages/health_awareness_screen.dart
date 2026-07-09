import 'package:flutter/material.dart';
import 'package:swasthasathi/app/features/auth/domain/entities/auth_user.dart';
import 'package:swasthasathi/app/features/dashboard/presentation/pages/notification_screen.dart';
import 'package:swasthasathi/app/features/dashboard/presentation/widgets/dashboard_bottom_nav.dart';

class HealthAwarenessScreen extends StatefulWidget {
  const HealthAwarenessScreen({super.key, this.user});

  final AuthUser? user;

  @override
  State<HealthAwarenessScreen> createState() => _HealthAwarenessScreenState();
}

class _HealthAwarenessScreenState extends State<HealthAwarenessScreen> {
  String _selectedCategory = 'Pregnancy Care';

  static const List<String> _categories = [
    'All',
    'Pregnancy Care',
    'Menstruation',
    'Vaccination',
  ];

  static const List<AwarenessVideo> _videos = [
    AwarenessVideo(
      category: 'Pregnancy Care',
      title: 'Pregnancy Care Tips',
      description:
          'Learn important pregnancy care tips and how to stay healthy during pregnancy.',
      thumbnailAssetPath: 'assets/images/awareness_pregnancy.png',
      educatorName: 'Doctor / Healthcare Educator',
      educatorSubtitle: 'Doctor',
      educatorImageAssetPath: 'assets/images/doctor_aanaya_new.png',
      thumbnailDuration: '00:30',
      videoDuration: '00:8m',
    ),
    AwarenessVideo(
      category: 'Menstruation',
      title: 'Menstruation Hygiene Tips',
      description:
          'Learn about period hygiene, pain relief, and healthy menstrual care.',
      thumbnailAssetPath: 'assets/images/awareness_menstruation.png',
      educatorName: 'Doctor / Healthcare Educator',
      educatorSubtitle: 'Doctor',
      educatorImageAssetPath: 'assets/images/doctor_aryan_new.png',
      thumbnailDuration: '00:42',
      videoDuration: '00:7m',
    ),
    AwarenessVideo(
      category: 'Vaccination',
      title: 'Vaccination Awareness',
      description:
          'Learn why vaccination is important and how it protects children and adults from diseases.',
      thumbnailAssetPath: 'assets/images/awareness_vaccination.png',
      educatorName: 'Doctor / Healthcare Educator',
      educatorSubtitle: 'Doctor',
      educatorImageAssetPath: 'assets/images/doctor_pradip_new.png',
      thumbnailDuration: '00:36',
      videoDuration: '00:6m',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final visibleVideos = _selectedCategory == 'All'
        ? _videos
        : _videos
              .where((video) => video.category == _selectedCategory)
              .toList();

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: ValueListenableBuilder<Set<String>>(
          valueListenable: AwarenessSavedStore.savedTitles,
          builder: (context, savedTitles, _) {
            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 18, 16, 120),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _AwarenessHeader(
                    user: widget.user,
                    onOpenSaved: _openSavedVideos,
                  ),
                  const SizedBox(height: 24),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: _categories
                        .map(
                          (category) => _CategoryChip(
                            label: category,
                            selected: _selectedCategory == category,
                            onTap: () {
                              setState(() {
                                _selectedCategory = category;
                              });
                            },
                          ),
                        )
                        .toList(),
                  ),
                  const SizedBox(height: 28),
                  ...visibleVideos.map(
                    (video) => Padding(
                      padding: const EdgeInsets.only(bottom: 18),
                      child: _AwarenessVideoCard(
                        video: video,
                        savedOffline: savedTitles.contains(video.title),
                        onSaveOffline: () => _saveOffline(video),
                        onWatchNow: () => _watchNow(video),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: DashboardBottomNav(
        activeTab: DashboardNavTab.support,
        user: widget.user,
      ),
    );
  }

  void _saveOffline(AwarenessVideo video) {
    final updated = Set<String>.from(AwarenessSavedStore.savedTitles.value)
      ..add(video.title);
    AwarenessSavedStore.savedTitles.value = updated;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text('${video.title} saved for offline viewing'),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  void _watchNow(AwarenessVideo video) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => HealthAwarenessPlayerScreen(video: video),
      ),
    );
  }

  void _openSavedVideos() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => SavedAwarenessVideosScreen(
          user: widget.user,
          allVideos: _videos,
          onWatchNow: _watchNow,
        ),
      ),
    );
  }
}

class _AwarenessHeader extends StatelessWidget {
  const _AwarenessHeader({this.user, required this.onOpenSaved});

  final AuthUser? user;
  final VoidCallback onOpenSaved;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Transform.translate(
            offset: const Offset(-8, 0),
            child: const Padding(
              padding: EdgeInsets.only(top: 9, right: 8),
              child: Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Color(0xFF7C828C),
                size: 19,
              ),
            ),
          ),
        ),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Health Awareness',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF251E7E),
                ),
              ),
              SizedBox(height: 1),
              Text(
                'Learn healthcare tips and stay informed',
                style: TextStyle(fontSize: 13, color: Color(0xFF555D69)),
              ),
            ],
          ),
        ),
        const SizedBox(width: 10),
        GestureDetector(
          onTap: onOpenSaved,
          child: const Padding(
            padding: EdgeInsets.only(top: 2),
            child: Icon(
              Icons.bookmark_outline_rounded,
              color: Color(0xFF193767),
              size: 29,
            ),
          ),
        ),
        const SizedBox(width: 12),
        GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (context) => NotificationScreen(user: user),
              ),
            );
          },
          child: const Padding(
            padding: EdgeInsets.only(top: 2),
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

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFF108CA3) : Colors.transparent,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: selected ? const Color(0xFF108CA3) : const Color(0xFF3A4A5C),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: selected ? Colors.white : const Color(0xFF34414E),
          ),
        ),
      ),
    );
  }
}

class _AwarenessVideoCard extends StatelessWidget {
  const _AwarenessVideoCard({
    required this.video,
    required this.savedOffline,
    required this.onSaveOffline,
    required this.onWatchNow,
  });

  final AwarenessVideo video;
  final bool savedOffline;
  final VoidCallback onSaveOffline;
  final VoidCallback onWatchNow;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: SizedBox(
                  width: double.infinity,
                  height: 145,
                  child: Image.asset(
                    video.thumbnailAssetPath,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned.fill(
                child: Center(
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: const Color(0x99000000),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2.5),
                    ),
                    child: const Icon(
                      Icons.play_arrow_rounded,
                      color: Colors.white,
                      size: 34,
                    ),
                  ),
                ),
              ),
              Positioned(
                right: 10,
                bottom: 10,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 9,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xAA314444),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    video.thumbnailDuration,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            video.title,
            style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.w800,
              color: Color(0xFF161D24),
            ),
          ),
          const SizedBox(height: 3),
          Text(
            video.description,
            style: TextStyle(
              fontSize: 13,
              height: 1.3,
              color: Color(0xFF414A54),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              ClipOval(
                child: SizedBox(
                  width: 42,
                  height: 42,
                  child: Image.asset(
                    video.educatorImageAssetPath,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      video.educatorName,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF20262D),
                      ),
                    ),
                    SizedBox(height: 1),
                    Text(
                      video.educatorSubtitle,
                      style: TextStyle(fontSize: 13, color: Color(0xFF545D68)),
                    ),
                  ],
                ),
              ),
              Text(
                video.videoDuration,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF28313B),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onSaveOffline,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF108CA3),
                    side: const BorderSide(
                      color: Color(0xFF108CA3),
                      width: 1.5,
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                  ),
                  icon: Icon(
                    savedOffline
                        ? Icons.bookmark_rounded
                        : Icons.bookmark_border_rounded,
                    size: 23,
                  ),
                  label: Text(
                    savedOffline ? 'Saved Offline' : 'Save Offline',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton(
                  onPressed: onWatchNow,
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF0C8599),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                  ),
                  child: const Text(
                    'Watch Now',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class SavedAwarenessVideosScreen extends StatelessWidget {
  const SavedAwarenessVideosScreen({
    super.key,
    required this.user,
    required this.allVideos,
    required this.onWatchNow,
  });

  final AuthUser? user;
  final List<AwarenessVideo> allVideos;
  final ValueChanged<AwarenessVideo> onWatchNow;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: ValueListenableBuilder<Set<String>>(
          valueListenable: AwarenessSavedStore.savedTitles,
          builder: (context, savedTitles, _) {
            final savedVideos = allVideos
                .where((video) => savedTitles.contains(video.title))
                .toList();

            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 18, 16, 120),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SavedVideosHeader(user: user),
                  const SizedBox(height: 22),
                  if (savedVideos.isEmpty)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(22),
                      ),
                      child: const Column(
                        children: [
                          Icon(
                            Icons.bookmark_border_rounded,
                            color: Color(0xFF0C8599),
                            size: 42,
                          ),
                          SizedBox(height: 12),
                          Text(
                            'No saved videos yet',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF1E2A35),
                            ),
                          ),
                          SizedBox(height: 6),
                          Text(
                            'Videos you save for offline viewing will appear here.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 13,
                              color: Color(0xFF5A6673),
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    ...savedVideos.map(
                      (video) => Padding(
                        padding: const EdgeInsets.only(bottom: 18),
                        child: _AwarenessVideoCard(
                          video: video,
                          savedOffline: true,
                          onSaveOffline: () {},
                          onWatchNow: () => onWatchNow(video),
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: DashboardBottomNav(
        activeTab: DashboardNavTab.support,
        user: user,
      ),
    );
  }
}

class _SavedVideosHeader extends StatelessWidget {
  const _SavedVideosHeader({this.user});

  final AuthUser? user;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Transform.translate(
            offset: const Offset(-8, 0),
            child: const Padding(
              padding: EdgeInsets.only(top: 9, right: 8),
              child: Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Color(0xFF7C828C),
                size: 19,
              ),
            ),
          ),
        ),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Saved Videos',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF251E7E),
                ),
              ),
              SizedBox(height: 1),
              Text(
                'Videos saved for offline viewing',
                style: TextStyle(fontSize: 13, color: Color(0xFF555D69)),
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
            padding: EdgeInsets.only(top: 2),
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

class HealthAwarenessPlayerScreen extends StatelessWidget {
  const HealthAwarenessPlayerScreen({super.key, required this.video});

  final AwarenessVideo video;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F1F2C),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Now Playing',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: Image.asset(
                            video.thumbnailAssetPath,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned.fill(
                          child: Container(color: const Color(0x33000000)),
                        ),
                        const Positioned.fill(
                          child: Center(
                            child: Icon(
                              Icons.pause_circle_filled_rounded,
                              color: Colors.white,
                              size: 84,
                            ),
                          ),
                        ),
                        Positioned(
                          left: 18,
                          right: 18,
                          bottom: 18,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                video.title,
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 12),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(99),
                                child: LinearProgressIndicator(
                                  value: 0.35,
                                  minHeight: 6,
                                  backgroundColor: const Color(0x66FFFFFF),
                                  valueColor:
                                      const AlwaysStoppedAnimation<Color>(
                                        Color(0xFF10B3B0),
                                      ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    video.thumbnailDuration,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 13,
                                    ),
                                  ),
                                  Text(
                                    video.videoDuration.replaceFirst(
                                      '00:',
                                      '0',
                                    ),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AwarenessVideo {
  const AwarenessVideo({
    required this.category,
    required this.title,
    required this.description,
    required this.thumbnailAssetPath,
    required this.educatorName,
    required this.educatorSubtitle,
    required this.educatorImageAssetPath,
    required this.thumbnailDuration,
    required this.videoDuration,
  });

  final String category;
  final String title;
  final String description;
  final String thumbnailAssetPath;
  final String educatorName;
  final String educatorSubtitle;
  final String educatorImageAssetPath;
  final String thumbnailDuration;
  final String videoDuration;
}

class AwarenessSavedStore {
  static final ValueNotifier<Set<String>> savedTitles =
      ValueNotifier<Set<String>>(<String>{});
}
