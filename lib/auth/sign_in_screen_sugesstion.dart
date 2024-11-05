// ignore_for_file: use_build_context_synchronously

import 'package:emcall/bottom_navigation/pages.dart';
import 'package:emcall/auth/sign_up_screen_suggestion.dart';
import 'package:emcall/services/notification.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../theme/theme_manager.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>(); // Form key for validation
  bool _obscureText = true; // For showing/hiding password
  String? _phoneNumber;
  bool _isLoading = false; // Loading state

  // Controllers for phone number and password fields
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _checkIfLoggedIn(); // Check login status on app start
  }

  // Check if the user is already signed in
  Future<void> _checkIfLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    bool? isLoggedIn = prefs.getBool('isLoggedIn'); // Retrieve login state

    if (isLoggedIn == true) {
      // Redirect to the homepage
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) =>
                ShowCaseWidget(builder: (context) => const Pages())),
      );
    }
  }

  // Save login state in SharedPreferences
  Future<void> _saveLoginState() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true); // Save login status
  }

  // Function to sign in user
  Future<void> signIn() async {
    setState(() {
      _isLoading = true; // Start loading
    });

    final supabase = Supabase.instance.client;

    // Fetch user information based on phone number and password
    final response = await supabase
        .from('users')
        .select()
        .eq('phone_number', _phoneController.text)
        .eq('password', _passwordController.text)
        .single();

    if (response.isEmpty) {
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
                  'Login Failed!',
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
      // User found; extract user data
      final userData = response; // Assuming the first item is the user
      String fullName = userData['full_name'];
      String phoneNumber = userData['phone_number'];
      String profileImage = userData['profile_image'];

      // Save login state and user data
      await _saveLoginState();
      await _saveUserData(fullName, phoneNumber, profileImage);

      NotificationService.showInstantNotification(
          "Login Success", "Welcome back!");

      // Navigate to the appropriate screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) =>
              ShowCaseWidget(builder: (context) => const Pages()),
        ),
      );
    }

    setState(() {
      _isLoading = false; // Stop loading
    });
  }

// Save user data method
  Future<void> _saveUserData(
      String fullName, String phoneNumber, String profileImage) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('fullName', fullName);
    await prefs.setString('phoneNumber', phoneNumber);
    await prefs.setString('profileImage', profileImage);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey, // Assign form key
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 60),
                  // // Image at the top
                  Image.asset(
                    'assets/splash.png', // Replace with your actual image path
                    height: 80, // Set the desired height
                  ),
                  const SizedBox(height: 15),
                  // Title
                  Text(
                    AppLocalizations.of(context)!.signin,
                    style: theme.textTheme.headlineLarge,
                  ),
                  const SizedBox(height: 10),
                  // Subtitle
                  Text(
                    AppLocalizations.of(context)!.subTitle,
                    style: theme.textTheme.titleMedium,
                  ),
                  const SizedBox(height: 60),

                  // Phone number input with custom validator
                  FormField<String>(
                    builder: (state) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          IntlPhoneField(
                            controller: _phoneController,
                            decoration: InputDecoration(
                              labelText: AppLocalizations.of(context)!
                                  .labelPhoneNumber,
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
                            initialCountryCode: 'PH',
                            onChanged: (phone) {
                              _phoneNumber = phone.completeNumber;
                              state.didChange(phone
                                  .completeNumber); // Update the form state
                            },
                          ),
                          if (state.hasError)
                            Padding(
                              padding: const EdgeInsets.only(top: 5.0),
                              child: Text(
                                state.errorText!,
                                style: const TextStyle(
                                  color: Color.fromARGB(255, 255, 200, 196),
                                  fontSize: 12,
                                ),
                              ),
                            ),
                        ],
                      );
                    },
                    validator: (value) {
                      if (_phoneNumber == null || _phoneNumber!.isEmpty) {
                        return AppLocalizations.of(context)!.validatorPhoneNone;
                      } else if (_phoneNumber!.length < 10 ||
                          _phoneNumber!.length > 14) {
                        return AppLocalizations.of(context)!
                            .validatorPhoneInvalid;
                      }
                      return null; // No error
                    },
                  ),

                  const SizedBox(height: 20),
                  // Password input with visibility toggle
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _obscureText,
                    keyboardType: TextInputType.visiblePassword,
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.labelPassword,
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
                        return AppLocalizations.of(context)!.validatorPassNone;
                      } else if (value.length < 8) {
                        return AppLocalizations.of(context)!.validatorPass6cha;
                      } else if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]')
                          .hasMatch(value)) {
                        return AppLocalizations.of(context)!
                            .validatorPassSymbol;
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

                  const SizedBox(height: 10),

                  // Forgot Password Button
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        _showForgotPasswordDialog(context);
                      },
                      child: Text(
                        AppLocalizations.of(context)!.forgotPassword,
                      ),
                    ),
                  ),
                  const SizedBox(height: 50),

                  // Sign In Button
                  Center(
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            _isLoading = true; // Start loading
                          });

                          await Future.delayed(const Duration(seconds: 0));
                          await signIn(); // Save login state

                          setState(() {
                            _isLoading = false;

                            if (kDebugMode) {
                              print('Phone Number: $_phoneNumber');
                              print('Password: ${_passwordController.text}');
                            }
                          });
                        }
                      },
                      child: Text(
                        AppLocalizations.of(context)!.signin,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 50),

                  // Don't have an account? Sign up
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(AppLocalizations.of(context)!.dontHaveAccount,
                          style: Theme.of(context).textTheme.bodyMedium),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SignUpScreen()),
                          );
                        },
                        child: Text(
                          AppLocalizations.of(context)!.signup,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(
                color: Colors.redAccent,
              ),
            ),
        ],
      ),
    );
  }
}

