import 'package:emcall/posts/bfp_post.dart';
import 'package:emcall/posts/mdrrmo_page.dart';
import 'package:emcall/posts/pnp_post.dart';
import 'package:emcall/posts/rescue_post.dart';
import 'package:flutter/material.dart';

class AgencyButton extends StatelessWidget {
  final String name;
  final IconData icon;

  const AgencyButton({
    super.key,
    required this.name,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final isLightTheme = Theme.of(context).brightness == Brightness.light;

    return GestureDetector(
      onTap: () {
        // Navigate to the respective page with a left-slide transition
        Widget targetPage;

        if (name == 'PNP') {
          targetPage = const PNPPostPage();
        } else if (name == 'BFP') {
          targetPage = const BFPPostPage();
        } else if (name == 'MDRRMO') {
          targetPage = const MDRRMOPostPage();
        } else if (name == 'Rescue') {
          targetPage = const RescuePostPage();
        } else {
          targetPage = Scaffold(
            appBar: AppBar(title: const Text('Unknown Agency')),
            body: const Center(child: Text('Agency not recognized.')),
          );
        }

        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => targetPage,
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              const begin = Offset(1.0, 0.0); // Slide from the right
              const end = Offset.zero; // To the center (current position)
              const curve = Curves.ease;

              var tween =
                  Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
              var offsetAnimation = animation.drive(tween);

              return SlideTransition(
                position: offsetAnimation,
                child: child,
              );
            },
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          color: isLightTheme
              ? Colors.white
              : const Color(0xFF2C2C2C), // Box color based on theme
          borderRadius: BorderRadius.circular(8), // Rounded rectangular shape
          boxShadow: [
            BoxShadow(
              color: isLightTheme
                  ? Colors.grey.withOpacity(0.5)
                  : Colors.black.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Row(
          children: [
            // Icon on the left
            Icon(
              icon,
              color: isLightTheme
                  ? Colors.black
                  : Colors.white, // Icon color based on theme
              size: 24, // Size of the icon
            ),
            const SizedBox(width: 8),
            // Text on the right
            Text(
              name,
              style: TextStyle(
                color: isLightTheme
                    ? Colors.black
                    : Colors.white, // Text color based on theme
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
