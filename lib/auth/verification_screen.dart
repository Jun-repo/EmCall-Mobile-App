import 'dart:io'; // For File
import 'package:emcall/auth/success_page.dart';
import 'package:emcall/services/notification.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // Import image_picker
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart'; // Import ML Kit

class VerificationScreen extends StatefulWidget {
  const VerificationScreen({super.key});

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  String? _selectedIdType;
  File? _frontIdImage; // File to store the front of the ID
  File? _backIdImage; // File to store the back of the ID
  final List<File?> _faceImages = List.filled(3, null);
  final ImagePicker _picker = ImagePicker();
  final TextRecognizer _textRecognizer = TextRecognizer();
  final TextEditingController _idNumberController = TextEditingController();
  bool isLoading = false; // Loading state variable

  @override
  void dispose() {
    _textRecognizer.close(); // Clean up the text recognizer
    super.dispose();
  }

  // Method to open the camera and capture images for front and back IDs
  Future<void> _pickFrontAndBackImages() async {
    // First, capture the front of the ID
    final XFile? frontImage =
        await _picker.pickImage(source: ImageSource.camera);
    if (frontImage != null) {
      final frontImageFile = File(frontImage.path);
      final frontText = await _scanText(frontImageFile); // Recognize text
      setState(() {
        _frontIdImage = frontImageFile; // Store the captured front image
      });
      // After capturing the front, capture the back of the ID
      final XFile? backImage =
          await _picker.pickImage(source: ImageSource.camera);
      if (backImage != null) {
        final backImageFile = File(backImage.path);
        final backText = await _scanText(backImageFile); // Recognize text
        setState(() {
          _backIdImage = backImageFile; // Store the captured back image
        });
        // Optionally, show an alert with recognized text
        _showRecognizedTextDialog(frontText, backText);
      }
    }
  }

  // Method to recognize text from an image using Google ML Kit
  Future<String> _scanText(File image) async {
    final inputImage = InputImage.fromFile(image);
    final recognizedText = await _textRecognizer.processImage(inputImage);
    return recognizedText.text;
  }

