import 'package:flutter/material.dart';
import '../data/pose_links.dart';

class PoseListScreen extends StatelessWidget {
  final String category;

  PoseListScreen({required this.category});

  @override
  Widget build(BuildContext context) {
    final List<String> poses = poseImageUrls[category] ?? [];

    return Scaffold(
      appBar: AppBar(
        title: Text('$category Poses'),
      ),
      body: poses.isEmpty
          ? Center(child: Text('No poses available'))
          : GridView.builder(
              padding: const EdgeInsets.all(8),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // 2 images per row
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: poses.length,
              itemBuilder: (context, index) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    poses[index],
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, progress) {
                      return progress == null
                          ? child
                          : Center(child: CircularProgressIndicator());
                    },
                    errorBuilder: (context, error, stackTrace) => Center(
                      child: Icon(Icons.error),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
