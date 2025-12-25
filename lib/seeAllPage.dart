import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:photo_ai/preset_detail_page.dart';
import 'package:photo_ai/route_observer.dart';
import 'gradientBackground.dart';
import 'settings.dart';
import 'favStorage.dart';
import 'homePage.dart';

class SeeAllPage extends StatefulWidget {
  final PresetSection section;

  const SeeAllPage({
    super.key,
    required this.section,
  });
  @override
  State<SeeAllPage> createState() => _SeeAllPageState();
}
class _SeeAllPageState extends State<SeeAllPage> with RouteAware {
  final FocusNode _searchFocusNode = FocusNode();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final route = ModalRoute.of(context);
    if (route is PageRoute) {
      routeObserver.subscribe(this, route);
    }
  }

  @override
  void didPopNext() {
    _searchFocusNode.unfocus();
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppGradientBackground(
        child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: Scaffold(
              resizeToAvoidBottomInset: false,
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
                            onTap: () => {
                    _searchFocusNode.unfocus(),
                    Navigator.pop(context)
                    },
                            child: const Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                              size: 26,
                            ),
                          ),

                          const Spacer(),

                          Text(
                            widget.section.localizedName(context),
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
                        height: 48,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        alignment: Alignment.center,
                        child: TextFormField(
                          focusNode: _searchFocusNode,
                          style: const TextStyle(color: Colors.white),
                          cursorColor: Colors.white,
                          textInputAction: TextInputAction.search,
                          textAlignVertical: TextAlignVertical.center,

                          decoration: InputDecoration(
                            isDense: true,

                            hintText: 'see_all_search_hint'.tr(),
                            hintStyle: const TextStyle(
                              color: Colors.white54,
                              fontSize: 15,
                            ),

                            prefixIcon: const Icon(
                              Icons.search,
                              color: Colors.white70,
                              size: 30,
                            ),

                            prefixIconConstraints: const BoxConstraints(
                              minWidth: 40,
                              minHeight: 40,
                            ),

                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 0),

                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                          ),

                          onChanged: (value) {
                          },

                          onFieldSubmitted: (value) {
                            FocusScope.of(context).unfocus();
                          },
                        ),
                      ),
                    ),

                    Expanded(
                      child: GridView.builder(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                        itemCount: widget.section.items.length,
                        gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 3 / 4,
                        ),
                        itemBuilder: (context, index) {
                          final item = widget.section.items[index];
                          return _SeeAllItemCard(
                            section: widget.section,
                            item: item,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
        )
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
      builder: (_) =>
          Settings(
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
      onTap: () {
        FocusScope.of(context).unfocus();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => PresetDetailPage(
              section: section,
              item: item,
              onPickImage: (section, item) {
              },
              onFavoriteChanged: () {
              },
            ),
          ),
        );
      },
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
