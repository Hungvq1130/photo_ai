import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import 'homePage.dart';
import 'mainPage.dart';
import 'onBoardingPage.dart';

class LanguagePage extends StatefulWidget {
  final bool fromProfile;

  const LanguagePage({
    super.key,
    this.fromProfile = false,
  });

  @override
  State<LanguagePage> createState() => _LanguagePageState();
}


class _LanguagePageState extends State<LanguagePage> {
  Locale selectedLocale = const Locale('en');

  final List<Map<String, dynamic>> languages = [
    {
      'locale': const Locale('en'),
      'name': 'English',
      'sub': 'English',
      'flag': '🇺🇸',
    },
    {
      'locale': const Locale('vi'),
      'name': 'Tiếng Việt',
      'sub': 'Vietnamese',
      'flag': '🇻🇳',
    },
    {
      'locale': const Locale('fr'),
      'name': 'Français',
      'sub': 'French',
      'flag': '🇫🇷',
    },
    {
      'locale': const Locale('es'),
      'name': 'Español',
      'sub': 'Spanish',
      'flag': '🇪🇸',
    },
    {
      'locale': const Locale('de'),
      'name': 'Deutsch',
      'sub': 'German',
      'flag': '🇩🇪',
    },
    {
      'locale': const Locale('ja'),
      'name': '日本語',
      'sub': 'Japanese',
      'flag': '🇯🇵',
    },
  ];

  @override
  void didChangeDependencies() {
    selectedLocale = context.locale;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1B0F2E), Color(0xFF2B144F)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 30),

              const Icon(
                Icons.language,
                size: 42,
                color: Colors.deepPurpleAccent,
              ),

              const SizedBox(height: 20),

              Text(
                'choose_language'.tr(),
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                'select_language_desc'.tr(),
                style: TextStyle(color: Colors.white.withOpacity(0.7)),
              ),

              const SizedBox(height: 30),

              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: languages.length,
                  itemBuilder: (context, index) {
                    final lang = languages[index];
                    final isSelected = selectedLocale == lang['locale'];

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedLocale = lang['locale'];
                        });
                        context.setLocale(lang['locale']);
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 14),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Colors.deepPurpleAccent.withOpacity(0.35)
                              : Colors.white.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Row(
                          children: [
                            Text(
                              lang['flag'],
                              style: const TextStyle(fontSize: 26),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    lang['name'],
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    lang['sub'],
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.6),
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Radio<Locale>(
                              value: lang['locale'],
                              groupValue: selectedLocale,
                              activeColor: Colors.deepPurpleAccent,
                              onChanged: (value) {
                                setState(() {
                                  selectedLocale = value!;
                                });
                                context.setLocale(value!);
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(20),
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurpleAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: () {
                      if (widget.fromProfile) {
                        Navigator.pop(context, true);
                      } else {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const OnBoardingPage(),
                          ),
                        );
                      }
                    },


                    child: Text(
                      'continue'.tr(),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
