import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'imagePage.dart';
import 'preset_history_item.dart';
import 'homePage.dart';

class PresetGenerator {
  final BuildContext context;
  final ImagePicker _picker = ImagePicker();

  PresetGenerator(this.context);

  PresetSection? _selectedSection;
  PresetItem? _selectedItem;
  Uint8List? _pickedBytes;

  Future<void> generate(PresetSection section, PresetItem item) async {
    _selectedSection = section;
    _selectedItem = item;

    final XFile? file =
    await _picker.pickImage(source: ImageSource.gallery);
    if (file == null) return;

    _pickedBytes = await file.readAsBytes();

    final pageKey = GlobalKey<ImagePageState>();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ImagePage(key: pageKey),
      ),
    );

    await _callApi(item.text, pageKey);
  }

  Future<void> generateWithPrompt({
    required String prompt,
    required List<Uint8List> images,
  }) async {
    final pageKey = GlobalKey<ImagePageState>();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ImagePage(key: pageKey),
      ),
    );

    await _callApiWithImages(prompt, images, pageKey);
  }

  Future<void> _callApiWithImages(
      String prompt,
      List<Uint8List> images,
      GlobalKey<ImagePageState> pageKey,
      ) async {
    const apiUrl = "https://llmhub.oneadx.com/v1/generate-image";
    const apiKey = "8b756b8e-399b-4faa-9a9e-b3b620fad44f";

    final imagesPayload = images.map((bytes) {
      return {
        "imageData": base64Encode(bytes),
        "mimeType": "image/png",
        "mediaCategory": "MEDIA_CATEGORY_SUBJECT",
      };
    }).toList();

    final body = {
      "aspectRatio": "9:16",
      "model": "Imagen 4",
      "text": prompt,
      "images": imagesPayload,
    };
    debugPrint("${body}");

    final res = await http.post(
      Uri.parse(apiUrl),
      headers: {
        "Content-Type": "application/json",
        "x-api-key": apiKey,
      },
      body: jsonEncode(body),
    );


    final decoded = jsonDecode(res.body);
    final base64Img = decoded["data"]["image"];
    final bytes = base64Decode(base64.normalize(base64Img));

    pageKey.currentState?.setImage(bytes);
  }


  Future<void> _callApi(
      String prompt,
      GlobalKey<ImagePageState> pageKey,
      ) async {
    const apiUrl = "https://llmhub.oneadx.com/v1/generate-image";
    const apiKey = "8b756b8e-399b-4faa-9a9e-b3b620fad44f";

    final body = {
      "aspectRatio": "9:16",
      "model": "Imagen 4",
      "text": prompt,
      "images": [
        {
          "imageData": base64Encode(_pickedBytes!),
          "mimeType": "image/png",
          "mediaCategory": "MEDIA_CATEGORY_SUBJECT",
        },
      ],
    };

    final res = await http.post(
      Uri.parse(apiUrl),
      headers: {
        "Content-Type": "application/json",
        "x-api-key": apiKey,
      },
      body: jsonEncode(body),
    );

    final decoded = jsonDecode(res.body);
    final base64Img = decoded["data"]["image"];
    final bytes = base64Decode(base64.normalize(base64Img));

    await _saveHistory();

    pageKey.currentState?.setImage(bytes);
  }


  Future<void> _saveHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString('preset_history');
    List list = raw != null ? jsonDecode(raw) : [];

    list.insert(
      0,
      PresetHistoryItem(
        sectionId: _selectedSection!.id,
        sectionName: _selectedSection!.name,
        itemId: _selectedItem!.id,
        imgPreview: _selectedItem!.imgPreview,
        imgOrigin: _selectedItem!.imgOrigin,
        prompt: _selectedItem!.text,
        usedAt: DateTime.now(),
      ).toJson(),
    );

    await prefs.setString(
      'preset_history',
      jsonEncode(list),
    );
  }

}
