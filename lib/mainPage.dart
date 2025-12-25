import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:photo_ai/preset_generator.dart';
import 'package:photo_ai/profilePage.dart';
import 'package:photo_ai/promptToImg.dart';

import 'favPage.dart';
import 'favStorage.dart';
import 'gradientBackground.dart';
import 'hisPage.dart';
import 'homePage.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;
  List<PresetSection> sections = [];

  @override
  void initState() {
    super.initState();
    loadPresets();
  }

  Future<void> loadPresets() async {
    final data = await rootBundle.loadString('assets/prompt_preset.json');
    final List decoded = jsonDecode(data);

    final favoriteIds = await FavoriteStorage.load();

    setState(() {
      sections = decoded.map((e) {
        final section = PresetSection.fromJson(e);
        for (final item in section.items) {
          item.isFavorite = favoriteIds.contains(item.id);
        }
        return section;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomePage(sections: sections, onSectionsChanged: () => setState(() {})),
      const HistoryPage(),
      FavoritePage(
        sections: sections,
        onSectionsChanged: () => setState(() {}),
      ),
      const ProfilePage(),
    ];


    return AppGradientBackground(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 78),
              child: pages[_selectedIndex],
            ),

            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: _CustomBottomBar(
                currentIndex: _selectedIndex,
                onTap: (i) => setState(() => _selectedIndex = i),
              ),
            ),

            Positioned(
              bottom: 30,
              left: 0,
              right: 0,
              child: Center(
                child: _CenterPlusButton(onPressed: () {}),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CustomBottomBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const _CustomBottomBar({
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 78,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.white.withOpacity(0.08))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _navItem(Icons.home, 'nav_home'.tr(), 0),
          _navItem(Icons.history, 'nav_history'.tr(), 1),

          const SizedBox(width: 54),

          _navItem(Icons.favorite, 'nav_favorite'.tr(), 2),
          _navItem(Icons.person, 'nav_profile'.tr(), 3),
        ],
      ),
    );
  }

  Widget _navItem(IconData icon, String label, int index) {
    final isActive = currentIndex == index;

    return SizedBox(
      width: 72,
      height: 56,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        splashColor: Colors.deepPurpleAccent.withOpacity(0.25),
        highlightColor: Colors.deepPurpleAccent.withOpacity(0.12),
        onTap: () {
          HapticFeedback.lightImpact();
          onTap(index);
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 24,
              color: isActive ? Colors.deepPurpleAccent : Colors.white54,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: isActive ? Colors.deepPurpleAccent : Colors.white54,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CenterPlusButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _CenterPlusButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.deepPurpleAccent,
        boxShadow: [
          BoxShadow(
            color: Colors.deepPurpleAccent.withOpacity(0.6),
            blurRadius: 24,
            spreadRadius: 6,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        shape: const CircleBorder(),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => PromptImg(
                  onGenerate: (prompt, images) {
                    PresetGenerator(context).generateWithPrompt(
                      prompt: prompt,
                      images: images,
                    );
                  },
                ),
              ),
            );
          },
          child: const Center(
            child: Icon(Icons.add, size: 32, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
