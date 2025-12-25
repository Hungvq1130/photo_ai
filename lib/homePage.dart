import 'dart:typed_data';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_ai/preset_detail_page.dart';
import 'package:photo_ai/preset_generator.dart';
import 'package:photo_ai/seeAllPage.dart';
import 'package:photo_ai/settings.dart';

import 'favStorage.dart';
import 'gradientBackground.dart';
import 'imagePage.dart';

class HomePage extends StatefulWidget {
  final List<PresetSection> sections;
  final VoidCallback onSectionsChanged;

  const HomePage({
    super.key,
    required this.sections,
    required this.onSectionsChanged,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  XFile? _pickedFile;
  Uint8List? _pickedBytes;
  String? _selectedPrompt;
  bool _loading = false;

  List<PromptPreset> presets = [];
  bool loadingPresets = true;

  PresetSection? _selectedSection;
  PresetItem? _selectedItem;

  final ImagePicker picker = ImagePicker();

  void showSnack(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(message), duration: const Duration(seconds: 2)),
      );
  }

  @override
  Widget build(BuildContext context) {
    final generator = PresetGenerator(context);

    return AppGradientBackground(
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          backgroundColor: Colors.transparent,

          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(140),
            child: AppBar(
              automaticallyImplyLeading: false,
              elevation: 0,
              backgroundColor: Colors.transparent,

              flexibleSpace: Container(
                padding: const EdgeInsets.fromLTRB(16, 48, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.deepPurpleAccent,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Icon(
                            Icons.auto_awesome,
                            color: Colors.white,
                          ),
                        ),

                        const SizedBox(width: 12),

                        Text(
                          'app_name'.tr(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const Spacer(),

                        Stack(
                          children: [
                            const Icon(
                              Icons.notifications,
                              color: Colors.white,
                              size: 26,
                            ),
                            Positioned(
                              right: 0,
                              top: 0,
                              child: Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    Container(
                      height: 48,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      alignment: Alignment.center,
                      child: TextFormField(
                        style: const TextStyle(color: Colors.white),
                        cursorColor: Colors.white,
                        textInputAction: TextInputAction.search,
                        textAlignVertical: TextAlignVertical.center,

                        decoration: InputDecoration(
                          isDense: true,

                          hintText: 'search_hint'.tr(),
                          hintStyle: const TextStyle(color: Colors.white54,fontSize: 15),

                          prefixIcon: const Icon(
                            Icons.search,
                            color: Colors.white70,
                            size: 30,
                          ),

                          prefixIconConstraints: const BoxConstraints(
                            minWidth: 40,
                            minHeight: 40,
                          ),

                          contentPadding: const EdgeInsets.symmetric(vertical: 0),

                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                        ),

                        onFieldSubmitted: (value) {},
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          body: widget.sections.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 12),
            itemCount: widget.sections.length,
            itemBuilder: (context, index) {
              return SectionWidget(
                section: widget.sections[index],
                onPickImage: (section, item) {
                  generator.generate(section, item);
                },
                onSectionsChanged: widget.onSectionsChanged,
              );
            },
          ),
        ),
      )
    );
  }
}

class PromptPreset {
  final int id;
  final String name;
  final String imgPreview;
  final String text;

  PromptPreset({
    required this.id,
    required this.name,
    required this.imgPreview,
    required this.text,
  });

  factory PromptPreset.fromJson(Map<String, dynamic> json) {
    return PromptPreset(
      id: json["id"],
      name: json["name"],
      imgPreview: json["img_preview"],
      text: json["text"],
    );
  }
}

const Map<String, String> sectionKeyMap = {
  '5b2a5000-5964-4dad-9cee-0857b12893c4': 'christmas',
  '056ecd38-59a2-401f-8857-153d755e981d': 'snow_trend',
  '310ba402-da86-4a8e-8db3-c121436a3e6f': 'portrait',
};


class PresetSection {
  final String id;
  final String name;
  final List<PresetItem> items;

  PresetSection({required this.id, required this.name, required this.items});

  factory PresetSection.fromJson(Map<String, dynamic> json) {
    return PresetSection(
      id: json['id'] as String,
      name: json['name'],
      items: (json['items'] as List)
          .map((e) => PresetItem.fromJson(e))
          .toList(),
    );
  }

  String localizedName(BuildContext context) {
    final mappedKey = sectionKeyMap[id];

    if (mappedKey == null) return name;

    final key = 'section_$mappedKey';
    final translated = key.tr();

    if (translated == key) return name;

    return translated;
  }

}

class PresetItem {
  final String id;
  final String imgPreview;
  final String imgOrigin;
  final String text;
  bool isFavorite;

  PresetItem({
    required this.id,
    required this.imgPreview,
    required this.imgOrigin,
    required this.text,
    this.isFavorite = false,
  });

  factory PresetItem.fromJson(Map<String, dynamic> json) {
    return PresetItem(
      id: json['id'].toString(),
      imgPreview: json['img_preview'],
      imgOrigin: json['img_origin'],
      text: json['text'],
      isFavorite: json['isFavorite'] ?? false,
    );
  }
}

class SectionWidget extends StatelessWidget {
  final PresetSection section;
  final void Function(PresetSection section, PresetItem item) onPickImage;
  final VoidCallback onSectionsChanged;

  const SectionWidget({
    required this.section,
    required this.onPickImage,
    required this.onSectionsChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Text(
                section.localizedName(context),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => SeeAllPage(section: section),
                    ),
                  );
                },
                child: Text(
                  'see_all'.tr(),
                  style: TextStyle(
                    color: Colors.deepPurpleAccent,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 12),
        SizedBox(
          height: 180,
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: section.items.length,
            itemBuilder: (context, index) {
              return _PresetItemCard(
                section: section,
                item: section.items[index],
                onPickImage: onPickImage,
                onSectionsChanged: onSectionsChanged,
              );
            },
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}

class _PresetItemCard extends StatelessWidget {
  final PresetSection section;
  final PresetItem item;
  final VoidCallback onSectionsChanged;
  final void Function(PresetSection section, PresetItem item) onPickImage;

  const _PresetItemCard({
    required this.section,
    required this.item,
    required this.onPickImage,
    required this.onSectionsChanged,
  });

  void _openSettings(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) => Settings(
        originImage: item.imgOrigin,
        previewImage: item.imgPreview,
        isFavorite: item.isFavorite,
        onPickImage: () => onPickImage(section, item),
        onFavoriteChanged: (value) async {
          item.isFavorite = value;

          final favoriteIds = await FavoriteStorage.load();

          if (value) {
            favoriteIds.add(item.id);
          } else {
            favoriteIds.remove(item.id);
          }

          await FavoriteStorage.save(favoriteIds);
          onSectionsChanged();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final generator = PresetGenerator(context);
    return GestureDetector(
      onTap: () {

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => PresetDetailPage(
              section: section,
              item: item,
              onPickImage: (section, item) {
                generator.generate(section, item);
              },
              onFavoriteChanged: onSectionsChanged,
            ),
          ),
        );
      },
      child: Container(
        width: 120,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: AspectRatio(
          aspectRatio: 3 / 4,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(item.imgPreview, fit: BoxFit.cover),

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
        ),
      ),
    );
  }
}
