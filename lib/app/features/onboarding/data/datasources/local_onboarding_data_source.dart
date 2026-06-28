import 'package:swasthasathi/app/features/onboarding/domain/entities/onboarding_page_content.dart';

class LocalOnboardingDataSource {
  const LocalOnboardingDataSource();

  OnboardingPageContent getPageContent() {
    return const OnboardingPageContent(
      imageAssetPath: 'assets/images/onboarding_splash_1.png',
      buttonLabel: 'Get Started',
    );
  }
}
