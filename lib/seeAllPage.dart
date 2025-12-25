import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'gradientBackground.dart';
import 'settings.dart';
import 'favStorage.dart';
import 'homePage.dart';

class SeeAllPage extends StatelessWidget {
  final PresetSection section;

  const SeeAllPage({
    super.key,
    required this.section,
  });

  @override
  Widget build(BuildContext context) {
    return AppGradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: 26,
                      ),
                    ),

                    const Spacer(),

                    Text(
                      section.localizedName(context),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    const Spacer(),

                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.08),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.tune,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                child: Container(
                  height: 46,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.search,
                        color: Colors.white54,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'see_all_search_hint'.tr(),
                          style: const TextStyle(
                            color: Colors.white54,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                  itemCount: section.items.length,
                  gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 3 / 4,
                  ),
                  itemBuilder: (context, index) {
                    final item = section.items[index];
                    return _SeeAllItemCard(
                      section: section,
                      item: item,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SeeAllItemCard extends StatelessWidget {
  final PresetSection section;
  final PresetItem item;

  const _SeeAllItemCard({
    required this.section,
    required this.item,
  });

  void _openSettings(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) => Settings(
        originImage: item.imgOrigin,
        previewImage: item.imgPreview,
        isFavorite: item.isFavorite,
        onPickImage: () {},
        onFavoriteChanged: (value) async {
          item.isFavorite = value;

          final favoriteIds = await FavoriteStorage.load();
          if (value) {
            favoriteIds.add(item.id);
          } else {
            favoriteIds.remove(item.id);
          }
          await FavoriteStorage.save(favoriteIds);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _openSettings(context),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              item.imgPreview,
              fit: BoxFit.cover,
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.05),
                    Colors.black.withOpacity(0.35),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