// Method to show the Forgot Password dialog box
void _showForgotPasswordDialog(BuildContext context) {
  String? forgotPhoneNumber;
  List<String> verificationCodeDigits =
      List.filled(6, ''); // List to hold each digit of the code
  bool codeSent = false; // Tracks if the code has been sent
  bool isPhoneNumberComplete = false; // Tracks if phone number input is valid
  bool isVerificationCodeComplete =
      false; // Tracks if verification code input is valid

  // Text editing controller to retain the phone number input
  TextEditingController phoneNumberController = TextEditingController();
  final theme = Theme.of(context); // Access the current theme

  showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            title: Text(
              codeSent
                  ? AppLocalizations.of(context)!.verificationCode
                  : AppLocalizations.of(context)!.forgotPass,
              style: TextStyle(
                color: theme.brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black, // Change color based on theme
                fontSize: 20,
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (!codeSent)
                  // Show phone number field before sending the code
                  IntlPhoneField(
                    controller: phoneNumberController, // Use the controller
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.labelPhoneNumber,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        // Change color when focused
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                            color: Colors.red), // Focused border color
                      ),
                    ),
                    initialCountryCode: 'PH',
                    onChanged: (phone) {
                      forgotPhoneNumber = phone.completeNumber;
                      setState(() {
                        isPhoneNumberComplete = phone.completeNumber.length >=
                            13; // Adjust the length as needed
                      });
                    },
                  )
                else
                  // Show separate digit input fields for verification code
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(6, (index) {
                      return SizedBox(
                        width: 40, // Set width for each digit box
                        child: TextFormField(
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.number,
                          maxLength: 1, // Limit to 1 character per field
                          decoration: InputDecoration(
                            counterText: '', // Hide the character counter
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(color: Colors.grey),
                            ),
                            focusedBorder: OutlineInputBorder(
                              // Change color when focused
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                  color: Colors.red), // Focused border color
                            ),
                          ),
                          initialValue: verificationCodeDigits[index],
                          onChanged: (value) {
                            setState(() {
                              if (value.isNotEmpty) {
                                verificationCodeDigits[index] =
                                    value; // Store the digit
                              } else {
                                verificationCodeDigits[index] =
                                    ''; // Clear the digit if input is empty
                              }
                              // Check if all digits are entered (verification code is complete)
                              isVerificationCodeComplete =
                                  verificationCodeDigits
                                      .every((digit) => digit.isNotEmpty);
                            });
                            // Move focus to the next field automatically
                            if (value.isNotEmpty && index < 5) {
                              FocusScope.of(context).nextFocus();
                            }
                          },
                        ),
                      );
                    }),
                  ),
              ],
            ),
            actions: [
              if (!codeSent)
                // Show Send Code button if code has not been sent yet, and disable if phone number is not complete
                TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: isPhoneNumberComplete
                        ? Colors.redAccent
                        : Colors.grey, // Change text color based on the state
                  ),
                  onPressed: isPhoneNumberComplete
                      ? () {
                          setState(() {
                            codeSent = true; // Code sent, switch to code input
                          });
                          // Logic to send the code to the phone number
                          forgotPhoneNumber = phoneNumberController.text;
                          if (kDebugMode) {
                            print('Code sent to $forgotPhoneNumber');
                          }
                        }
                      : null, // Disable button if the phone number is incomplete
                  child: Text(
                    AppLocalizations.of(context)!.sendCode,
                  ),
                )
              else
                // Show OK button after code is sent and enable it only if the verification code input is complete
                TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: isVerificationCodeComplete
                        ? Colors.redAccent
                        : Colors.grey, // Change text color based on the state
                  ),
                  onPressed: isVerificationCodeComplete
                      ? () {
                          // Combine all digits
                          String verificationCode =
                              verificationCodeDigits.join('');
                          // Logic to verify the entered code
                          Navigator.of(context)
                              .pop(); // Close the current dialog
                          if (kDebugMode) {
                            print('Verification Code: $verificationCode');
                          }
                          // Show the dialog for entering the new password
                          _showNewPasswordDialog(context);
                        }
                      : null, // Disable button if the verification code is incomplete
                  child: Text(AppLocalizations.of(context)!.ok),
                ),
              // Show Cancel button when phone number input is active, or Back when code input is active
              TextButton(
                onPressed: () {
                  setState(() {
                    if (codeSent) {
                      codeSent = false; // Go back to phone number input
                    } else {
                      Navigator.of(context).pop(); // Close the dialog
                    }
                  });
                },
                child: Text(
                  codeSent
                      ? AppLocalizations.of(context)!.back
                      : AppLocalizations.of(context)!.cancel,
                  style: const TextStyle(color: Colors.redAccent),
                ),
              ),
            ],
          );
        },
      );
    },
  );
}