  // Show recognized text in a dialog
  void _showRecognizedTextDialog(String frontText, String backText) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF2C2C2C),
          title: const Text('ID Information',
              style: TextStyle(color: Colors.white)),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Front ID:',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(height: 8),
                Text(frontText, style: const TextStyle(color: Colors.white)),
                const SizedBox(height: 16),
                const Text('Back ID:',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(height: 8),
                Text(backText, style: const TextStyle(color: Colors.white)),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  // Method to capture face images
  Future<void> _pickFaceImage(int index) async {
    final XFile? faceImage =
        await _picker.pickImage(source: ImageSource.camera);
    if (faceImage != null) {
      setState(() {
        _faceImages[index] =
            File(faceImage.path); // Store the captured face image
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment:
                    CrossAxisAlignment.start, // Align text to start
                children: [
                  const SizedBox(height: 60),
                  // Title
                  Text(
                    'Verification',
                    style: theme.textTheme.headlineLarge,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Your Almost Done!',
                    style: theme.textTheme.titleMedium,
                  ),
                  const SizedBox(height: 50),

                  Text(
                    'ID Number',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.brightness == Brightness.dark
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 10),
                  // ID Number
                  TextFormField(
                    controller: _idNumberController,
                    decoration: InputDecoration(
                      labelText: 'ID Number',
                      labelStyle: Theme.of(context)
                          .inputDecorationTheme
                          .labelStyle, // Use label style from theme
                      floatingLabelBehavior: Theme.of(context)
                          .inputDecorationTheme
                          .floatingLabelBehavior,
                      border: Theme.of(context)
                          .inputDecorationTheme
                          .border, // Use border from theme
                      enabledBorder: Theme.of(context)
                          .inputDecorationTheme
                          .enabledBorder, // Use enabled border from theme
                      focusedBorder: Theme.of(context)
                          .inputDecorationTheme
                          .focusedBorder, // Use focused border from theme
                      hintStyle: Theme.of(context)
                          .inputDecorationTheme
                          .hintStyle, // Use hint style from theme
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your ID Number.';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 20),
                  // ID Type Label
                  Text(
                    'ID Type',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.brightness == Brightness.dark
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Add a label for front and back picture
                  Text(
                    'Choose your available ID and take a pic, both Front and Back!', // Label text
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w300,
                      fontSize: 12, // Replace with your desired size
                      color: theme.brightness == Brightness.dark
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 10),
                  // ID Type Dropdown
                  DropdownButtonFormField<String>(
                    value: _selectedIdType,
                    onChanged: (String? newValue) async {
                      setState(() {
                        _selectedIdType = newValue;
                      });
                      // Open camera to capture both front and back images
                      await _pickFrontAndBackImages();
                    },
                    decoration: InputDecoration(
                      labelStyle: Theme.of(context)
                          .inputDecorationTheme
                          .labelStyle, // Use label style from theme
                      floatingLabelBehavior: Theme.of(context)
                          .inputDecorationTheme
                          .floatingLabelBehavior,
                      border: Theme.of(context)
                          .inputDecorationTheme
                          .border, // Use border from theme
                      enabledBorder: Theme.of(context)
                          .inputDecorationTheme
                          .enabledBorder, // Use enabled border from theme
                      focusedBorder: Theme.of(context)
                          .inputDecorationTheme
                          .focusedBorder, // Use focused border from theme
                      hintStyle: Theme.of(context)
                          .inputDecorationTheme
                          .hintStyle, // Use hint style from theme
                    ),
                    dropdownColor: theme
                            .dropdownMenuTheme.menuStyle?.backgroundColor
                            ?.resolve({}) ??
                        Colors.grey[900], // Dropdown background color
                    items: <String>[
                      'Driver\'s License',
                      'Passport',
                      'National ID',
                      'Tin ID',
                      'Barangay ID',
                      'School ID',
                      'Other ID'
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: theme.dropdownMenuTheme
                              .textStyle, // Text style from the theme
                        ),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 20),
                  // // Display captured front and back images if available
                  // if (_frontIdImage != null && _backIdImage != null)
                  //   Row(
                  //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  //     children: [
                  //       // Display Front ID Image
                  //       Column(
                  //         children: [
                  //           Text(
                  //             'Front ID',
                  //             style: theme.textTheme.titleMedium,
                  //           ),
                  //           Image.file(
                  //             _frontIdImage!,
                  //             width: 100,
                  //             height: 100,
                  //             fit: BoxFit.cover,
                  //           ),
                  //         ],
                  //       ),
                  //       // Display Back ID Image
                  //       Column(
                  //         children: [
                  //           Text(
                  //             'Back ID',
                  //             style: theme.textTheme.titleMedium,
                  //           ),
                  //           Image.file(
                  //             _backIdImage!,
                  //             width: 100,
                  //             height: 100,
                  //             fit: BoxFit.cover,
                  //           ),
                  //         ],
                  //       ),
                  //     ],
                  //   ),

                  const SizedBox(height: 60),
                  // Add label for face view requirements
                  Text(
                    'Add 3 Face View Requirements',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.brightness == Brightness.dark
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Display placeholder boxes for face images
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(3, (index) {
                      String placeholderText;
                      Color boxColor;
                      Color textColor; // Variable to hold the text color

                      if (index == 0) {
                        placeholderText = 'Tap to\nAdd Left \nSide Face';
                      } else if (index == 1) {
                        placeholderText = 'Tap to\nAdd Front \nFace';
                      } else {
                        placeholderText = 'Tap to\nAdd Right \nSide Face';
                      }

                      // Determine the box color based on the current theme
                      boxColor = Theme.of(context).brightness == Brightness.dark
                          ? Colors.grey[900]! // Dark mode color
                          : Colors.grey[300]!; // Light mode color

                      // Determine the text color based on the current theme
                      textColor =
                          Theme.of(context).brightness == Brightness.dark
                              ? Colors.white // Dark mode text color
                              : Colors.black; // Light mode text color

                      return GestureDetector(
                        onTap: () =>
                            _pickFaceImage(index), // Capture face image on tap
                        child: Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            color: boxColor, // Use the determined box color
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: _faceImages[index] != null
                              ? Image.file(
                                  _faceImages[index]!,
                                  fit: BoxFit.cover,
                                )
                              : Center(
                                  child: Text(
                                    placeholderText, // Use the updated placeholder text
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color:
                                          textColor, // Use the determined text color
                                    ),
                                  ),
                                ),
                        ),
                      );
                    }),
                  ),

                  const SizedBox(height: 40),
                  // Sign Up Now Button
                  Center(
                    child: ElevatedButton(
                      onPressed: () async {
                        // Check if all images are selected
                        if (_frontIdImage == null ||
                            _backIdImage == null ||
                            _faceImages.contains(null)) {
                          // Show dialog if verification is not complete
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text('Verification Incomplete'),
                                content: const Text(
                                    'Please complete the verification process before signing up.'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context)
                                          .pop(); // Close the dialog
                                    },
                                    child: const Text('OK'),
                                  ),
                                ],
                              );
                            },
                          );
                        } else {
                          // Start loading
                          setState(() {
                            isLoading = true; // Set loading state to true
                          });

                          DateTime scheduledDate =
                              DateTime.now().add(const Duration(seconds: 5));
                          NotificationService.scheduleNotification(
                            0,
                            "Sign up Success",
                            "Your Account has been created, thanks for using this app!",
                            scheduledDate,
                            // ignore: void_checks
                            () {
                              incrementNotificationCount(); // Update count here
                            },
                            onComplete: () {},
                          );

                          // Show loading indicator for 2 seconds
                          await Future.delayed(const Duration(seconds: 5));

                          // // // After loading, show snackbar
                          // // ignore: use_build_context_synchronously
                          // ScaffoldMessenger.of(context).showSnackBar(
                          //   const SnackBar(
                          //     content: Text(
                          //       'Congratulations! You are now an EmCall user.',
                          //       textAlign: TextAlign.center,
                          //     ),
                          //     duration: Duration(
                          //         seconds: 3), // Duration for the snackbar
                          //   ),
                          // );

                          // Navigate to SuccessPage after loading
                          Navigator.pushReplacement(
                            // ignore: use_build_context_synchronously
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SuccessPage()),
                          );

                          // Stop loading
                          setState(() {
                            isLoading = false; // Reset loading state
                          });
                        }
                      },
                      child: const Text(
                        'Sign Up',
                        style: TextStyle(color: Colors.white), // White text
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),
                ],
              ),
            ),
            // Center the loading indicator
            if (isLoading)
              const Align(
                alignment: Alignment.center,
                child: CircularProgressIndicator(
                  color: Colors.redAccent,
                ), // Show loading spinner
              ),
          ],
        ),
      ),
    );
  }

  void incrementNotificationCount() {}
}
