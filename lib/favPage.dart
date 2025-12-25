import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:photo_ai/preset_detail_page.dart';
import 'package:photo_ai/preset_generator.dart';

import 'gradientBackground.dart';
import 'homePage.dart';

class FavoritePage extends StatelessWidget {
  final List<PresetSection> sections;
  final VoidCallback onSectionsChanged;

  const FavoritePage({
    super.key,
    required this.sections,
    required this.onSectionsChanged,
  });

  @override
  Widget build(BuildContext context) {
    final generator = PresetGenerator(context);

    final favoriteItems = sections
        .expand((section) => section.items)
        .where((item) => item.isFavorite)
        .toList();

    return AppGradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,

        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: Text(
            'favorite_title'.tr(),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),

        body: favoriteItems.isEmpty
            ? Center(
          child: Text(
            'favorite_empty'.tr(),
            style: const TextStyle(color: Colors.white54),
          ),
        )
            : GridView.builder(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          itemCount: favoriteItems.length,
          gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 14,
            mainAxisSpacing: 14,
            childAspectRatio: 3 / 4,
          ),
          itemBuilder: (context, index) {
            final item = favoriteItems[index];

            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => PresetDetailPage(
                      section: PresetSection(
                        id: 'favorite',
                        name: 'Favorite', // fallback
                        items: [item],
                      ),
                      item: item,
                      onPickImage: (section, item) {
                        generator.generate(section, item);
                      },
                      onFavoriteChanged: onSectionsChanged,
                    ),
                  ),
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(
                  item.imgPreview,
                  fit: BoxFit.cover,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
