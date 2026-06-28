class SplashConfig {
  const SplashConfig({
    required this.logoAssetPath,
    required this.showDelayMs,
    required this.holdDurationMs,
  });

  final String logoAssetPath;
  final int showDelayMs;
  final int holdDurationMs;
}
