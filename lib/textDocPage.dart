import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:photo_ai/gradientBackground.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:photo_ai/gradientBackground.dart';

class TextDocumentPage extends StatelessWidget {
  final String title;
  final String assetPath;

  const TextDocumentPage({
    super.key,
    required this.title,
    required this.assetPath,
  });

  Future<String> _loadText() async {
    return await rootBundle.loadString(assetPath);
  }

  @override
  Widget build(BuildContext context) {
    return AppGradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: const BackButton(color: Colors.white),
          title: Text(
            title,
            style: const TextStyle(color: Colors.white),
          ),
          centerTitle: true,
        ),
        body: FutureBuilder<String>(
          future: _loadText(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData) {
              return const Center(
                child: Text(
                  'Failed to load content',
                  style: TextStyle(color: Colors.white),
                ),
              );
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: _DocumentCard(
                title: title,
                content: snapshot.data!,
              ),
            );
          },
        ),
      ),
    );
  }
}

class _DocumentCard extends StatelessWidget {
  final String title;
  final String content;

  const _DocumentCard({
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.06),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(0.08),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.description_outlined,
                  color: Colors.orange,
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Cập nhật lần cuối: 24/10/2023',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white54,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 20),

          _buildContent(content),
        ],
      ),
    );
  }

  Widget _buildContent(String text) {
    final lines = text.split('\n');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: lines.map((line) {
        final trimmed = line.trim();

        if (RegExp(r'^\d+\.').hasMatch(trimmed)) {
          return Padding(
            padding: const EdgeInsets.only(top: 16, bottom: 8),
            child: Text(
              trimmed,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          );
        }

        if (trimmed.startsWith('-') || trimmed.startsWith('•')) {
          return Padding(
            padding: const EdgeInsets.only(left: 12, bottom: 6),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '• ',
                  style: TextStyle(
                    color: Color(0xFF8B5CF6),
                    fontSize: 18,
                  ),
                ),
                Expanded(
                  child: Text(
                    trimmed.replaceFirst(RegExp(r'^[-•]\s*'), ''),
                    style: const TextStyle(
                      fontSize: 14,
                      height: 1.6,
                      color: Colors.white70,
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        if (trimmed.isNotEmpty) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              trimmed,
              style: const TextStyle(
                fontSize: 14,
                height: 1.6,
                color: Colors.white70,
              ),
            ),
          );
        }

        return const SizedBox(height: 8);
      }).toList(),
    );
  }
}

