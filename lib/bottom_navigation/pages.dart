import 'package:emcall/bottom_navigation/pages/contact_page.dart';
import 'package:emcall/bottom_navigation/pages/tips_tutorials_page.dart';
import 'package:emcall/services/map.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'pages/home_page.dart'; // Ensure this file exists

class Pages extends StatefulWidget {
  const Pages({super.key});

  @override
  PagesState createState() => PagesState();
}

class PagesState extends State<Pages> {
  int _currentIndex = 0; // Track the selected index

  // Define the list of pages for each navigation item
  final List<Widget> _pages = [
    const HomePage(),
    const ContactPage(),
    const TipsTutorialsPage(),
    const MapPage(),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: IndexedStack(
        index: _currentIndex, // Display the current page
        children: _pages, // Keep all pages in memory
      ),
      bottomNavigationBar: CurvedNavigationBar(
        index: _currentIndex,
        height: 60.0,
        items: <Widget>[
          Icon(
            Icons.home,
            size: 30,
            color: _currentIndex == 0
                ? (theme.brightness == Brightness.light
                    ? Colors.black87
                    : Colors.white)
                : (theme.brightness == Brightness.light
                    ? Colors.black54
                    : Colors.white54),
          ),
          Icon(
            Icons.contacts,
            size: 30,
            color: _currentIndex == 1
                ? (theme.brightness == Brightness.light
                    ? Colors.black87
                    : Colors.white)
                : (theme.brightness == Brightness.light
                    ? Colors.black54
                    : Colors.white54),
          ),
          Icon(
            Icons.info,
            size: 30,
            color: _currentIndex == 2
                ? (theme.brightness == Brightness.light
                    ? Colors.black87
                    : Colors.white)
                : (theme.brightness == Brightness.light
                    ? Colors.black54
                    : Colors.white54),
          ),
          Icon(
            Icons.settings,
            size: 30,
            color: _currentIndex == 3
                ? (theme.brightness == Brightness.light
                    ? Colors.black87
                    : Colors.white)
                : (theme.brightness == Brightness.light
                    ? Colors.black54
                    : Colors.white54),
          ),
        ],
        color:
            theme.brightness == Brightness.light ? Colors.white : Colors.black,
        buttonBackgroundColor:
            theme.brightness == Brightness.light ? Colors.white : Colors.black,
        backgroundColor: Colors.transparent,
        animationCurve: Curves.easeInOutCubicEmphasized,
        animationDuration: const Duration(milliseconds: 500),
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
