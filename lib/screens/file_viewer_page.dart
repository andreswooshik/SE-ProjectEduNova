import 'package:flutter/material.dart';
import '../models/downloads.dart';

class DownloadFileViewerPage extends StatelessWidget {
  final DownloadItem download;

  const DownloadFileViewerPage({
    Key? key,
    required this.download,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: Text(download.title),
        elevation: 0,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                download.type == DownloadType.pdf
                    ? Icons.picture_as_pdf
                    : Icons.description,
                color: download.type == DownloadType.pdf
                    ? Colors.red
                    : Colors.blue,
                size: 80,
              ),
              const SizedBox(height: 16),
              Text(
                download.title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                '${download.fileExtension} • ${download.fileSizeFormatted}',
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'File viewer integration coming soon!',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
