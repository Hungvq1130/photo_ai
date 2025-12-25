import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:photo_ai/gradientBackground.dart';
import 'package:photo_ai/preset_detail_page.dart';
import 'package:photo_ai/preset_generator.dart';
import 'package:photo_ai/preset_history_item.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'homePage.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  Future<List<PresetItem>> loadHistoryItems() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString('preset_history');
    if (raw == null) return [];

    final List decoded = jsonDecode(raw);
    final history =
    decoded.map((e) => PresetHistoryItem.fromJson(e)).toList();

    final Map<String, PresetHistoryItem> uniqueMap = {};
    for (final item in history) {
      final existing = uniqueMap[item.itemId];
      if (existing == null || item.usedAt.isAfter(existing.usedAt)) {
        uniqueMap[item.itemId] = item;
      }
    }

    return uniqueMap.values.map((h) {
      return PresetItem(
        id: h.itemId,
        imgPreview: h.imgPreview,
        imgOrigin: h.imgOrigin,
        text: h.prompt,
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final generator = PresetGenerator(context);

    return AppGradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,

        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: Text(
            'history_title'.tr(),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),

        body: FutureBuilder<List<PresetItem>>(
          future: loadHistoryItems(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(color: Colors.white),
              );
            }

            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(
                child: Text(
                  'history_empty'.tr(),
                  style: const TextStyle(color: Colors.white54),
                ),
              );
            }

            final items = snapshot.data!;

            return GridView.builder(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
              itemCount: items.length,
              gridDelegate:
              const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
                childAspectRatio: 3 / 4,
              ),
              itemBuilder: (context, index) {
                final item = items[index];

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PresetDetailPage(
                          section: PresetSection(
                            id: 'history',
                            name: 'History', // fallback
                            items: [item],
                          ),
                          item: item,
                          onPickImage: (section, item) {
                            generator.generate(section, item);
                          },
                          onFavoriteChanged: () {},
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
            );
          },
        ),
      ),
    );
  }
}
