import 'dart:ui';

import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:emcall/components/show_case_widget.dart';
import 'package:emcall/posts/bfp_post.dart';
import 'package:emcall/posts/pnp_post.dart';
import 'package:emcall/posts/rescue_post.dart';
import 'package:emcall/services/notification.dart';
import 'package:flutter/material.dart';
import 'package:showcaseview/showcaseview.dart';
import '../../posts/mdrrmo_page.dart';
import '../../profiles/profile_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  int notificationCount = 0; // Initialize with zero notifications

  // Add this method to increment notification count
  void _incrementNotificationCount() {
    setState(() {
      notificationCount++;
    });
  }

  // Add this method to decrement notification count
  void decrementNotificationCount() {
    setState(() {
      if (notificationCount > 0) {
        notificationCount--;
      }
    });
  }

//showcase
  final GlobalKey globalKeyOne = GlobalKey();
  final GlobalKey globalKeyTwo = GlobalKey();
  final GlobalKey globalKeyThree = GlobalKey();
  final GlobalKey globalKeyFour = GlobalKey();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) =>
        ShowCaseWidget.of(context).startShowCase(
            [globalKeyOne, globalKeyTwo, globalKeyThree, globalKeyFour]));

    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true); // Repeat the animation

    _animation = Tween<double>(begin: 0.9, end: 1.1).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.appBarTheme.backgroundColor,
        foregroundColor: theme.appBarTheme.foregroundColor,
        elevation: 0, // Remove shadow
        automaticallyImplyLeading: false, // Remove the back icon
        title: Row(
          children: [
            // Profile picture with gesture detection
            GestureDetector(
              onTap: () {
                // Navigate to Profile Page with fade animation
                Navigator.of(context).push(_createRoute());
              },
              child: ShowCaseView(
                globalKey: globalKeyOne,
                title: 'Profile Picture',
                description:
                    'Your Profile picture appears here, \n and allows you to click to navigate to settings!',
                child: const CircleAvatar(
                  backgroundColor: Colors.red,
                  maxRadius: 22,
                  // Replace Icon with Image from assets
                  backgroundImage: AssetImage('assets/jun.png'),
                ),
              ),
            ),
            const SizedBox(width: 10), // Space between icon and text
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hello, Amadeo!',
                  style: theme.textTheme.headlineMedium,
                ),
                Text(
                  '+63 9567211558',
                  style: theme.textTheme.headlineSmall,
                ),
              ],
            ),
          ],
        ),
        actions: [
          // Notification Icon Button
          IconButton(
            icon: const Stack(
              children: [
                Icon(Icons.notifications, size: 32),

                // Red dot for unread notifications
                Positioned(
                  right: 0,
                  top: 0,
                  child: CircleAvatar(
                    radius: 8,
                    backgroundColor: Colors.red,
                    child: Text(
                      '2', // Number of notifications (dynamic)
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            onPressed: () {
              // Handle notification button click
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('No new notifications')),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 60), // Space before the main button

              // Emergency Help Header
              Text(
                'Emergency help needed?',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.red[800], // Darker red for text
                ),
              ),
              const SizedBox(height: 10), // Space between text and button
              Text(
                'Just hold the button to report!',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 82), // Space before the emergency button

              // Emergency Button with Pulse Animation
              ShowCaseView(
                globalKey: globalKeyTwo,
                title: 'Button Alert',
                description: 'Click the button to send Emergency report!',
                child: ScaleTransition(
                  scale: _animation,
                  child: GestureDetector(
                    onLongPress: () {
                      // Show bottom sheet when the emergency button is long pressed
                      _showEmergencyResponderSheet(context);
                    },
                    child: Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.red,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Image.asset(
                          'assets/splash.png', // Replace with the path to your custom icon
                          width:
                              80, // Adjust the size of the image if necessary
                          height: 80,
                          color: Colors
                              .white, // Apply color if necessary, or remove if not needed
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 82), // Space after the emergency button

              // Not Sure What To Do? Section
              Text(
                'Not sure what to do?',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.red[800],
                ),
              ),
              const SizedBox(height: 20), // Space between text and options

              // Option Buttons
              ShowCaseView(
                globalKey: globalKeyThree,
                title: 'Dont Panic!',
                description:
                    'If Not sure what to do? \n just scroll horizontally and choose apropreate tutorials and tips!',
                child: SizedBox(
                  height: 80, // Set a height for the button container
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        _buildOptionButton('I have an injury'),
                        _buildOptionButton('I\'m feeling bad'),
                        _buildOptionButton('I have a fire emergency'),
                        _buildOptionButton('I need medical help'),
                        _buildOptionButton('I see a crime'),
                        _buildOptionButton('I need urgent help'),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20), // Space after options
            ],
          ),
        ),
      ),
    );
  }

  // Route for fade transition
  Route _createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          const ProfilePage(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(-1.0, 0.0); // Start from left side
        const end = Offset.zero; // End at the center
        const curve = Curves.easeInOut;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);

        return SlideTransition(
          position: offsetAnimation,
          child: FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
      },
    );
  }

  // Helper method to create option buttons
  Widget _buildOptionButton(String label) {
    return Container(
      height: 140,
      width: 140, // Set a fixed width for all buttons
      margin:
          const EdgeInsets.symmetric(horizontal: 5), // Space between buttons
      child: ElevatedButton(
        onPressed: () {
          // Add functionality for each option
          // Navigate to the respective page based on the label
          switch (label) {
            case 'I have an injury':
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MDRRMOPostPage()),
              );
              break;
            case 'I\'m feeling bad':
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PNPPostPage()),
              );
              break;
            case 'I have a fire emergency':
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const BFPPostPage()),
              );
              break;
            case 'I need medical help':
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const RescuePostPage()),
              );
              break;
            case 'I see a crime':
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PNPPostPage()),
              );
              break;
            case 'I need urgent help':
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const RescuePostPage()),
              );
              break;
            default:
              // Handle any unexpected cases
              break;
          }
        },
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(0),
          backgroundColor: Colors.red[300],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Left-aligned text
              Flexible(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    label, // Dynamic label
                    style: TextStyle(
                      color: Theme.of(context).brightness == Brightness.light
                          ? Colors.black
                          : Colors.white,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ),
              ),
              const SizedBox(height: 2), // Space between text and icons
              // Icons below the text
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(
                    Icons.arrow_forward, // Right arrow icon
                    color: Colors.white60,
                    size: 18,
                  ),
                  Icon(
                    Icons.person, // Profile icon
                    color: Colors.white60,
                    size: 18,
                  ),
                ],
              ),
              const SizedBox(height: 2),
            ],
          ),
        ),
      ),
    );
  }

  void _showEmergencyResponderSheet(BuildContext context) {
    final theme = Theme.of(context);
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Select Responder Agency',
                  style: theme.textTheme.headlineMedium,
                ),
                const SizedBox(height: 10),
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  children: [
                    buildResponderButton(
                        'PNP', Icons.local_police, Colors.blue, context),
                    buildResponderButton(
                        'BFP', Icons.fire_truck, Colors.orange, context),
                    buildResponderButton(
                        'MDRRMO', Icons.safety_divider, Colors.green, context),
                    buildResponderButton(
                        'RESCUE', Icons.health_and_safety, Colors.red, context),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Example of the buildResponderButton function
  Widget buildResponderButton(
      String title, IconData icon, Color iconColor, BuildContext context) {
    final theme = Theme.of(context); // Get the current theme

    // Choose the button color based on the theme's brightness
    final buttonColor =
        theme.brightness == Brightness.dark ? Colors.black : Colors.white60;

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: buttonColor, // Dynamically set background color
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      onPressed: () {
        // Show incident dialog when button is pressed
        _showIncidentDialog(context, title);
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: iconColor,
            size: 50,
          ),
          const SizedBox(height: 5),
          Text(
            title,
            style: TextStyle(
              color: theme.brightness == Brightness.dark
                  ? Colors.white70
                  : Colors.black87, // Adjust text color based on theme
            ),
          ),
        ],
      ),
    );
  }

  void _showIncidentDialog(BuildContext context, String agency) {
    final theme = Theme.of(context); // Access the current theme
    List<String> incidents = _getIncidentsForAgency(agency);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8), // Rounded corners
          ),
          backgroundColor:
              theme.dialogBackgroundColor, // Theme-based background
          title: Text(
            '$agency - Select Incident',
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: SizedBox(
            height: 300,
            width: 400,
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: incidents.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.pop(context); // Close on incident selection
                    _startCountdown(context, incidents[index], agency);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: theme.brightness == Brightness.light
                          ? Colors.black12
                          : Colors.white12, // Adaptive background color
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        incidents[index],
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.brightness == Brightness.light
                              ? Colors.black87
                              : Colors.white70, // Adaptive text color
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: Text(
                'Cancel',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.redAccent, // Red accent for cancel button
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

// Function to start the countdown and schedule a notification
  void _startCountdown(BuildContext context, String incident, String agency) {
    final theme = Theme.of(context); // Access the current theme
    CountDownController countdownController = CountDownController();
    int remainingTime = 5; // Countdown in seconds

    // Show the full-screen countdown dialog
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent accidental closing
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            countdownController.start();

            return Dialog(
              backgroundColor: Colors.transparent.withOpacity(0.5),
              insetPadding: EdgeInsets.zero, // Removes default padding
              child: ClipRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width, // Full width
                    height: MediaQuery.of(context).size.height, // Full height
                    color: Theme.of(context)
                        .dialogBackgroundColor
                        .withOpacity(0.5),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 10),
                        Text(
                          'Confirming Incident',
                          style: TextStyle(
                            color: theme.brightness == Brightness.dark
                                ? Colors.white
                                : Colors.black, // Change color based on theme
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Reporting: $incident\nAgency: $agency',
                          style: TextStyle(
                            color: theme.brightness == Brightness.dark
                                ? Colors.white
                                : Colors.black, // Change color based on theme
                            fontSize: 18,
                            fontWeight: FontWeight.normal,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 30),
                        CircularCountDownTimer(
                          duration: remainingTime,
                          initialDuration: 0,
                          controller: countdownController,
                          width: MediaQuery.of(context).size.width / 2,
                          height: MediaQuery.of(context).size.height / 2,
                          ringColor: Colors.grey[300]!,
                          fillColor: Colors.redAccent[100]!,
                          backgroundColor: Colors.red[500],
                          strokeWidth: 20.0,
                          textStyle: const TextStyle(
                            fontSize: 33.0,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          textFormat: CountdownTextFormat.S,
                          isReverse: false,
                          isTimerTextShown: true,
                          onStart: () {
                            debugPrint('Countdown Started');
                          },
                          onComplete: () {
                            debugPrint('Countdown Ended');
                            Navigator.pop(
                                dialogContext); // Close the dialog when the countdown ends
                            // Schedule the notification for incident reported
                            DateTime scheduledDate =
                                DateTime.now().add(const Duration(seconds: 5));
                            NotificationService.scheduleNotification(
                              0,
                              "Incident Reported",
                              'The incident "$incident" has been reported to $agency.',
                              scheduledDate,
                              // ignore: void_checks
                              () {
                                _incrementNotificationCount(); // Update count here
                              },
                              onComplete: () {},
                            );
                          },
                        ),
                        const SizedBox(height: 10),
                        IconButton(
                          onPressed: () {
                            countdownController.pause(); // Pause the countdown
                            if (dialogContext.mounted) {
                              Navigator.pop(dialogContext); // Close the dialog
                            }

                            // Schedule the cancel notification
                            DateTime scheduledDate =
                                DateTime.now().add(const Duration(seconds: 2));
                            NotificationService.scheduleNotification(
                              0,
                              "Incident Report Canceled",
                              'Your report for the "$incident" incident has been canceled and will not be sent to $agency.',
                              scheduledDate,
                              // ignore: void_checks
                              () {
                                _incrementNotificationCount(); // Update count here
                              },
                              onComplete: () {},
                            );
                          },
                          icon: const Icon(
                            Icons.cancel_rounded,
                            color: Colors.redAccent,
                            size: 80,
                          ),
                          tooltip: 'Cancel Report',
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

// Function to get a list of incidents based on the selected agency
  List<String> _getIncidentsForAgency(String agency) {
    switch (agency) {
      case 'PNP':
        return ['Robbery', 'Assault', 'Disturbance', 'Vandalism'];
      case 'BFP':
        return ['Fire', 'Explosion', 'Gas Leak', 'Rescue Operation'];
      case 'MDRRMO':
        return ['Flood', 'Earthquake', 'Typhoon', 'Landslide'];
      case 'RESCUE':
        return ['Medical Emergency', 'Road Accident', 'Heart Attack', 'Stroke'];
      default:
        return [];
    }
  }
}
