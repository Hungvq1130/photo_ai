import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:photo_ai/gradientBackground.dart';
import 'package:photo_ai/textDocPage.dart';

import 'languagePage.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}
class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    void showRateAppDialog(BuildContext context) {
      showDialog(
        context: context,
        barrierDismissible: false,
        barrierColor: Colors.black.withOpacity(0.6),
        builder: (_) => const _RateAppDialog(),
      );
    }

    return AppGradientBackground(
      key: ValueKey(context.locale),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: const BackButton(color: Colors.white),
          title:  Text(
            'profile_title'.tr(),
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
        ),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _appHeader(),

            const SizedBox(height: 24),

            _sectionLabel('profile_section_legal'.tr()),
            _cardSection([
              _menuItem(
                icon: Icons.shield_outlined,
                iconColor: Colors.blueAccent,
                title: 'profile_privacy_policy'.tr(),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const TextDocumentPage(
                        title: 'Privacy Policy',
                        assetPath: 'assets/texts/privacy_policy.txt',
                      ),
                    ),
                  );
                },
              ),
              _menuItem(
                icon: Icons.description_outlined,
                iconColor: Colors.orangeAccent,
                title: 'profile_terms_of_service'.tr(),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const TextDocumentPage(
                        title: 'Terms of Service',
                        assetPath: 'assets/texts/terms_of_service.txt',
                      ),
                    ),
                  );
                },
              ),
            ]),

            const SizedBox(height: 24),

            _sectionLabel('profile_section_settings'.tr()),
            _cardSection([
              _menuItem(
                icon: Icons.language,
                iconColor: Colors.pinkAccent,
                title: 'profile_settings'.tr(),
                onTap: () async {
                  final changed = await Navigator.push<bool>(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const LanguagePage(fromProfile: true),
                    ),
                  );

                  if (changed == true && mounted) {
                    setState(() {});
                  }
                },

              ),
            ]),

            const SizedBox(height: 24),

            _sectionLabel('profile_section_community'.tr()),
            _cardSection([
              _menuItem(
                icon: Icons.star_border,
                iconColor: Colors.purpleAccent,
                title: 'profile_rate_app'.tr(),
                trailing: const Icon(Icons.open_in_new, color: Colors.white54),
                onTap: () {
                  showRateAppDialog(context);
                },
              ),
              _menuItem(
                icon: Icons.chat_bubble_outline,
                iconColor: Colors.deepPurpleAccent,
                title: 'profile_send_feedback'.tr(),
                onTap: () {
                },
              ),
            ]),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _appHeader() {
    return Column(
      children: [
        Container(
          width: 96,
          height: 96,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: const LinearGradient(
              colors: [
                Color(0xFF8B5CF6),
                Color(0xFFEC4899),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: Color(0xFF8B5CF6).withOpacity(0.5),
                blurRadius: 20,
              ),
            ],
          ),
          child: const Icon(
            Icons.auto_awesome,
            color: Colors.white,
            size: 42,
          ),
        ),
        const SizedBox(height: 16),
         Text(
          'profile_app_name'.tr(),
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 6),
         Text(
        'profile_app_slogan'.tr(),
          style: TextStyle(
            fontSize: 14,
            color: Colors.white60,
          ),
        ),
      ],
    );
  }


  Widget _sectionLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 12,
          color: Colors.white54,
          letterSpacing: 1.2,
        ),
      ),
    );
  }


  Widget _cardSection(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.06),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(children: children),
    );
  }

  Widget _menuItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: iconColor),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ),
            trailing ??
                const Icon(
                  Icons.chevron_right,
                  color: Colors.white38,
                ),
          ],
        ),
      ),
    );
  }
}

class _RateAppDialog extends StatefulWidget {
  const _RateAppDialog();

  @override
  State<_RateAppDialog> createState() => _RateAppDialogState();
}

class _RateAppDialogState extends State<_RateAppDialog> {
  int selectedStar = 0;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
        decoration: BoxDecoration(
          color: const Color(0xFF1E1628),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: Colors.white.withOpacity(0.08),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF8B5CF6).withOpacity(0.2),
              ),
              child: const Icon(
                Icons.favorite,
                color: Color(0xFF8B5CF6),
                size: 36,
              ),
            ),

            const SizedBox(height: 16),

            Text(
              'rate_title'.tr(),
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 8),

            Text(
              'rate_desc'.tr(),
              style: const TextStyle(
                fontSize: 14,
                height: 1.5,
                color: Colors.white70,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                final isActive = index < selectedStar;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedStar = index + 1;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Icon(
                      Icons.star,
                      size: 32,
                      color: isActive
                          ? const Color(0xFF8B5CF6)
                          : Colors.white24,
                    ),
                  ),
                );
              }),
            ),

            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: selectedStar == 0
                    ? null
                    : () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8B5CF6),
                  disabledBackgroundColor:
                  const Color(0xFF8B5CF6).withOpacity(0.3),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                child: Text(
                  'rate_submit'.tr(),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'rate_later'.tr(),
                style: const TextStyle(color: Colors.white54),
              ),
            ),
          ],
        ),
      ),
    );
  }

}

