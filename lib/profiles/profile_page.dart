import 'dart:async';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:emcall/settings/about_app_page.dart';
import 'package:emcall/settings/contact_us_page.dart';
import 'package:emcall/settings/downloads_page.dart';
import 'package:emcall/settings/favorites_page.dart';
import 'package:emcall/settings/privacy_policy_page.dart';
import 'package:emcall/settings/rate_us_page.dart';
import 'package:emcall/settings/reportbug_page.dart';
import 'package:emcall/settings/terms_services_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
// import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'edit_profile_page.dart';
import '../auth/sign_in_screen_sugesstion.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  StreamSubscription<Position>? _positionStreamSubscription;
  Position? _currentPosition;
  bool _isLocationOn = false; // Track the state of the location toggle
  bool _isDarkMode = false; // State variable to track dark mode

  @override
  void initState() {
    super.initState();
    // Load the saved theme mode and update the switch state
    AdaptiveTheme.getThemeMode().then((mode) {
      setState(() {
        _isDarkMode = mode == AdaptiveThemeMode.dark;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.appBarTheme.backgroundColor,
        foregroundColor: theme.appBarTheme.foregroundColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // Settings action
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Picture and Text
              Row(
                children: [
                  const CircleAvatar(
                    radius: 40,
                    backgroundImage: AssetImage('assets/jun.png'),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Amadeo Amasan III',
                        style: theme.textTheme.titleLarge,
                      ),
                      Row(
                        children: [
                          Text(
                            '+63 923-456-789',
                            style: theme.textTheme.titleMedium,
                          ),
                          const SizedBox(width: 4),
                          const Icon(
                            Icons.verified,
                            color: Colors.redAccent,
                            size: 18,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 50),

              // Favorites & Downloads Section
              Text('General',
                  style: TextStyle(
                    color: theme.brightness == Brightness.dark
                        ? Colors.white.withOpacity(0.5)
                        : Colors.black
                            .withOpacity(0.5), // Change color based on theme
                    fontSize: 14, fontWeight: FontWeight.bold,
                  )),
              ListTile(
                leading: Icon(
                  Icons.favorite,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white // White icon for dark mode
                      : Colors.black, // Black icon for light mode
                ),
                title: const Text('Favorites'),
                trailing: const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 16,
                ),
                onTap: () {
                  _navigateToPage(context, const FavoritesPage());
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.download,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white // White icon for dark mode
                      : Colors.black, // Black icon for light mode
                ),
                title: const Text('Downloads'),
                trailing: const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 16,
                ),
                onTap: () {
                  _navigateToPage(context, const DownloadsPage());
                },
              ),

              const Divider(color: Color.fromARGB(73, 255, 36, 36)),
              Text('Accounts',
                  style: TextStyle(
                    color: theme.brightness == Brightness.dark
                        ? Colors.white.withOpacity(0.5)
                        : Colors.black
                            .withOpacity(0.5), // Change color based on theme
                    fontSize: 14, fontWeight: FontWeight.bold,
                  )),
              ListTile(
                leading: Icon(
                  Icons.edit_document,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white // White icon for dark mode
                      : Colors.black, // Black icon for light mode
                ),
                title: const Text('Edit Profile'),
                trailing: const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 16,
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const EditProfilePage()),
                  );
                },
              ),

              ListTile(
                leading: Icon(
                  Icons.logout,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white // White icon for dark mode
                      : Colors.black, // Black icon for light mode
                ),
                title: const Text('Log Out'),
                trailing: const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 16,
                ),
                onTap: () {
                  _showLogoutDialog(context);
                },
              ),

              // Preferences Section
              const Divider(color: Color.fromARGB(73, 255, 36, 36)),
              Text('Preferences',
                  style: TextStyle(
                    color: theme.brightness == Brightness.dark
                        ? Colors.white.withOpacity(0.5)
                        : Colors.black
                            .withOpacity(0.5), // Change color based on theme
                    fontSize: 14, fontWeight: FontWeight.bold,
                  )),
              // ListTile(
              //   leading: Icon(
              //     Icons.language_rounded,
              //     color: Theme.of(context).brightness == Brightness.dark
              //         ? Colors.white // White icon for dark mode
              //         : Colors.black, // Black icon for light mode
              //   ),
              //   title: const Text('Languages'),
              //   trailing: const Icon(
              //     Icons.arrow_forward_ios_rounded,
              //     size: 16,
              //   ),
              //   onTap: () {
              //     _showLanguageDialog(context);
              //   },
              // ),
              ListTile(
                leading: Icon(
                  Icons.notifications_active_rounded,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white // White icon for dark mode
                      : Colors.black, // Black icon for light mode
                ),
                title: const Text('Notifications'),
                trailing: const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 16,
                ),
              ),
              // Location Toggle
              SwitchListTile(
                title: Text(
                  _isLocationOn ? 'Location On' : 'Location Off',
                  style: const TextStyle(fontSize: 16),
                ),
                value: _isLocationOn, // Location toggle state
                onChanged: (value) {
                  setState(() {
                    _isLocationOn = value;
                    if (_isLocationOn) {
                      _enableLocation();
                    } else {
                      _disableLocation();
                      _currentPosition = null;
                    }
                  });
                },
                secondary: Icon(
                  _isLocationOn ? Icons.location_on : Icons.location_off,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white // White icon for dark mode
                      : Colors.black, // Black icon for light mode
                ),
                activeColor: Colors.red.shade700,
                activeTrackColor: Colors.redAccent,
                inactiveThumbColor: Colors.grey,
                inactiveTrackColor: Colors.black12,
              ),

              // Display current position or appropriate message
              _currentPosition != null
                  ? Text(
                      'Current Position: ${_currentPosition!.latitude}, ${_currentPosition!.longitude}')
                  : _isLocationOn // Check if location is enabled
                      ? const Text('Listening for location updates...')
                      : const Text(
                          'No coordinates available. Location is disabled.'),

              // Dark & Light Mode Toggle
              const SizedBox(height: 16),
              const Divider(color: Color.fromARGB(73, 255, 36, 36)),
              Text('Appearance',
                  style: TextStyle(
                    color: theme.brightness == Brightness.dark
                        ? Colors.white.withOpacity(0.5)
                        : Colors.black
                            .withOpacity(0.5), // Change color based on theme
                    fontSize: 14, fontWeight: FontWeight.bold,
                  )),
              SwitchListTile(
                title: Text(
                  _isDarkMode
                      ? 'Dark Mode'
                      : 'Light Mode', // Dynamically change the title
                  style: const TextStyle(fontSize: 16),
                ),
                value: _isDarkMode, // Tracks the current theme state
                onChanged: (value) {
                  setState(() {
                    _isDarkMode = value;

                    // Change the theme dynamically using AdaptiveTheme
                    if (_isDarkMode) {
                      AdaptiveTheme.of(context)
                          .setDark(); // Switch to dark theme
                    } else {
                      AdaptiveTheme.of(context)
                          .setLight(); // Switch to light theme
                    }
                  });
                },
                secondary: Icon(
                  _isDarkMode
                      ? Icons.dark_mode
                      : Icons.light_mode, // Dynamic icon change
                  color: _isDarkMode
                      ? Colors.white
                      : Colors.black, // Icon color based on theme
                ),
                activeColor: Colors.black,
                activeTrackColor: Colors.white,
                inactiveThumbColor: Colors.white,
                inactiveTrackColor: Colors.black,
              ),
              const Divider(color: Color.fromARGB(73, 255, 36, 36)),

              // Settings Section
              Text('Support & Feedback',
                  style: TextStyle(
                    color: theme.brightness == Brightness.dark
                        ? Colors.white.withOpacity(0.5)
                        : Colors.black
                            .withOpacity(0.5), // Change color based on theme
                    fontSize: 14, fontWeight: FontWeight.bold,
                  )),
              ListTile(
                leading: Icon(
                  Icons.contact_support_sharp,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white // White icon for dark mode
                      : Colors.black, // Black icon for light mode
                ),
                title: const Text('Contact with Us'),
                trailing: const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 16,
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ContactUsPage()),
                  );
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.star,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white // White icon for dark mode
                      : Colors.black, // Black icon for light mode
                ),
                title: const Text('Rate the App'),
                trailing: const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 16,
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const RateUsPage()),
                  );
                },
              ),

              ListTile(
                leading: Icon(
                  Icons.bug_report,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white // White icon for dark mode
                      : Colors.black, // Black icon for light mode
                ),
                title: const Text('Report a Bug'),
                trailing: const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 16,
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ReportBugPage()),
                  );
                },
              ),

              const Divider(color: Color.fromARGB(73, 255, 36, 36)),
              Text('Legal & About',
                  style: TextStyle(
                    color: theme.brightness == Brightness.dark
                        ? Colors.white.withOpacity(0.5)
                        : Colors.black
                            .withOpacity(0.5), // Change color based on theme
                    fontSize: 14, fontWeight: FontWeight.bold,
                  )),
              ListTile(
                leading: Icon(
                  Icons.privacy_tip,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white // White icon for dark mode
                      : Colors.black, // Black icon for light mode
                ),
                title: const Text('Privacy Policy'),
                trailing: const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 16,
                ),
                onTap: () {
                  _navigateToPage(context, const PrivacyPolicyPage());
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.description,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white // White icon for dark mode
                      : Colors.black, // Black icon for light mode
                ),
                title: const Text('Terms of Service'),
                trailing: const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 16,
                ),
                onTap: () {
                  _navigateToPage(context, const TermsOfServicePage());
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.info,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white // White icon for dark mode
                      : Colors.black, // Black icon for light mode
                ),
                title: const Text('About App'),
                trailing: const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 16,
                ),
                onTap: () {
                  _navigateToPage(context, const AboutAppPage());
                },
              ),

              const Divider(color: Color.fromARGB(73, 255, 36, 36)),
              const SizedBox(height: 16),
              const Center(
                child: Text('Copyright © 2024\nEmCall™ App Version 1.0',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey, fontSize: 12)),
              ),
              const SizedBox(height: 5),
            ],
          ),
        ),
      ),
    );
  }

  // Function to navigate to another page with slide transition
  void _navigateToPage(BuildContext context, Widget page) {
    Navigator.of(context).push(_createRoute(page));
  }

  // Function to create a slide transition for navigation
  Route _createRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0); // Slide in from the right
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);

        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
    );
  }

  void _enableLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return; // Location services are not enabled
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        return; // Permissions are not granted
      }
    }

    // Create a LocationSettings object with desired accuracy and distance filter
    LocationSettings locationSettings = const LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 10, // Update every 10 meters
    );

    // Start listening for location updates
    _positionStreamSubscription =
        Geolocator.getPositionStream(locationSettings: locationSettings).listen(
            (Position position) {
      setState(() {
        _currentPosition = position; // Update the current position
      });
    }, onError: (error) {});
  }

  void _disableLocation() {
    _positionStreamSubscription?.cancel();
    _positionStreamSubscription = null; // Clear the subscription

    if (kDebugMode) {
      print('Location updates disabled.');
    }
  }

  @override
  void dispose() {
    _disableLocation();
    super.dispose();
  }

  void _showLogoutDialog(BuildContext context) {
    final theme = Theme.of(context); // Access the current theme

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8), // Add border radius
          ),
          backgroundColor:
              theme.dialogBackgroundColor, // Match theme background

          title: Text(
            'Log Out',
            style: TextStyle(
              color: theme.brightness == Brightness.dark
                  ? Colors.white
                  : Colors.black, // Adjust color based on theme
              fontSize: 20,
            ),
          ),
          content: Text(
            'Are you sure you want to log out?',
            style: TextStyle(
              color: theme.brightness == Brightness.dark
                  ? Colors.white70
                  : Colors.black87, // Adjust for better contrast
              fontSize: 16,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.redAccent),
              ),
            ),
            TextButton(
              onPressed: () async {
                await _logout(context); // Call logout function
              },
              child: Text(
                'Yes',
                style: TextStyle(
                  color: theme.brightness == Brightness.dark
                      ? Colors.white
                      : Colors.black, // Adjust color for theme
                ),
              ),
            ),
          ],
        );
      },
    );
  }

