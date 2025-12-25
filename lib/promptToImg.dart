import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_ai/gradientBackground.dart';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:flutter/services.dart' show rootBundle,KeyDownEvent, LogicalKeyboardKey;


import 'imagePage.dart';

class PromptImg extends StatefulWidget {
  final void Function(
      String prompt,
      List<Uint8List> images,
      ) onGenerate;

  const PromptImg({
    super.key,
    required this.onGenerate,
  });

  @override
  State<PromptImg> createState() => _PromptImgState();
}

class _PromptImgState extends State<PromptImg> {
  List<XFile> _pickedFiles = [];
  List<Uint8List> _pickedBytesList = [];
  int _selectedSuggestionIndex = 0;
  bool _loading = false;

  final TextEditingController _promptCtrl = TextEditingController();
  final ImagePicker picker = ImagePicker();

  final List<String> _suggestions = [
    'prompt_suggestion_1'.tr(),
    'prompt_suggestion_2'.tr(),
    'prompt_suggestion_3'.tr(),
  ];

  void _onSuggestionTap(int index) {
    setState(() {
      _selectedSuggestionIndex = index;
      _promptCtrl.text = _suggestions[index];
      _promptCtrl.selection = TextSelection.fromPosition(
        TextPosition(offset: _promptCtrl.text.length),
      );
    });
  }

  Future<void> pickImages() async {
    final List<XFile> files = await picker.pickMultiImage(limit: 3);
    if (files.isEmpty) return;
    final bytesList = await Future.wait(files.map((f) => f.readAsBytes()));
    setState(() {
      _pickedFiles = files;
      _pickedBytesList = bytesList;
    });
  }

  String defaultPrompt = "";

  readPrompt() async {
    String response;
    response = await rootBundle.loadString('assets/prompt.text');
    setState(() {
      defaultPrompt = response;
    });
  }

  void showSnack(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          duration: const Duration(seconds: 2),
        ),
      );
  }

  Widget _buildSuggestionChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(_suggestions.length, (index) {
          final isSelected = index == _selectedSuggestionIndex;
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: GestureDetector(
              onTap: () => _onSuggestionTap(index),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Colors.deepPurpleAccent
                      : Colors.grey[300],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: SizedBox(
                  width: 100,
                  child: Text(
                    _suggestions[index],
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.black87,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return AppGradientBackground(child: Scaffold(
      backgroundColor: Colors.transparent,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children:  [
                            _HeaderHero(),
                            SizedBox(height: 20),
                             Text(
                              'prompt_title'.tr(),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(
                              child: Text(
                                'prompt_subtitle'.tr(),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              child: _buildSuggestionChips(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: Container(
          padding: const EdgeInsets.fromLTRB(14, 12, 14, 16),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.25),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
            border: Border.all(
              color: Colors.white.withOpacity(0.08),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomTextFormField(
                textFormField: TextFormField(
                  minLines: 1,
                  maxLines: 3,
                  controller: _promptCtrl,
                  style: const TextStyle(color: Colors.white),
                  onTapOutside: (_) => FocusScope.of(context).unfocus(),
                  decoration: InputDecoration(
                    hintText: 'prompt_hint'.tr(),
                    hintStyle: TextStyle(
                      color: Colors.white.withOpacity(0.4),
                    ),
                  ),
                ),
                images: _pickedBytesList
                    .map(
                      (bytes) => Image.memory(
                    bytes,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                )
                    .toList(),
                onRemoveImage: (index) {
                  setState(() {
                    _pickedBytesList.removeAt(index);
                    _pickedFiles.removeAt(index);
                  });
                },
              ),

              const SizedBox(height: 12),

              Row(
                children: [
                  _CircleIconButton(
                    icon: Icons.add,
                    onTap: pickImages,
                  ),

                  const Spacer(),

                  ElevatedButton(
                    onPressed: _loading
                        ? null
                        : () {
                      final text = _promptCtrl.text.trim();
                      final prompt = text.isEmpty
                          ? _suggestions[_selectedSuggestionIndex]
                          : text;

                      widget.onGenerate(prompt, _pickedBytesList);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurpleAccent,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 28,
                        vertical: 14,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: _loading
                        ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                        :  Text(
                      'prompt_generate'.tr(),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),

    ));
  }
}

class _HeaderHero extends StatelessWidget {
  const _HeaderHero();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 250,
      height: 150,
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          Transform.translate(
            offset: const Offset(-50, 18),
            child: Transform.rotate(
              angle: -0.14,
              child: Opacity(
                opacity: 0.95,
                child: _collageCard('assets/hero_left.jpg', w: 80, h: 110),
              ),
            ),
          ),

          Transform.translate(
            offset: const Offset(50, 18),
            child: Transform.rotate(
              angle: 0.14,
              child: Opacity(
                opacity: 0.95,
                child: _collageCard('assets/hero_right.jpg', w: 80, h: 110),
              ),
            ),
          ),

          _collageCard('assets/hero_center.jpg', w: 90, h: 130),
        ],
      ),
    );
  }

  Widget _collageCard(String asset, {double w = 160, double h = 200}) {
    return Container(
      width: w,
      height: h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.45),
            blurRadius: 28,
            spreadRadius: -8,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Image.asset(asset, fit: BoxFit.cover),
      ),
    );
  }
}

class CustomTextFormField extends StatefulWidget {
  final TextFormField textFormField;
  final List<Widget> images;
  final Widget? button;

  final void Function(int index)? onRemoveImage;

  CustomTextFormField({
    super.key,
    required this.textFormField,
    this.button,
    this.images = const [],
    this.onRemoveImage,
  }) : assert(
  textFormField.controller != null,
  'textFormField must have a controller',
  );

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.25),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.white.withOpacity(0.1),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.images.isNotEmpty) ...[
                SizedBox(
                  height: 80,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: widget.images.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemBuilder: (_, index) {
                      return Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(14),
                            child: SizedBox(
                              width: 80,
                              height: 80,
                              child: widget.images[index],
                            ),
                          ),
                          Positioned(
                            top: 4,
                            right: 4,
                            child: GestureDetector(
                              onTap: () => widget.onRemoveImage?.call(index),
                              child: Container(
                                width: 22,
                                height: 22,
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.6),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.close,
                                  size: 14,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                const SizedBox(height: 10),
              ],

              Theme(
                data: Theme.of(context).copyWith(
                  inputDecorationTheme: const InputDecorationTheme(
                    border: InputBorder.none,
                    isDense: true,
                  ),
                ),
                child: widget.textFormField,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _CircleIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _CircleIconButton({
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withOpacity(0.12),
          border: Border.all(
            color: Colors.white.withOpacity(0.15),
          ),
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
