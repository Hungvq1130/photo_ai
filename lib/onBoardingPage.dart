import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:photo_ai/gradientBackground.dart';

import 'mainPage.dart';

class OnBoardingPage extends StatefulWidget {
  const OnBoardingPage({super.key});

  @override
  State<OnBoardingPage> createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  final PageController _pageController = PageController();
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return AppGradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 48),
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: onboardingData.length,
                  onPageChanged: (index) {
                    setState(() => currentIndex = index);
                  },
                  itemBuilder: (context, index) {
                    return OnboardingContent(item: onboardingData[index]);
                  },
                ),
              ),
              _Indicator(currentIndex),

              _NextButton(
                isLast: currentIndex == onboardingData.length - 1,
                onTap: () {
                  if (currentIndex < onboardingData.length - 1) {
                    _pageController.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeOut,
                    );
                  } else {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const MainPage()),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ImageCard extends StatelessWidget {
  final double size;
  final String imagePath;

  const ImageCard({super.key, required this.size, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        image: DecorationImage(image: AssetImage(imagePath), fit: BoxFit.cover),
      ),
    );
  }
}

enum OnboardingLayoutType { gridImages1, gridImages2, illustration }

class OnboardingItem {
  final String titleKey;
  final String highlightKey;
  final String descriptionKey;
  final OnboardingLayoutType layoutType;

  const OnboardingItem({
    required this.titleKey,
    required this.highlightKey,
    required this.descriptionKey,
    required this.layoutType,
  });
}

final onboardingData = [
  OnboardingItem(
    titleKey: 'onboarding.page1.title',
    highlightKey: 'onboarding.page1.highlight',
    descriptionKey: 'onboarding.page1.desc',
    layoutType: OnboardingLayoutType.gridImages1,
  ),
  OnboardingItem(
    titleKey: 'onboarding.page2.title',
    highlightKey: '',
    descriptionKey: 'onboarding.page2.desc',
    layoutType: OnboardingLayoutType.gridImages2,
  ),
  OnboardingItem(
    titleKey: 'onboarding.page3.title',
    highlightKey: '',
    descriptionKey: 'onboarding.page3.desc',
    layoutType: OnboardingLayoutType.illustration,
  ),
];

class OnboardingContent extends StatelessWidget {
  final OnboardingItem item;

  const OnboardingContent({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 6,
          child: Center(
            child: _buildLayout(item.layoutType, context),
          ),
        ),

        Expanded(
          flex: 4,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                    children: [
                      TextSpan(
                        text: '${item.titleKey.tr()} ',
                        style: const TextStyle(color: Colors.white),
                      ),
                      if (item.highlightKey.isNotEmpty)
                        TextSpan(
                          text: item.highlightKey.tr(),
                          style: const TextStyle(color: Color(0xFF8B5CF6)),
                        ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                Text(
                  item.descriptionKey.tr(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white70,
                    height: 1.6,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }


  Widget _buildLayout(OnboardingLayoutType type, BuildContext context) {
    switch (type) {
      case OnboardingLayoutType.gridImages1:
        return _buildGridImages1(context);
      case OnboardingLayoutType.gridImages2:
        return _buildGridImages2(context);
      case OnboardingLayoutType.illustration:
        return _buildAIComparison(context);
    }
  }

  Widget _buildGridImages1(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final size = width * 0.38;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          children: [
            ImageCard(size: size, imagePath: 'assets/onboarding/abstract.jpg'),
            const SizedBox(height: 16),
            ImageCard(size: size, imagePath: 'assets/onboarding/geometry.jpg'),
          ],
        ),
        const SizedBox(width: 16),
        Column(
          children: [
            ImageCard(size: size, imagePath: 'assets/onboarding/portrait.jpg'),
            const SizedBox(height: 16),
            ImageCard(size: size, imagePath: 'assets/onboarding/landscape.jpg'),
          ],
        ),
      ],
    );
  }

  Widget _buildGridImages2(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final size = width * 0.38;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          children: [
            ImageCard(size: size, imagePath: 'assets/onboarding/abstract.jpg'),
            const SizedBox(height: 16),
            ImageCard(size: size, imagePath: 'assets/onboarding/geometry.jpg'),
          ],
        ),
        const SizedBox(width: 16),
        Column(
          children: [
            ImageCard(size: size, imagePath: 'assets/onboarding/portrait.jpg'),
            const SizedBox(height: 16),
            ImageCard(size: size, imagePath: 'assets/onboarding/landscape.jpg'),
          ],
        ),
      ],
    );
  }

  Widget _buildAIComparison(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final cardWidth = width * 0.38;
    final cardHeight = cardWidth * 1.25;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _ImageWithBadge(
          width: cardWidth,
          height: cardHeight,
          imagePath: 'assets/person.jpeg',
          badgeText: 'badge_original'.tr(),
          badgeAlignment: Alignment.topLeft,
          badgeColor: Colors.black54,
          borderColor: Colors.transparent,
        ),

        const SizedBox(width: 16),

        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              colors: [Color(0xFF8B5CF6), Color(0xFF22D3EE)],
            ),
            boxShadow: [
              BoxShadow(
                color: Color(0xFF8B5CF6).withOpacity(0.6),
                blurRadius: 12,
              ),
            ],
          ),
          child: const Icon(Icons.auto_fix_high, color: Colors.white, size: 24),
        ),

        const SizedBox(width: 16),

        _ImageWithBadge(
          width: cardWidth,
          height: cardHeight,
          imagePath: 'assets/person2.jpeg',
          badgeText: 'badge_ai_art'.tr(),
          badgeAlignment: Alignment.bottomRight,
          badgeColor: const Color(0xFF8B5CF6),
          borderColor: const Color(0xFF8B5CF6),
        ),
      ],
    );
  }
}

class _Indicator extends StatelessWidget {
  final int current;

  const _Indicator(this.current);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (index) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: current == index ? const Color(0xFF8B5CF6) : Colors.white24,
            shape: BoxShape.circle,
          ),
        );
      }),
    );
  }
}

class _NextButton extends StatelessWidget {
  final bool isLast;
  final VoidCallback onTap;

  const _NextButton({Key? key, required this.isLast, required this.onTap})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
      child: SizedBox(
        width: double.infinity,
        height: 56,
        child: ElevatedButton(
          onPressed: onTap,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF8B5CF6),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(28),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                isLast ? 'start'.tr() : 'continue'.tr(),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.arrow_forward, color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }
}

class _ImageWithBadge extends StatelessWidget {
  final double width;
  final double height;
  final String imagePath;
  final String badgeText;
  final Alignment badgeAlignment;
  final Color badgeColor;
  final Color borderColor;

  const _ImageWithBadge({
    required this.width,
    required this.height,
    required this.imagePath,
    required this.badgeText,
    required this.badgeAlignment,
    required this.badgeColor,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor, width: 2),
        image: DecorationImage(image: AssetImage(imagePath), fit: BoxFit.cover),
      ),
      child: Align(
        alignment: badgeAlignment,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: badgeColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              badgeText,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
