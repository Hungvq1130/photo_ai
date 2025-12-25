import 'package:flutter/material.dart';

class Settings extends StatefulWidget {
  final String originImage;
  final String previewImage;
  final VoidCallback onPickImage;
  final bool isFavorite;
  final ValueChanged<bool> onFavoriteChanged;

  const Settings({
    super.key,
    required this.originImage,
    required this.previewImage,
    required this.onPickImage,
    required this.isFavorite,
    required this.onFavoriteChanged,
  });

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  late bool isFavorite;

  @override
  void initState() {
    super.initState();
    isFavorite = widget.isFavorite;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.asset(
                          widget.originImage, // ⬅️ ảnh gốc
                          fit: BoxFit.cover,
                        ),
                        Positioned(
                          top: 12,
                          left: 12,
                          child: IconButton(
                            icon: const Icon(Icons.close, color: Colors.white),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.asset(
                          widget.previewImage, // ⬅️ ảnh preset
                          fit: BoxFit.cover,
                        ),
                        Positioned(
                          top: 12,
                          right: 12,
                          child: IconButton(
                            icon: Icon(
                              isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_outline,
                              color: isFavorite ? Colors.red : Colors.white,
                            ),
                            onPressed: () {
                              setState(() => isFavorite = !isFavorite);
                              widget.onFavoriteChanged(isFavorite);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFAEC9FF),
                    shape: const StadiumBorder(),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    widget.onPickImage();
                  },
                  child: const Text(
                    'Apply to your photo',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
