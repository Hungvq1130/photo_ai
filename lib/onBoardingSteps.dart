import 'package:flutter/material.dart';

import 'homePage.dart';
import 'mainPage.dart';

class OnboardingSteps extends StatefulWidget {
  const OnboardingSteps({super.key});

  @override
  State<OnboardingSteps> createState() => _OnboardingStepsState();
}

class _OnboardingStepsState extends State<OnboardingSteps> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  final List<_OBData> _pages = [
    _OBData(
      hero: 'assets/onboarding1.png',
      title: 'Create Images with AI in Seconds',
      subtitle:
      'Turn your ideas into stunning visuals using powerful AI — no design skills required.',
      button: 'Next',
    ),
    _OBData(
      hero: 'assets/onboarding2.jpg',
      title: 'Unlimited Creativity',
      subtitle:
      'Generate art, portraits, logos, and social media images in any style you imagine',
      button: 'Next',
    ),
    _OBData(
      hero: 'assets/onboarding.png',
      title: 'Start Creating Today',
      subtitle:
      'Describe your idea, choose a style, and let AI bring your vision to life.',
      button: 'Start',
    ),
  ];



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [

              Image.asset('assets/logo.png'
                ,width: 150,
                height: 150,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 10),

              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: _pages.length,
                  onPageChanged: (index) {
                    setState(() => _currentIndex = index);
                  },
                  itemBuilder: (context, index) {
                    final data = _pages[index];
                    return Column(
                      children: [
                        Image.asset(data.hero,fit: BoxFit.contain,width: 350,height: 350,),
                        const SizedBox(height: 34),
                        Text(
                          data.title,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          data.subtitle,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _pages.length,
                      (index) => _dot(isActive: index == _currentIndex),
                ),
              ),

              const SizedBox(height: 34),

              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    if (_currentIndex < _pages.length - 1) {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    } else {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const MainPage(),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurpleAccent,
                    foregroundColor: Colors.white,
                  ),
                  child: Text(_pages[_currentIndex].button),
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

}

Widget _dot({required bool isActive}) {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 4),
    width: 8,
    height: 8,
    decoration: BoxDecoration(
      color: isActive ? Colors.blue : Colors.grey,
      borderRadius: BorderRadius.circular(4),
    ),
  );
}


class _OBData {
  final String hero;
  final String title;
  final String subtitle;
  final String button;

  const _OBData({
    required this.hero,
    required this.title,
    required this.subtitle,
    required this.button,
  });
}
