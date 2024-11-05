// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'dart:io';
import 'package:emcall/profiles/profile_page.dart';
import 'package:emcall/theme/theme_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  EditProfilePageState createState() => EditProfilePageState();
}

class EditProfilePageState extends State<EditProfilePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  File? _imageFile; // To store the selected profile image
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _birthdayController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final bool _isProfileUpdated = false; // Flag to track profile update status
  bool _obscureText = true; // For showing/hiding password

  final List<String> _genderOptions = ['Male', 'Female', 'Other'];
  String? _selectedGender;

  Future<void> _pickProfile(ImageSource source) async {
    try {
      final pickedFile = await ImagePicker().pickImage(source: source);
      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path);
        });
      } else {
        // Optionally handle the case when no image is selected
        if (kDebugMode) {
          print('No image selected.');
        }
      }
    } catch (e) {
      // Handle errors (e.g., permissions, etc.)
      if (kDebugMode) {
        print('Error picking image: $e');
      }
    }
  }

  // Function to show date picker and set selected date
  Future<void> _selectBirthday(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      setState(() {
        _birthdayController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
      });
    }
  }

// Function to handle form submission
  void _submitForm() async {
    if (_formKey.currentState!.validate() && _imageFile != null) {
      // Show loading dialog
      showDialog(
        context: context,
        barrierDismissible: false, // Prevent dismissal by tapping outside
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.redAccent,
            ), // Show a loading spinner
          );
        },
      );

      // Simulate a network request or processing
      bool success = await _performNetworkRequest();

      // Close the loading dialog
      Navigator.of(context).pop(); // Close the loading dialog

      if (success) {
        // Navigate to ProfilePage after successful update
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ProfilePage()),
        );

        // Optionally show a success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully.')),
        );
      } else {
        // Handle failure (e.g., show an error message)
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to update profile.')),
        );
      }
    } else if (_imageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a profile image.')),
      );
    }
  }

