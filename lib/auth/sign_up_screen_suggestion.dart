// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:emcall/auth/sign_in_screen_sugesstion.dart';
import 'package:emcall/auth/terms_and_privacy_sheet.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:emcall/auth/verification_screen.dart';
import 'package:intl/intl.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  SignUpScreenState createState() => SignUpScreenState();
}

class SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  File? _imageFile; // To store the selected image
  bool _obscureText = true; // For showing/hiding PIN code
  bool _isAgreed = false; // To manage checkbox state
  bool isLoading = false;

  // Controllers for text fields
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _birthdayController =
      TextEditingController(); // Birthday instead of age
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _phoneController =
      TextEditingController(); // Phone number instead of email
  final TextEditingController _passwordController =
      TextEditingController(); // Password instead of PIN
  final TextEditingController _confirmPasswordController =
      TextEditingController(); // Confirm Password

  @override
  void dispose() {
    _fullNameController.dispose();
    _birthdayController.dispose();
    _genderController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // Gender options
  final List<String> _genderOptions = ['Lalaki', 'Babae', 'Bakla', 'Tumboy'];
  String? _selectedGender; // To hold the selected gender

  // Function to pick an image from the gallery or camera
  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  // Function to show date picker and set selected date
  Future<void> _selectBirthday(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900), // Set a reasonable first date
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      setState(() {
        // Format date as 'EEEE, d MMMM yyyy' (e.g., 'Sunday, 29 September 2024')
        _birthdayController.text =
            DateFormat('EEEE, d MMMM yyyy').format(pickedDate);
      });
    }
  }

  Future<void> saveUserData() async {
    // Get the Supabase client
    final supabase = Supabase.instance.client;

    // Prepare user data
    final Map<String, dynamic> userData = {
      'full_name': _fullNameController.text,
      'phone_number': _phoneController.text,
      'password': _passwordController.text,
      'birthday': _birthdayController.text,
      'gender': _selectedGender,
      'profile_image':
          _imageFile != null ? await _uploadImage(_imageFile!) : null,
    };

    // Insert data into Supabase
    final response = await supabase.from('users').insert(userData);

    if (response != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.redAccent,
          content: Row(
            children: [
              const Icon(
                Icons.warning_rounded, // You can use any icon here
                color: Colors.white,
              ),
              const SizedBox(
                  width: 8), // Add some space between the icon and text
              Expanded(
                child: Text(
                  'Initial data failed to save!',
                  style: TextStyle(
                    fontSize: 20,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.greenAccent,
          content: Row(
            children: [
              const Icon(
                Icons.save_rounded, // You can use any icon here
                color: Colors.white,
              ),
              const SizedBox(
                  width: 8), // Add some space between the icon and text
              Expanded(
                child: Text(
                  'Initial data saved',
                  style: TextStyle(
                    fontSize: 20,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
      );

      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const VerificationScreen()));
    }
  }

// Function to upload image to Supabase Storage and return the public URL
  Future<String?> _uploadImage(File imageFile) async {
    final supabase = Supabase.instance.client;

    final path = 'profile_images/${DateTime.now().millisecondsSinceEpoch}.png';
    final response = await supabase.storage
        .from('profile_image_bucket')
        .upload(path, imageFile);

    if (response.isNotEmpty) {
      // Directly get the public URL without requiring a token
      final imageUrl =
          supabase.storage.from('profile_image_bucket').getPublicUrl(path);
      return imageUrl; // Save this URL in your database
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Image upload failed')),
      );
      return null;
    }
  }

  // Function to handle form submission
  void _submitForm() async {
    if (_formKey.currentState!.validate() && _imageFile != null && _isAgreed) {
      setState(() {
        isLoading = true; // Start loading
      });
      // Save user data to Supabase
      await saveUserData();

      setState(() {
        isLoading = false; // Stop loading
      });

// Proceed to VerificationScreen
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const VerificationScreen()),
      );
    } else if (_imageFile == null) {
      // Show error if image is not selected
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an image.')),
      );
    } else if (!_isAgreed) {
      // Show error if terms are not agreed to
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You must agree to the terms.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      resizeToAvoidBottomInset: true, // Adjust the screen when keyboard shows
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 40), // Adjusting top padding
                // CircleAvatar with Image Picker functionality
                GestureDetector(
                  onTap: () {
                    // Show dialog to choose between camera and gallery
                    showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ListTile(
                              leading: const Icon(Icons.photo_library),
                              title: const Text('Choose from Gallery'),
                              onTap: () {
                                Navigator.pop(context);
                                _pickImage(ImageSource.gallery);
                              },
                            ),
                            ListTile(
                              leading: const Icon(Icons.camera_alt),
                              title: const Text('Take a Photo'),
                              onTap: () {
                                Navigator.pop(context);
                                _pickImage(ImageSource.camera);
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.redAccent,
                    backgroundImage:
                        _imageFile != null ? FileImage(_imageFile!) : null,
                    child: _imageFile == null
                        ? const Icon(Icons.camera_alt,
                            color: Colors.white, size: 50)
                        : null, // Show the camera icon if no image is selected
                  ),
                ),
                const SizedBox(height: 20),
                // Full Name
                TextFormField(
                  controller: _fullNameController,
                  decoration: InputDecoration(
                    labelText: 'Full Name',
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
                      return 'Please enter your full name.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                // Birthday
                TextFormField(
                  controller: _birthdayController,
                  readOnly: true, // Make it read-only to prevent manual input
                  decoration: InputDecoration(
                    labelText: 'Birthday',
                    suffixIcon:
                        const Icon(Icons.calendar_today), // Calendar icon
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
                  onTap: () =>
                      _selectBirthday(context), // Show date picker on tap
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select your birthday.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                // Gender Dropdown
                DropdownButtonFormField<String>(
                  value: _selectedGender,
                  onChanged: (newValue) {
                    setState(() {
                      _selectedGender = newValue; // Update selected gender
                      _genderController.text =
                          newValue ?? ''; // Update controller text
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
                const SizedBox(height: 20),
                // Phone number
                IntlPhoneField(
                  obscureText: _obscureText,
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    labelText: 'Phone Number',
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
                  initialCountryCode:
                      'PH', // Set the initial country code (e.g., Philippines)
                  validator: (value) {
                    if (value == null || value.number.isEmpty) {
                      return 'Please enter your phone number.';
                    }
                    return null; // No validation error
                  },
                  onChanged: (phone) {
                    // This callback will be called whenever the phone number changes
                    if (kDebugMode) {
                      print(phone.completeNumber);
                    } // You can access the complete number with country code
                  },
                ),

                const SizedBox(height: 20),
                // Password
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscureText,
                  decoration: InputDecoration(
                    labelText: 'Password',
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

                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureText ? Icons.visibility : Icons.visibility_off,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureText =
                              !_obscureText; // Toggle password visibility
                        });
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppLocalizations.of(context)!.validatorPassNone;
                    } else if (value.length < 8) {
                      return AppLocalizations.of(context)!.validatorPass6cha;
                    } else if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]')
                        .hasMatch(value)) {
                      return AppLocalizations.of(context)!.validatorPassSymbol;
                    } else if (!RegExp(r'[0-9]').hasMatch(value)) {
                      return AppLocalizations.of(context)!.validatorPassNum;
                    } else if (!RegExp(r'[A-Z]').hasMatch(value)) {
                      return AppLocalizations.of(context)!
                          .validatorPassLowercase;
                    } else if (!RegExp(r'[a-z]').hasMatch(value)) {
                      return AppLocalizations.of(context)!
                          .validatorPassUppercase;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                // Confirm Password
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: _obscureText,
                  decoration: InputDecoration(
                    labelText: 'Confirm Password',
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
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureText ? Icons.visibility : Icons.visibility_off,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureText =
                              !_obscureText; // Toggle password visibility
                        });
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please confirm your password.';
                    }
                    if (value != _passwordController.text) {
                      return 'Passwords do not match.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Terms and Privacy Policy
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 0),
                  child: Row(
                    children: [
                      Checkbox(
                        value: _isAgreed,
                        onChanged: (value) {
                          setState(() {
                            _isAgreed = value ?? false; // Update checkbox state
                          });
                        },
                      ),
                      Expanded(
                        child: Wrap(
                          children: [
                            const Text('I agree to the '),
                            GestureDetector(
                              onTap: () {
                                showModalBottomSheet(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return const TermsAndPrivacySheet();
                                  },
                                );
                              },
                              child: const Text('Terms of Service',
                                  style: TextStyle(color: Colors.red)),
                            ),
                            const Text(' and '),
                            GestureDetector(
                              onTap: () {
                                showModalBottomSheet(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return const TermsAndPrivacySheet();
                                  },
                                );
                              },
                              child: const Text('Privacy Policy',
                                  style: TextStyle(color: Colors.red)),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),
                // Continue Button
                Center(
                  child: isLoading // Show loading indicator if loading is true
                      ? const CircularProgressIndicator(
                          color: Colors.redAccent,
                        )
                      : ElevatedButton(
                          onPressed: _submitForm, // Call the submit function
                          child: const Text('Continue',
                              style: TextStyle(color: Colors.white)),
                        ),
                ),

                const SizedBox(height: 20),
                // Don't have an account? Sign up
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Already have an account? ',
                        style: Theme.of(context).textTheme.bodyMedium),
                    TextButton(
                      onPressed: () {
                        // Navigate to sign up screen
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SignInScreen()),
                        );
                      },
                      child: const Text(
                        'Sign In',
                        style: TextStyle(color: Colors.red), // Red text color
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