// Function to show the new password entry dialog
void _showNewPasswordDialog(BuildContext context) {
  TextEditingController newPasswordController = TextEditingController();
  bool isPasswordVisible = false; // Track visibility of the password
  bool isLoading = false; // Track loading state
  final theme = Theme.of(context); // Access the current theme

  showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            title: Text(
              AppLocalizations.of(context)!.setNewPassword,
              style: TextStyle(
                color: theme.brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black, // Change color based on theme
                fontSize: 20,
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: newPasswordController,
                  obscureText: !isPasswordVisible,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.newPassword,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Colors.red),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          isPasswordVisible =
                              !isPasswordVisible; // Toggle visibility
                        });
                      },
                    ),
                  ),
                ),
                if (isLoading) // Show loading indicator if in loading state
                  const Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: Center(
                        child: CircularProgressIndicator(
                      color: Colors.redAccent,
                    )),
                  ),
              ],
            ),
            actions: [
              TextButton(
                style: TextButton.styleFrom(
                  foregroundColor:
                      newPasswordController.text.length >= 6 && !isLoading
                          ? Colors.redAccent
                          : Colors.grey, // Change text color based on the state
                ),
                onPressed: newPasswordController.text.length >= 6 && !isLoading
                    ? () {
                        setState(() {
                          isLoading = true; // Start loading
                        });

                        // Simulate a delay (e.g., for a network request)
                        Future.delayed(const Duration(seconds: 2), () {
                          String newPassword = newPasswordController.text;

                          Navigator.of(context).pop(); // Close the dialog
                          setState(() {
                            isLoading = false; // Stop loading
                          });
                          if (kDebugMode) {
                            print('New Password: $newPassword');
                          }
                        });
                      }
                    : null, // Disable button if the input is not valid or loading
                child: Text(
                  AppLocalizations.of(context)!.save,
                ),
              ),
            ],
          );
        },
      );
    },
  );
}
