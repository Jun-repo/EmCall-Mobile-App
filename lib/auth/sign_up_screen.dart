import 'dart:io';
import 'package:emcall/auth/sign_in_screen_sugesstion.dart';
import 'package:emcall/auth/terms_and_privacy_sheet.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:emcall/auth/verification_screen.dart';
import 'package:intl/intl.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

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

  // Controllers for text fields
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _birthdayController =
      TextEditingController(); // Birthday instead of age
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _phoneController =
      TextEditingController(); // Phone number instead of email
  final TextEditingController _pinController =
      TextEditingController(); // PIN code instead of password

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

  // Function to handle form submission
  void _submitForm() {
    if (_formKey.currentState!.validate() && _imageFile != null && _isAgreed) {
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
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
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
                    backgroundColor: Colors.red,
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
                  decoration: const InputDecoration(
                    labelText: 'Full Name',
                    labelStyle:
                        TextStyle(color: Colors.grey), // Customize label style
                    floatingLabelBehavior: FloatingLabelBehavior
                        .auto, // Make label float when focused
                    border: UnderlineInputBorder(), // Line style border
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors
                              .white), // Color when enabled but not focused
                    ),
                    focusedBorder: UnderlineInputBorder(
                      // Change color when focused
                      borderSide:
                          BorderSide(color: Colors.red), // Focused border color
                    ),
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
                  decoration: const InputDecoration(
                    labelText: 'Birthday',
                    suffixIcon: Icon(Icons.calendar_today), // Calendar icon
                    labelStyle:
                        TextStyle(color: Colors.grey), // Customize label style
                    floatingLabelBehavior: FloatingLabelBehavior
                        .auto, // Make label float when focused
                    border: UnderlineInputBorder(), // Line style border
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors
                              .white), // Color when enabled but not focused
                    ),
                    focusedBorder: UnderlineInputBorder(
                      // Change color when focused
                      borderSide:
                          BorderSide(color: Colors.red), // Focused border color
                    ),
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
                  decoration: const InputDecoration(
                    labelText: 'Gender',
                    labelStyle:
                        TextStyle(color: Colors.grey), // Customize label style
                    floatingLabelBehavior: FloatingLabelBehavior
                        .auto, // Make label float when focused
                    border: UnderlineInputBorder(), // Line style border
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors
                              .white), // Color when enabled but not focused
                    ),
                    focusedBorder: UnderlineInputBorder(
                      // Change color when focused
                      borderSide:
                          BorderSide(color: Colors.red), // Focused border color
                    ),
                  ),
                  items: _genderOptions.map((gender) {
                    return DropdownMenuItem(
                      value: gender,
                      child: Text(gender),
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
                  decoration: const InputDecoration(
                    labelText: 'Phone Number',
                    labelStyle:
                        TextStyle(color: Colors.grey), // Customize label style
                    floatingLabelBehavior: FloatingLabelBehavior
                        .auto, // Make label float when focused
                    border: UnderlineInputBorder(), // Line style border
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors
                              .white), // Color when enabled but not focused
                    ),
                    focusedBorder: UnderlineInputBorder(
                      // Change color when focused
                      borderSide:
                          BorderSide(color: Colors.red), // Focused border color
                    ),
                    // Additional styling
                    hintStyle: TextStyle(color: Colors.grey), // Hint text color
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
                // PIN Code
                TextFormField(
                  controller: _pinController,
                  obscureText: _obscureText, // Toggle obscure text
                  decoration: InputDecoration(
                    labelText: 'PIN Code',
                    labelStyle: const TextStyle(
                        color: Colors.grey), // Customize label style
                    floatingLabelBehavior: FloatingLabelBehavior
                        .auto, // Make label float when focused
                    border: const UnderlineInputBorder(), // Line style border
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors
                              .white), // Color when enabled but not focused
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      // Change color when focused
                      borderSide:
                          BorderSide(color: Colors.red), // Focused border color
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureText
                            ? Icons.visibility
                            : Icons.visibility_off, // Toggle icon
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText; // Toggle obscure text
                        });
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your PIN code.';
                    } else if (value.length < 4) {
                      return 'PIN code must be at least 4 digits.';
                    } else if (value.length > 4) {
                      return 'PIN code required only 4 digits.';
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
                ElevatedButton(
                  onPressed: _submitForm, // Call the submit function
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 15),
                    backgroundColor: Colors.red,
                  ),
                  child: const Text('Continue',
                      style: TextStyle(color: Colors.white)),
                ),
                const SizedBox(height: 20),
                // Don't have an account? Sign up
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Already have an account? ',
                      style: TextStyle(
                          color: Colors.white70), // White text with opacity
                    ),
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