// Logout function to clear session and navigate to SignInScreen
  Future<void> _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('isLoggedIn'); // Clear login state

    // Navigate to SignInScreen and remove all previous routes
    Navigator.pushAndRemoveUntil(
      // ignore: use_build_context_synchronously
      context,
      MaterialPageRoute(builder: (context) => const SignInScreen()),
      (route) => false, // Ensure all previous routes are removed
    );
  }
}

// void _showLanguageDialog(BuildContext context) {
//   final theme = Theme.of(context); // Access the current theme
//   showDialog(
//     context: context,
//     builder: (BuildContext context) {
//       return AlertDialog(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//         title: Text(
//           Intl.message('Select Language'),
//           style: TextStyle(
//             color: theme.brightness == Brightness.dark
//                 ? Colors.white
//                 : Colors.black, // Change color based on theme
//             fontSize: 20,
//           ),
//         ),
//         content: SizedBox(
//           width: 200,
//           height: 200,
//           child: ListView(
//             children: [
//               ListTile(
//                 title: Text(Intl.message('English')),
//                 onTap: () {
//                   // Handle language selection
//                   Navigator.of(context).pop();
//                 },
//               ),
//               ListTile(
//                 title: Text(Intl.message('Tagalog')),
//                 onTap: () {
//                   // Handle language selection
//                   Navigator.of(context).pop();
//                 },
//               ),
//               ListTile(
//                 title: Text(Intl.message('Korean')),
//                 onTap: () {
//                   // Handle language selection
//                   Navigator.of(context).pop();
//                 },
//               ),
//               ListTile(
//                 title: Text(Intl.message('Japanese')),
//                 onTap: () {
//                   // Handle language selection
//                   Navigator.of(context).pop();
//                 },
//               ),
//               ListTile(
//                 title: Text(Intl.message('Spanish')),
//                 onTap: () {
//                   // Handle language selection
//                   Navigator.of(context).pop();
//                 },
//               ),
//               ListTile(
//                 title: Text(Intl.message('Ukraine')),
//                 onTap: () {
//                   // Handle language selection
//                   Navigator.of(context).pop();
//                 },
//               ),
//               ListTile(
//                 title: Text(Intl.message('Thai')),
//                 onTap: () {
//                   // Handle language selection
//                   Navigator.of(context).pop();
//                 },
//               ),
//               ListTile(
//                 title: Text(Intl.message('Arabic')),
//                 onTap: () {
//                   // Handle language selection
//                   Navigator.of(context).pop();
//                 },
//               ),
//             ],
//           ),
//         ),
//         actions: [
//           TextButton(
//             style: TextButton.styleFrom(
//               foregroundColor: Colors.redAccent,
//             ),
//             onPressed: () {
//               Navigator.of(context).pop();
//             },
//             child: Text(Intl.message('Cancel')),
//           ),
//         ],
//       );
//     },
//   );
// }
