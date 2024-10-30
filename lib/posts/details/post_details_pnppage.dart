// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:emcall/posts/pnp_post.dart';

class PNPPostDetailPage extends StatelessWidget {
  final Post pnpPost;

  const PNPPostDetailPage({super.key, required this.pnpPost});

  Future<void> _downloadImage(BuildContext context, String url) async {
    try {
      // Print the URL to debug
      if (kDebugMode) {
        print("Downloading from: $url");
      }

      // Get the directory to save the image
      Directory appDocDir = await getApplicationDocumentsDirectory();
      String savePath = '${appDocDir.path}/${url.split('/').last}';

      // Create Dio instance
      Dio dio = Dio();
      await dio.download(url, savePath);

      // Show a success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Image downloaded to your gallery successfully!'),
        ),
      );
    } catch (e) {
      if (kDebugMode) {
        print("Error: $e");
      } // Print the error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to download image: $e'), // Show specific error
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 600.0,
            flexibleSpace: FlexibleSpaceBar(
              background: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Image.asset(
                  pnpPost.imageUrl, // Load local asset
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            backgroundColor: theme.appBarTheme.backgroundColor,
            foregroundColor: theme.appBarTheme.foregroundColor,
            elevation: 0,
            pinned: true,
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    pnpPost.title,
                    style: theme.textTheme.titleLarge,
                    textAlign: TextAlign.left,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    pnpPost.description,
                    style: theme.textTheme.titleMedium,
                    textAlign: TextAlign.justify,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _downloadImage(
              context, pnpPost.imageUrl); // Pass context to the function
        },
        backgroundColor: theme.brightness == Brightness.dark
            ? Colors.black.withOpacity(0.8)
            : Colors.white.withOpacity(0.8),
        child: const Icon(
          Icons.download_rounded,
          color: Colors.redAccent,
        ),
      ),
    );
  }
}
