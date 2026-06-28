import 'package:swasthasathi/app/features/onboarding/domain/entities/onboarding_page_content.dart';

class LocalOnboardingDataSource {
  const LocalOnboardingDataSource();

  OnboardingPageContent getPageContent(int pageIndex) {
    switch (pageIndex) {
      case 1:
        return const OnboardingPageContent(
          imageAssetPath: 'assets/images/onboarding_splash_2.png',
          buttonLabel: 'Next',
          pageIndex: 1,
        );
      case 0:
      default:
        return const OnboardingPageContent(
          imageAssetPath: 'assets/images/onboarding_splash_1.png',
          buttonLabel: 'Get Started',
          pageIndex: 0,
        );
    }
  }
}
