import 'package:flutter/material.dart';

class TutorialCard extends StatelessWidget {
  final String title;
  final String agency;
  final String imageUrl; // Local asset path
  final String description;
  final String avatarUrl; // Local asset path

  const TutorialCard({
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
            builder: (context) => TutorialDetailPage(
              title: title,
              agency: agency,
              imageUrl: imageUrl,
              description: description,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 4, right: 10, left: 10),
        decoration: BoxDecoration(
          color: isLightTheme
              ? const Color.fromARGB(
                  255, 243, 243, 243) // Light mode background color
              : const Color.fromARGB(
                  255, 10, 10, 10), // Dark mode background color
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: Image.asset(
                imageUrl, // Load local asset
                height: 95,
                width: 150,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: isLightTheme ? Colors.black : Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      color: isLightTheme ? Colors.black54 : Colors.white60,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Padding(
                    padding: const EdgeInsets.only(left: 4, bottom: 4),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 16,
                          backgroundImage:
                              AssetImage(avatarUrl), // Load local asset
                        ),
                        const SizedBox(width: 8),
                        Text(
                          agency,
                          style: TextStyle(
                            color:
                                isLightTheme ? Colors.black54 : Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                      ],
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

class TutorialDetailPage extends StatelessWidget {
  final String title;
  final String agency;
  final String imageUrl; // Local asset path
  final String description;

  const TutorialDetailPage({
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