// Simulated network request function
  Future<bool> _performNetworkRequest() async {
    // Simulating a network delay (replace with actual API call)
    await Future.delayed(const Duration(seconds: 3)); // Simulate network delay
    // Return true to indicate success; change to false to simulate failure
    return true; // Simulate success
  }

  // Function to handle showing the confirmation dialog
  Future<bool> _showExitConfirmationDialog() async {
    final theme = Theme.of(context); // Access the current theme
    return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8), // Add border radius
            ),
            backgroundColor: theme
                .dialogBackgroundColor, // Match dialog background with theme

            title: Text(
              'Discard Changes?',
              style: TextStyle(
                color: theme.brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black, // Change color based on theme
                fontSize: 20,
              ),
            ),
            content: Text(
              'Are you sure you want to discard changes?',
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
                  Navigator.of(context).pop(false); // Stay on the page
                },
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    color: theme.brightness == Brightness.dark
                        ? Colors.white
                        : Colors.black, // Adjust button text color with theme
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true); // Exit the page
                },
                child: const Text(
                  'Yes',
                  style: TextStyle(color: Colors.redAccent),
                ),
              ),
            ],
          ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return WillPopScope(
      onWillPop: () async {
        // Show confirmation dialog when trying to navigate back, unless the profile was updated
        if (!_isProfileUpdated) {
          final shouldPop = await _showExitConfirmationDialog();
          return shouldPop;
        }
        return false; // Allow pop if profile is updated
      },
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: theme.appBarTheme.backgroundColor,
          foregroundColor: theme.appBarTheme.foregroundColor,
          title: Text(
            'Edit Profiles',
            style: theme.textTheme.headlineMedium,
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.red,
                          backgroundImage: _imageFile != null
                              ? FileImage(_imageFile!)
                              : const AssetImage('assets/jun.png'),
                        ),
                        Positioned(
                          bottom: 1,
                          right: 1,
                          child: SizedBox(
                            height: 24,
                            width: 24,
                            child: FloatingActionButton(
                              onPressed: () {
                                showModalBottomSheet(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        ListTile(
                                          leading:
                                              const Icon(Icons.photo_library),
                                          title:
                                              const Text('Choose from Gallery'),
                                          onTap: () {
                                            Navigator.pop(context);
                                            _pickProfile(ImageSource.gallery);
                                          },
                                        ),
                                        ListTile(
                                          leading: const Icon(Icons.camera_alt),
                                          title: const Text('Take a Photo'),
                                          onTap: () {
                                            Navigator.pop(context);
                                            _pickProfile(ImageSource.camera);
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              backgroundColor: Colors.red,
                              mini: true,
                              child: const Icon(
                                Icons.camera_alt_rounded,
                                size: 16,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Full Name
                  TextFormField(
                    controller: _fullNameController,
                    decoration: const InputDecoration(
                      labelText: 'Full Name',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your full name.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Birthday
                  TextFormField(
                    controller: _birthdayController,
                    readOnly: true,
                    decoration: const InputDecoration(
                      labelText: 'Birthday',
                      suffixIcon: Icon(Icons.calendar_today),
                      border: OutlineInputBorder(),
                    ),
                    onTap: () => _selectBirthday(context),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select your birthday.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Gender Dropdown
                  DropdownButtonFormField<String>(
                    value: _selectedGender,
                    onChanged: (newValue) {
                      setState(() {
                        _selectedGender = newValue;
                        _genderController.text = newValue ?? '';
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'Gender',
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
                    items: _genderOptions.map((gender) {
                      return DropdownMenuItem(
                        value: gender,
                        child: Text(
                          gender,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      );
                    }).toList(),
                    validator: (value) {
                      if (value == null) {
                        return 'Please select your gender.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Phone Number
                  IntlPhoneField(
                    controller: _phoneController,
                    decoration: const InputDecoration(
                      labelText: 'Phone Number',
                      border: OutlineInputBorder(),
                    ),
                    initialCountryCode: 'PH',
                    validator: (value) {
                      if (value == null || value.number.isEmpty) {
                        return 'Please enter your phone number.';
                      }
                      return null;
                    },
                    onChanged: (phone) {},
                  ),
                  const SizedBox(height: 16),
                  // Password input with visibility toggle
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _obscureText,
                    keyboardType: TextInputType.visiblePassword,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      labelStyle:
                          Theme.of(context).inputDecorationTheme.labelStyle,
                      floatingLabelBehavior: Theme.of(context)
                          .inputDecorationTheme
                          .floatingLabelBehavior,
                      border: Theme.of(context).inputDecorationTheme.border,
                      enabledBorder:
                          Theme.of(context).inputDecorationTheme.enabledBorder,
                      focusedBorder:
                          Theme.of(context).inputDecorationTheme.focusedBorder,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureText
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color:
                              ThemeManager.iconColor, // Use custom icon color
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password.';
                      } else if (value.length < 8) {
                        return 'Password must be at least 6 characters long.';
                      } else if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]')
                          .hasMatch(value)) {
                        return 'Password must contain at least one symbol.';
                      } else if (!RegExp(r'[0-9]').hasMatch(value)) {
                        return 'Password must contain at least one number.';
                      } else if (!RegExp(r'[A-Z]').hasMatch(value)) {
                        return 'Password must contain at least one uppercase letter.';
                      } else if (!RegExp(r'[a-z]').hasMatch(value)) {
                        return 'Password must contain at least one lowercase letter.';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 30),
                  // Save Changes Button
                  Center(
                    child: ElevatedButton(
                      onPressed: _submitForm,
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.redAccent, // Text color
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              10.0), // Adjust the radius as needed
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 16.0,
                            horizontal: 32.0), // Adjust padding if needed
                      ),
                      child: const Text(
                        'Save Changes',
                        style: TextStyle(
                          fontSize: 16, // Adjust font size if needed
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
