// import 'package:flutter/material.dart';
// import 'package:photo_ai/preset_item_card.dart';
//
// import 'homePage.dart';
//
// class PresetSectionWidget extends StatelessWidget {
//   final PresetSection section;
//   final void Function(PresetSection section, PresetItem item) onPickImage;
//   final void Function(PresetItem item) onToggleFavorite;
//
//   const PresetSectionWidget({
//     super.key,
//     required this.section,
//     required this.onPickImage,
//     required this.onToggleFavorite,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 16),
//           child: Text(
//             section.name,
//             style: const TextStyle(
//               fontSize: 22,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         ),
//         const SizedBox(height: 12),
//         SizedBox(
//           height: 260,
//           child: ListView.builder(
//             scrollDirection: Axis.horizontal,
//             padding: const EdgeInsets.symmetric(horizontal: 16),
//             itemCount: section.items.length,
//             itemBuilder: (context, index) {
//               return PresetItemCard(
//                 section: section,
//                 item: section.items[index],
//                 onPickImage: onPickImage,
//                 onToggleFavorite: onToggleFavorite,
//               );
//             },
//           ),
//         ),
//         const SizedBox(height: 24),
//       ],
//     );
//   }
// }
