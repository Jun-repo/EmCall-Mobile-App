import 'package:emcall/tips&tutorials/tips_card.dart';
import 'package:emcall/tips&tutorials/tutorial_card.dart';
import 'package:flutter/material.dart';

class TipsAndTutorials extends StatelessWidget {
  final List<Map<String, String>> tipsData;
  final List<Map<String, String>> tutorialsData;

  const TipsAndTutorials({
    super.key,
    required this.tipsData,
    required this.tutorialsData,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Display Tips
          SizedBox(
            height: 200, // Adjust height as needed
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: tipsData.length,
              itemBuilder: (context, index) {
                final tip = tipsData[index];
                return TipsCard(
                  title: tip['title']!,
                  agency: tip['agency']!,
                  imageUrl: tip['imageUrl']!,
                  description: tip['description']!,
                  avatarUrl: tip['avatarUrl']!,
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          // Display Tutorials
          SizedBox(
            height: 200, // Adjust height as needed
            child: ListView.builder(
              itemCount: tutorialsData.length,
              itemBuilder: (context, index) {
                final tutorial = tutorialsData[index];
                return TutorialCard(
                  title: tutorial['title']!,
                  agency: tutorial['agency']!,
                  imageUrl: tutorial['imageUrl']!,
                  description: tutorial['description']!,
                  avatarUrl: tutorial['avatarUrl']!,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
