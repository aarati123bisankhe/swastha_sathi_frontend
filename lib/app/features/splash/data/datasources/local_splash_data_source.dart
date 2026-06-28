import 'package:swasthasathi/app/features/splash/domain/entities/splash_config.dart';

class LocalSplashDataSource {
  const LocalSplashDataSource();

  SplashConfig getConfig() {
    return const SplashConfig(
      logoAssetPath: 'assets/images/logo.png',
      showDelayMs: 250,
      holdDurationMs: 2600,
    );
  }
}
