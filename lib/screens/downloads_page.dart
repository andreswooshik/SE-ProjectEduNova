import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/downloads.dart';
import '../providers/downloads_provider.dart';
import 'video_player_page.dart';
import 'file_viewer_page.dart';

/// Downloads page displaying all downloaded content
/// Follows Single Responsibility Principle - displays downloads list
class DownloadsPage extends ConsumerStatefulWidget {
  final String? courseId;
  final String? courseName;

  const DownloadsPage({
    Key? key,
    this.courseId,
    this.courseName,
  }) : super(key: key);

  @override
  ConsumerState<DownloadsPage> createState() => _DownloadsPageState();
}

class _DownloadsPageState extends ConsumerState<DownloadsPage> {
  @override
  Widget build(BuildContext context) {
    final allDownloads = ref.watch(downloadsProvider);
    final downloads = widget.courseId != null
        ? ref
            .watch(downloadsProvider.notifier)
            .getDownloadsByCourse(widget.courseId!)
        : allDownloads;

    final videoDownloads =
        downloads.where((d) => d.type == DownloadType.video).toList();
    final fileDownloads = downloads
        .where((d) =>
            d.type == DownloadType.pdf || d.type == DownloadType.document)
        .toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(widget.courseName != null
            ? '${widget.courseName} Downloads'
            : 'My Downloads'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          if (downloads.isNotEmpty)
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert, color: Colors.black),
              onSelected: (value) {
                if (value == 'clear') {
                  _showClearDialog(context);
                }
              },
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 'clear',
                  child: Row(
                    children: const [
                      Icon(Icons.delete_outline, color: Colors.red),
                      SizedBox(width: 12),
                      Text('Clear All Downloads'),
                    ],
                  ),
                ),
              ],
            ),
        ],
      ),
      body: downloads.isEmpty
          ? _buildEmptyState()
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Storage Info
                  _buildStorageInfo(),
                  const SizedBox(height: 24),

                  // Downloaded Videos
                  if (videoDownloads.isNotEmpty) ...[
                    _buildSectionHeader(
                        'Downloaded Videos', videoDownloads.length),
                    const SizedBox(height: 12),
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: videoDownloads.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        return _buildVideoCard(context, videoDownloads[index]);
                      },
                    ),
                    const SizedBox(height: 24),
                  ],

                  // Downloaded Files
                  if (fileDownloads.isNotEmpty) ...[
                    _buildSectionHeader(
                        'Downloaded Files', fileDownloads.length),
                    const SizedBox(height: 12),
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: fileDownloads.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        return _buildFileCard(context, fileDownloads[index]);
                      },
                    ),
                  ],
                ],
              ),
            ),
    );
  }

  Widget _buildStorageInfo() {
    final totalStorage =
        ref.read(downloadsProvider.notifier).getTotalStorageFormatted();
    final itemCount = ref.read(downloadsProvider).length;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade400, Colors.blue.shade600],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.cloud_download,
              color: Colors.white,
              size: 32,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Total Storage Used',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  totalStorage,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$itemCount ${itemCount == 1 ? "item" : "items"} downloaded',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, int count) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.blue.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            '$count',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildVideoCard(BuildContext context, DownloadItem download) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DownloadVideoPlayerPage(download: download),
            ),
          );
        },
        splashColor: Colors.blue.withValues(alpha: 0.1),
        highlightColor: Colors.blue.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        child: Ink(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                // Thumbnail
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    width: 80,
                    height: 60,
                    color: Colors.grey.shade200,
                    child: download.thumbnail != null
                        ? Image.asset(
                            download.thumbnail!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                _buildVideoPlaceholder(),
                          )
                        : _buildVideoPlaceholder(),
                  ),
                ),
                const SizedBox(width: 12),
                // Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        download.title,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.videocam,
                              size: 14, color: Colors.grey.shade600),
                          const SizedBox(width: 4),
                          Text(
                            download.fileSizeFormatted,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Actions
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.play_circle_filled,
                          color: Colors.blue),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                DownloadVideoPlayerPage(download: download),
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.red),
                      onPressed: () => _showDeleteDialog(context, download),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFileCard(BuildContext context, DownloadItem download) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DownloadFileViewerPage(download: download),
            ),
          );
        },
        splashColor: Colors.green.withValues(alpha: 0.1),
        highlightColor: Colors.green.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        child: Ink(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: download.type == DownloadType.pdf
                        ? Colors.red.withValues(alpha: 0.1)
                        : Colors.blue.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    download.type == DownloadType.pdf
                        ? Icons.picture_as_pdf
                        : Icons.description,
                    color: download.type == DownloadType.pdf
                        ? Colors.red
                        : Colors.blue,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        download.title,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${download.fileExtension} • ${download.fileSizeFormatted}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    const Icon(Icons.chevron_right, color: Colors.grey),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.red),
                      onPressed: () => _showDeleteDialog(context, download),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildVideoPlaceholder() {
    return Container(
      color: Colors.grey.shade300,
      child: const Center(
        child: Icon(Icons.play_circle_outline, color: Colors.white, size: 32),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.cloud_download_outlined,
              size: 80,
              color: Colors.grey.shade300,
            ),
            const SizedBox(height: 16),
            Text(
              'No Downloads Yet',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Download videos and files to access them offline',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, DownloadItem download) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Download'),
        content: Text('Are you sure you want to delete "${download.title}"?'),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              ref.read(downloadsProvider.notifier).removeDownload(download.id);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Download deleted'),
                  backgroundColor: Colors.red,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showClearDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All Downloads'),
        content: const Text(
            'Are you sure you want to delete all downloaded content?'),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              ref.read(downloadsProvider.notifier).clearAllDownloads();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('All downloads cleared'),
                  backgroundColor: Colors.red,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Clear All'),
          ),
        ],
      ),
    );
  }
}
