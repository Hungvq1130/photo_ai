import 'dart:async';
import 'package:flutter/material.dart';
import 'package:photo_ai/gradientBackground.dart';
import 'package:photo_ai/languagePage.dart';
import 'onBoarding.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {

  double _progress = 0.0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startFakeLoading();
  }

  void _startFakeLoading() {
    _timer = Timer.periodic(const Duration(milliseconds: 60), (timer) {
      setState(() {
        _progress += 0.01;
        if (_progress >= 1) {
          _progress = 1;
          timer.cancel();
          _goNext();
        }
      });
    });
  }

  Future<void> _goNext() async {
    await Future.delayed(const Duration(milliseconds: 300));
    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LanguagePage()),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppGradientBackground(child: Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF2B163F),
              Color(0xFF1A1026),
              Color(0xFF120A1C),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const Spacer(),

              Container(
                width: 110,
                height: 110,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(28),
                ),
                padding: const EdgeInsets.all(18),
                child: Image.asset(
                  'assets/logo.png',
                ),
              ),

              const SizedBox(height: 24),

              const Text(
                "AI ArtGen",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),

              const SizedBox(height: 6),

              Text(
                "Create. Imagine. Generate.",
                style: TextStyle(
                  color: Colors.white.withOpacity(0.55),
                  fontSize: 14,
                ),
              ),

              const Spacer(),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.refresh,
                          color: Colors.deepPurpleAccent,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "Loading assets...",
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: LinearProgressIndicator(
                        value: _progress,
                        minHeight: 6,
                        backgroundColor: Colors.white.withOpacity(0.15),
                        valueColor: const AlwaysStoppedAnimation(
                          Colors.deepPurpleAccent,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              Text(
                "Version 1.0",
                style: TextStyle(
                  color: Colors.white.withOpacity(0.35),
                  fontSize: 12,
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    ));
  }
}
