import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'favStorage.dart';
import 'gradientBackground.dart';
import 'homePage.dart';

class PresetDetailPage extends StatefulWidget {
  final PresetSection section;
  final PresetItem item;
  final VoidCallback onFavoriteChanged;
  final void Function(PresetSection, PresetItem) onPickImage;

  const PresetDetailPage({
    super.key,
    required this.section,
    required this.item,
    required this.onPickImage,
    required this.onFavoriteChanged,
  });

  @override
  State<PresetDetailPage> createState() => _PresetDetailPageState();
}

class _PresetDetailPageState extends State<PresetDetailPage> {
  bool _showControls = true;

  void _toggleControls() {
    setState(() {
      _showControls = !_showControls;
    });
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.item;

    return Scaffold(
      backgroundColor: Colors.black,
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              onTap: _toggleControls,
              child: Image.asset(
                item.imgPreview,
                fit: BoxFit.cover,
              ),
            ),
          ),

          AnimatedSlide(
            offset: _showControls ? Offset.zero : const Offset(0, -1),
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
            child: AnimatedOpacity(
              opacity: _showControls ? 1 : 0,
              duration: const Duration(milliseconds: 300),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _CircleButton(
                        icon: Icons.arrow_back,
                        onTap: () => Navigator.pop(context),
                      ),
                      _CircleButton(
                        icon: item.isFavorite
                            ? Icons.favorite
                            : Icons.favorite_border,
                        onTap: () async {
                          setState(() {
                            item.isFavorite = !item.isFavorite;
                          });

                          final favoriteIds = await FavoriteStorage.load();
                          item.isFavorite
                              ? favoriteIds.add(item.id)
                              : favoriteIds.remove(item.id);

                          await FavoriteStorage.save(favoriteIds);
                          widget.onFavoriteChanged();
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          AnimatedSlide(
            offset: _showControls ? Offset.zero : const Offset(0, 1),
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
            child: AnimatedOpacity(
              opacity: _showControls ? 1 : 0,
              duration: const Duration(milliseconds: 300),
              child: SafeArea(
                top: false,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurpleAccent,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onPressed: () {
                        widget.onPickImage(widget.section, widget.item);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.add_photo_alternate_outlined,
                              color: Colors.white),
                          const SizedBox(width: 10),
                          Text(
                            'preset_pick_image'.tr(),
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }


}

class _CircleButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _CircleButton({
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.4),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: Colors.white,
          size: 22,
        ),
      ),
    );
  }
}
