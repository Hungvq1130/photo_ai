// import 'dart:typed_data';
//
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:image_picker/image_picker.dart';
// import 'package:photo_ai/preset_history_item.dart';
// import 'package:photo_ai/settings.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// import 'imagePage.dart';
//
// class HomePage extends StatefulWidget {
//   const HomePage({super.key});
//
//   @override
//   State<HomePage> createState() => _HomePageState();
// }
//
// class _HomePageState extends State<HomePage> {
//   XFile? _pickedFile;
//   Uint8List? _pickedBytes;
//   String? _selectedPrompt;
//   bool _loading = false;
//
//   List<PromptPreset> presets = [];
//   bool loadingPresets = true;
//
//   PresetSection? _selectedSection;
//   PresetItem? _selectedItem;
//
//   final ImagePicker picker = ImagePicker();
//
//   Future<void> callApi() async {
//     const int maxRetry = 3;
//     const Duration drtDelay = Duration(seconds: 5);
//     if (_pickedBytes == null || _selectedPrompt == null) {
//       showSnack("Thiếu ảnh hoặc prompt");
//       return;
//     }
//
//     final apiUrl = Uri.parse("https://llmhub.oneadx.com/v1/generate-image");
//     const String apiKey = "8b756b8e-399b-4faa-9a9e-b3b620fad44f";
//
//     setState(() => _loading = true);
//
//     final body = {
//       "aspectRatio": "9:16",
//       "model": "Imagen 4",
//       "text": _selectedPrompt,
//       "images": [
//         {
//           "imageData": base64Encode(_pickedBytes!),
//           "mimeType": "image/png",
//           "mediaCategory": "MEDIA_CATEGORY_SUBJECT",
//         },
//       ],
//     };
//     debugPrint("$body");
//
//     int attempt = 0;
//
//     try {
//       while (attempt < maxRetry) {
//         attempt++;
//         debugPrint("Call api attempt: $attempt");
//         showSnack("Call API attempt: $attempt");
//
//         try {
//           final res = await http.post(
//             apiUrl,
//             headers: {"Content-Type": "application/json", "x-api-key": apiKey},
//             body: jsonEncode(body),
//           );
//           if (res.statusCode < 200 || res.statusCode >= 300) {
//             throw Exception("API lỗi:${res.statusCode} - ${res.body} ");
//           }
//           debugPrint("${res.body}");
//           final Map<String, dynamic> decoded = jsonDecode(res.body);
//           debugPrint('${decoded['status']}');
//           if (decoded['status'] != 'success') {
//             throw Exception('API status fail');
//           }
//           final String base64Img = (decoded["data"]?["image"] ?? "") as String;
//           final Uint8List bytes = base64Decode(base64.normalize(base64Img));
//           if (!mounted) return;
//           await saveHistory();
//           await Navigator.push(
//             context,
//             MaterialPageRoute(builder: (_) => ImagePage(bytes: bytes)),
//           );
//           return;
//         } catch (e) {
//           showSnack("Attempt $attempt failed");
//           if (attempt < maxRetry) {
//             await Future.delayed(drtDelay);
//           } else {
//             rethrow;
//           }
//         }
//       }
//     } catch (e) {
//       debugPrint('API failed after $maxRetry attempts:$e');
//       if (!mounted) return;
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text("Failed to generate image. Please try again"),
//         ),
//       );
//     } finally {
//       if (mounted) {
//         setState(() => _loading = false);
//       }
//     }
//
//   }
//
//   Future<void> pickImage(String prompt) async {
//     final XFile? file = await picker.pickImage(source: ImageSource.gallery);
//     if (file == null) return;
//
//     final bytes = await file.readAsBytes();
//
//     setState(() {
//       _pickedFile = file;
//       _pickedBytes = bytes;
//       _selectedPrompt = prompt;
//     });
//
//     await callApi();
//
//   }
//
//   void showSnack(String message) {
//     if (!mounted) return;
//     ScaffoldMessenger.of(context)
//       ..hideCurrentSnackBar()
//       ..showSnackBar(
//         SnackBar(content: Text(message), duration: const Duration(seconds: 2)),
//       );
//   }
//
//   List<PresetSection> sections = [];
//   bool loading = true;
//
//   Future<void> loadPresets() async {
//     final data = await rootBundle.loadString('assets/prompt_preset.json');
//     final List decoded = jsonDecode(data);
//
//     setState(() {
//       sections = decoded.map((e) => PresetSection.fromJson(e)).toList();
//       loading = false;
//     });
//   }
//
//   Future<void> saveHistory() async {
//     if (_selectedSection == null || _selectedItem == null) return;
//
//     final prefs = await SharedPreferences.getInstance();
//     final raw = prefs.getString('preset_history');
//
//     List list = raw != null ? jsonDecode(raw) : [];
//
//     final item = PresetHistoryItem(
//       sectionId: _selectedSection!.id,
//       sectionName: _selectedSection!.name,
//       itemId: _selectedItem!.id,
//       imgPreview: _selectedItem!.imgPreview,
//       usedAt: DateTime.now(),
//     );
//
//     list.insert(0, item.toJson());
//
//     if (list.length > 50) {
//       list = list.sublist(0, 50);
//     }
//
//     await prefs.setString('preset_history', jsonEncode(list));
//   }
//
//
//   @override
//   void initState() {
//     super.initState();
//     loadPresets();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Choose a Style")),
//       body: loading
//           ? const Center(child: CircularProgressIndicator())
//           : ListView.builder(
//         padding: const EdgeInsets.symmetric(vertical: 12),
//         itemCount: sections.length,
//         itemBuilder: (context, index) {
//           return _SectionWidget(
//             section: sections[index],
//             onPickImage: (section, item) {
//               _selectedSection = section;
//               _selectedItem = item;
//               pickImage(item.text);
//             },
//           );
//         },
//       ),
//     );
//   }
// }
//
// class PromptPreset {
//   final int id;
//   final String name;
//   final String imgPreview;
//   final String text;
//
//   PromptPreset({
//     required this.id,
//     required this.name,
//     required this.imgPreview,
//     required this.text,
//   });
//
//   factory PromptPreset.fromJson(Map<String, dynamic> json) {
//     return PromptPreset(
//       id: json["id"],
//       name: json["name"],
//       imgPreview: json["img_preview"],
//       text: json["text"],
//     );
//   }
// }
//
// class PresetSection {
//   final int id;
//   final String name;
//   final List<PresetItem> items;
//
//   PresetSection({required this.id, required this.name, required this.items});
//
//   factory PresetSection.fromJson(Map<String, dynamic> json) {
//     return PresetSection(
//       id: json['id'],
//       name: json['name'],
//       items: (json['items'] as List)
//           .map((e) => PresetItem.fromJson(e))
//           .toList(),
//     );
//   }
// }
//
// class PresetItem {
//   final int id;
//   final String imgPreview;
//   final String text;
//   bool isFavorite;
//
//   PresetItem({required this.id, required this.imgPreview, required this.text, this.isFavorite = false});
//
//   factory PresetItem.fromJson(Map<String, dynamic> json) {
//     return PresetItem(
//       id: json['id'],
//       imgPreview: json['img_preview'],
//       text: json['text'],
//       isFavorite: json['isFavorite'] ?? false,
//     );
//   }
// }
//
// class _SectionWidget extends StatelessWidget {
//   final PresetSection section;
//   final void Function(PresetSection section, PresetItem item) onPickImage;
//
//
//   const _SectionWidget({required this.section, required this.onPickImage});
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 16),
//           child: Row(
//             children: [
//               Text(
//                 section.name,
//                 style: const TextStyle(
//                   fontSize: 22,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ],
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
//               return _PresetItemCard(
//                 section: section,
//                 item: section.items[index],
//                 onPickImage: onPickImage,
//               );
//
//             },
//           ),
//         ),
//         const SizedBox(height: 24),
//       ],
//     );
//   }
// }
//
// class _PresetItemCard extends StatelessWidget {
//   final PresetSection section;
//   final PresetItem item;
//   final void Function(PresetSection section, PresetItem item) onPickImage;
//
//   const _PresetItemCard({required this.item, required this.onPickImage, required this.section});
//
//   void _openSettings(BuildContext context) {
//     showModalBottomSheet(
//       context: context,
//       builder: (_) => Settings(
//         isFavorite: item.isFavorite,
//         onPickImage: () => onPickImage(section, item),
//         onFavoriteChanged: (value) {
//           item.isFavorite = value;
//         },
//       ),
//     );
//   }
//
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
