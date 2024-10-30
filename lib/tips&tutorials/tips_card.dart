import 'package:flutter/material.dart';

class TipsCard extends StatelessWidget {
  final String title;
  final String agency;
  final String imageUrl; // Local asset path
  final String description;
  final String avatarUrl; // Local asset path

  const TipsCard({
    super.key,
    required this.title,
    required this.agency,
    required this.imageUrl,
    required this.description,
    required this.avatarUrl,
  });

  @override
  Widget build(BuildContext context) {
    final isLightTheme = Theme.of(context).brightness == Brightness.light;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TipDetailPage(
              title: title,
              agency: agency,
              imageUrl: imageUrl,
              description: description,
            ),
          ),
        );
      },
      child: Container(
        width: 250,
        margin: const EdgeInsets.only(bottom: 8, right: 2, left: 2),
        decoration: BoxDecoration(
          color: isLightTheme
              ? const Color.fromARGB(
                  255, 243, 243, 243) // Light mode background color
              : const Color.fromARGB(
                  255, 10, 10, 10), // Dark mode background color
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: Image.asset(
                imageUrl, // Load local asset
                height: 130,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              title,
              style: TextStyle(
                color: isLightTheme ? Colors.black : Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              description,
              style: TextStyle(
                color: isLightTheme ? Colors.black54 : Colors.white60,
                fontSize: 12,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundImage: AssetImage(avatarUrl), // Load local asset
                  ),
                  const SizedBox(width: 8),
                  Text(
                    agency,
                    style: TextStyle(
                      color: isLightTheme ? Colors.black54 : Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TipDetailPage extends StatelessWidget {
  final String title;
  final String agency;
  final String imageUrl; // Local asset path
  final String description;

  const TipDetailPage({
    super.key,
    required this.title,
    required this.agency,
    required this.imageUrl,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final isLightTheme = Theme.of(context).brightness == Brightness.light;

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: isLightTheme ? Colors.white : const Color(0xFF121212),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                imageUrl, // Load local asset
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: TextStyle(
                color: isLightTheme ? Colors.black : Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              agency,
              style: TextStyle(
                color: isLightTheme ? Colors.black54 : Colors.white70,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              description,
              style: TextStyle(
                color: isLightTheme ? Colors.black54 : Colors.white60,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
