// import 'package:flutter/material.dart';
//
// import 'homePage.dart';
//
// class PresetItemCard extends StatelessWidget {
//   final PresetSection section;
//   final PresetItem item;
//   final void Function(PresetSection section, PresetItem item) onPickImage;
//   final void Function(PresetItem item) onToggleFavorite;
//
//   const PresetItemCard({
//     super.key,
//     required this.section,
//     required this.item,
//     required this.onPickImage,
//     required this.onToggleFavorite,
//   });
//
//   void _openSettings(BuildContext context) {
//     showModalBottomSheet(
//       context: context,
//       builder: (_) => Settings(
//         isFavorite: item.isFavorite,
//         onPickImage: () => onPickImage(section, item),
//         onFavoriteChanged: (_) => onToggleFavorite(item),
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () => _openSettings(context),
//       child: Container(
//         width: 170,
//         margin: const EdgeInsets.only(right: 12),
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(24),
//           image: DecorationImage(
//             image: AssetImage(item.imgPreview),
//             fit: BoxFit.cover,
//           ),
//         ),
//       ),
//     );
//   }
// }
