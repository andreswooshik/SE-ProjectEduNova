import 'package:flutter/material.dart';
import '../models/downloads.dart';

class DownloadVideoPlayerPage extends StatelessWidget {
  final DownloadItem download;

  const DownloadVideoPlayerPage({
    Key? key,
    required this.download,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text(download.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.play_circle_outline,
              color: Colors.white,
              size: 80,
            ),
            const SizedBox(height: 16),
            const Text(
              'Video Player',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              download.title,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            const Text(
              'Video player integration coming soon!',
              style: TextStyle(
                color: Colors.white54,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
