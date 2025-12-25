import 'dart:io';
import 'dart:typed_data';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_ai/gradientBackground.dart';

class ImagePage extends StatefulWidget {
  const ImagePage({super.key});

  @override
  State<ImagePage> createState() => ImagePageState();
}

class ImagePageState extends State<ImagePage> {
  Uint8List? _bytes;
  bool _loading = true;
  bool _showControls = true;
  bool _isFavorite = false;

  void setImage(Uint8List bytes) {
    setState(() {
      _bytes = bytes;
      _loading = false;
    });
  }

  void _toggleControls() {
    setState(() {
      _showControls = !_showControls;
    });
  }
  void _toggleFavorite() {
    setState(() {
      _isFavorite = !_isFavorite;
    });
  }

  Future<bool> _requestPermission() async {
    if (Platform.isAndroid) {
      if (await Permission.photos.isGranted) {
        return true;
      }

      final status = await Permission.photos.request();
      return status.isGranted;
    }
    return true;
  }


  Future<void> _saveToGallery() async {
    if (_bytes == null) return;

    try {
      final granted = await _requestPermission();
      if (!granted) return;

      final result = await ImageGallerySaverPlus.saveImage(
        _bytes!,
        quality: 100,
        name: "photo_ai_${DateTime.now().millisecondsSinceEpoch}",
      );

      if (result['isSuccess'] == true && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('image_save_success'.tr())),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${'image_save_failed'.tr()}: $e')),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: _loading
          ? _buildLoadingScreen()
          : _buildImageScreen(),
    );
  }



  Widget _buildLoadingScreen() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
               Text(
                'image_generating'.tr(),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 16),

              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  minHeight: 8,
                  value: null,
                  backgroundColor: Colors.white.withOpacity(0.15),
                  valueColor: const AlwaysStoppedAnimation(
                    Colors.deepPurpleAccent,
                  ),
                ),
              ),

              const SizedBox(height: 24),

               Center(
                child: Text(
                  'image_please_wait'.tr(),
                  style: TextStyle(
                    color: Colors.white38,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }



  Widget _buildImageScreen() {
    return Stack(
      children: [
        Positioned.fill(
          child: GestureDetector(
            onTap: _toggleControls,
            child: InteractiveViewer(
              child: Image.memory(
                _bytes!,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),

        AnimatedPositioned(
          duration: const Duration(milliseconds: 300),
          top: _showControls ? 0 : -100,
          left: 0,
          right: 0,
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
                      icon: _isFavorite ? Icons.favorite : Icons.favorite_border,
                      onTap: _toggleFavorite,
                    ),

                  ],
                ),
              ),
            ),
          ),
        ),

        AnimatedPositioned(
          duration: const Duration(milliseconds: 300),
          bottom: _showControls ? 16 : -120,
          left: 12,
          right: 12,
          child: AnimatedOpacity(
            opacity: _showControls ? 1 : 0,
            duration: const Duration(milliseconds: 300),
            child: SafeArea(
              top: false,
              child: Row(
                children: [
                  _CircleButton(icon: Icons.share, onTap: () {}),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _saveToGallery,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurpleAccent,
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(22),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.download, color: Colors.white),
                          SizedBox(width: 10),
                          Text(
                            'image_download'.tr(),
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

      ],
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
        width: 48,
        height: 48,
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
