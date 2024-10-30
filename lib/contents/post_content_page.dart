import 'package:flutter/material.dart';

class PostContentPage extends StatelessWidget {
  final String title;
  final String agency;
  final String imageUrl;
  final String description;

  const PostContentPage({
    super.key,
    required this.title,
    required this.agency,
    required this.imageUrl,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212), // Dark background color
      appBar: AppBar(
        title: Text(title),
        backgroundColor: const Color(0xFF121212),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  imageUrl,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                agency,
                style: const TextStyle(color: Colors.white70),
              ),
              const SizedBox(height: 16),
              Text(
                description,
                style: const TextStyle(color: Colors.white60),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
