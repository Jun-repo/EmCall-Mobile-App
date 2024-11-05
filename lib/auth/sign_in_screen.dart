// import 'package:emcall/bottom_navigation/pages.dart';
// import 'package:emcall/auth/sign_up_screen.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:intl_phone_field/intl_phone_field.dart';

// class SignInScreen extends StatefulWidget {
//   const SignInScreen({super.key});

//   @override
//   State<SignInScreen> createState() => _SignInScreenState();
// }

// class _SignInScreenState extends State<SignInScreen> {
//   final _formKey = GlobalKey<FormState>(); // Form key for validation
//   bool _obscureText = true; // For showing/hiding PIN
//   String? _phoneNumber;
//   String? _pinCode;
//   bool _isLoading = false; // Loading state

// // Controllers for phonenumber and input fields
//   final TextEditingController _phoneController = TextEditingController();
//   final TextEditingController _pinController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFF121212),
//       body: Stack(
//         children: [
//           SingleChildScrollView(
//             padding: const EdgeInsets.all(20.0),
//             child: Form(
//               key: _formKey, // Assign form key
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const SizedBox(height: 120),
//                   // Title
//                   const Text(
//                     'Sign In',
//                     style: TextStyle(
//                       fontSize: 28,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.white,
//                     ),
//                   ),
//                   const SizedBox(height: 10),
//                   // Subtitle
//                   const Text(
//                     'Hi there! Nice to see you again.',
//                     style: TextStyle(fontSize: 16, color: Colors.white70),
//                   ),
//                   const SizedBox(height: 60),

//                   // Phone number input with custom validator
//                   FormField<String>(
//                     builder: (state) {
//                       return Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           IntlPhoneField(
//                             controller: _phoneController,
//                             decoration: InputDecoration(
//                               labelText: 'Phone Number',
//                               labelStyle: const TextStyle(color: Colors.grey),
//                               floatingLabelBehavior: FloatingLabelBehavior.auto,
//                               border: OutlineInputBorder(
//                                 borderSide:
//                                     const BorderSide(color: Colors.grey),
//                                 borderRadius: BorderRadius.circular(16),
//                               ),
//                               enabledBorder: OutlineInputBorder(
//                                 borderSide:
//                                     const BorderSide(color: Colors.white),
//                                 borderRadius: BorderRadius.circular(16),
//                               ),
//                               focusedBorder: OutlineInputBorder(
//                                 borderSide: const BorderSide(color: Colors.red),
//                                 borderRadius: BorderRadius.circular(16),
//                               ),
//                               hintStyle: const TextStyle(color: Colors.grey),
//                             ),
//                             initialCountryCode: 'PH',
//                             onChanged: (phone) {
//                               _phoneNumber = phone.completeNumber;
//                               state.didChange(phone
//                                   .completeNumber); // Update the form state
//                             },
//                           ),
//                           if (state.hasError)
//                             Padding(
//                               padding: const EdgeInsets.only(top: 5.0),
//                               child: Text(
//                                 state.errorText!,
//                                 style: const TextStyle(
//                                     color: Color.fromARGB(255, 255, 200, 196),
//                                     fontSize: 12),
//                               ),
//                             ),
//                         ],
//                       );
//                     },
//                     validator: (value) {
//                       if (_phoneNumber == null || _phoneNumber!.isEmpty) {
//                         return 'Please enter your phone number.';
//                       } else if (_phoneNumber!.length < 10 ||
//                           _phoneNumber!.length > 14) {
//                         return 'Please enter a valid phone number.';
//                       }
//                       return null; // No error
//                     },
//                   ),

//                   const SizedBox(height: 20),

//                   // PIN Code input with rectangle border
//                   TextFormField(
//                     controller: _pinController,
//                     obscureText: _obscureText,
//                     keyboardType: TextInputType.number,
//                     maxLength: 4,
//                     decoration: InputDecoration(
//                       labelText: 'PIN Code',
//                       labelStyle: const TextStyle(color: Colors.grey),
//                       floatingLabelBehavior: FloatingLabelBehavior.auto,
//                       border: OutlineInputBorder(
//                         borderSide: const BorderSide(color: Colors.grey),
//                         borderRadius: BorderRadius.circular(16),
//                       ),
//                       enabledBorder: OutlineInputBorder(
//                         borderSide: const BorderSide(color: Colors.white),
//                         borderRadius: BorderRadius.circular(16),
//                       ),
//                       focusedBorder: OutlineInputBorder(
//                         borderSide: const BorderSide(color: Colors.red),
//                         borderRadius: BorderRadius.circular(16),
//                       ),
//                       suffixIcon: IconButton(
//                         icon: Icon(
//                           _obscureText
//                               ? Icons.visibility
//                               : Icons.visibility_off,
//                           color: Colors.grey,
//                         ),
//                         onPressed: () {
//                           setState(() {
//                             _obscureText = !_obscureText;
//                           });
//                         },
//                       ),
//                     ),
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Please enter your PIN code.';
//                       } else if (value.length < 4) {
//                         return 'PIN code must be 4 digits.';
//                       }
//                       return null;
//                     },
//                   ),

//                   const SizedBox(height: 10),

//                   // Forgot PIN Button
//                   Align(
//                     alignment: Alignment.centerRight,
//                     child: TextButton(
//                       onPressed: () {
//                         _showForgotPinDialog(context);
//                       },
//                       child: const Text(
//                         'Forgot PIN?',
//                         style: TextStyle(color: Colors.white),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 50),
//                   // Sign In Button
//                   ElevatedButton(
//                     onPressed: () {
//                       if (_formKey.currentState!.validate()) {
//                         // Perform sign-in logic
//                         if (kDebugMode) {
//                           print("Phone Number: $_phoneNumber");
//                         }
//                         if (kDebugMode) {
//                           print("PIN Code: ${_pinController.text}");
//                         }
//                       }
//                       if (_formKey.currentState!.validate()) {
//                         setState(() {
//                           _isLoading = true; // Start loading
//                         });

//                         // Simulate a network request or loading process
//                         Future.delayed(const Duration(seconds: 3), () {
//                           setState(() {
//                             _isLoading = false; // Stop loading
//                           });

//                           Navigator.push(
//                             // ignore: use_build_context_synchronously
//                             context,
//                             MaterialPageRoute(
//                                 builder: (context) => const Pages()),
//                           );

//                           if (kDebugMode) {
//                             print('Phone Number: $_phoneNumber');
//                             print('PIN Code: $_pinCode');
//                           }
//                         });
//                       }
//                     },
//                     style: ElevatedButton.styleFrom(
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 50, vertical: 15),
//                       backgroundColor: Colors.red,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                     ),
//                     child: const Text(
//                       'Sign in',
//                       style: TextStyle(color: Colors.white),
//                     ),
//                   ),
//                   const SizedBox(height: 50),
//                   // Don't have an account? Sign up
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       const Text(
//                         'Don\'t have an account? ',
//                         style: TextStyle(color: Colors.white70),
//                       ),
//                       TextButton(
//                         onPressed: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                                 builder: (context) => const SignUpScreen()),
//                           );
//                         },
//                         child: const Text(
//                           'Sign Up',
//                           style: TextStyle(color: Colors.red),
//                         ),
//                       ),
//                       const SizedBox(height: 10),
//                     ],
//                   ),
//                   const SizedBox(height: 50),
//                 ],
//               ),
//             ),
//           ),
//           // Loading Indicator in the center of the screen
//           if (_isLoading)
//             const Center(
//               child: CircularProgressIndicator(
//                 color: Colors.redAccent,
//               ),
//             ),
//         ],
//       ),
//     );
//   }
// }

// // Method to show the Forgot PIN dialog box
// void _showForgotPinDialog(BuildContext context) {
//   String? forgotPhoneNumber;
//   List<String> verificationCodeDigits =
//       List.filled(6, ''); // List to hold each digit of the code
//   bool codeSent = false; // Tracks if the code has been sent
//   bool isPhoneNumberComplete = false; // Tracks if phone number input is valid
//   bool isVerificationCodeComplete =
//       false; // Tracks if verification code input is valid

//   // Text editing controller to retain the phone number input
//   TextEditingController phoneNumberController = TextEditingController();

//   showDialog(
//     context: context,
//     builder: (context) {
//       return StatefulBuilder(
//         builder: (context, setState) {
//           return AlertDialog(
//             backgroundColor: const Color(0xFF2C2C2C),
//             title: Text(codeSent ? 'Enter Verification Code' : 'Forgot PIN'),
//             content: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 if (!codeSent)
//                   // Show phone number field before sending the code
//                   IntlPhoneField(
//                     controller: phoneNumberController, // Use the controller
//                     decoration: InputDecoration(
//                       labelText: 'Phone Number',
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(8),
//                         borderSide: const BorderSide(color: Colors.grey),
//                       ),
//                       focusedBorder: OutlineInputBorder(
//                         // Change color when focused
//                         borderRadius: BorderRadius.circular(8),
//                         borderSide: const BorderSide(
//                             color: Colors.red), // Focused border color
//                       ),
//                     ),
//                     initialCountryCode: 'PH',
//                     onChanged: (phone) {
//                       forgotPhoneNumber = phone.completeNumber;
//                       setState(() {
//                         isPhoneNumberComplete = phone.completeNumber.length >=
//                             13; // Adjust the length as needed
//                       });
//                     },
//                   )
//                 else
//                   // Show separate digit input fields for verification code
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: List.generate(6, (index) {
//                       return SizedBox(
//                         width: 40, // Set width for each digit box
//                         child: TextFormField(
//                           textAlign: TextAlign.center,
//                           keyboardType: TextInputType.number,
//                           maxLength: 1, // Limit to 1 character per field
//                           decoration: InputDecoration(
//                             counterText: '', // Hide the character counter
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(8),
//                               borderSide: const BorderSide(color: Colors.grey),
//                             ),
//                             focusedBorder: OutlineInputBorder(
//                               // Change color when focused
//                               borderRadius: BorderRadius.circular(8),
//                               borderSide: const BorderSide(
//                                   color: Colors.red), // Focused border color
//                             ),
//                           ),
//                           initialValue: verificationCodeDigits[index],
//                           onChanged: (value) {
//                             setState(() {
//                               if (value.isNotEmpty) {
//                                 verificationCodeDigits[index] =
//                                     value; // Store the digit
//                               } else {
//                                 verificationCodeDigits[index] =
//                                     ''; // Clear the digit if input is empty
//                               }
//                               // Check if all digits are entered (verification code is complete)
//                               isVerificationCodeComplete =
//                                   verificationCodeDigits
//                                       .every((digit) => digit.isNotEmpty);
//                             });
//                             // Move focus to the next field automatically
//                             if (value.isNotEmpty && index < 5) {
//                               FocusScope.of(context).nextFocus();
//                             }
//                           },
//                         ),
//                       );
//                     }),
//                   ),
//               ],
//             ),
//             actions: [
//               if (!codeSent)
//                 // Show Send Code button if code has not been sent yet, and disable if phone number is not complete
//                 TextButton(
//                   onPressed: isPhoneNumberComplete
//                       ? () {
//                           setState(() {
//                             codeSent = true; // Code sent, switch to code input
//                           });
//                           // Logic to send the code to the phone number
//                           forgotPhoneNumber = phoneNumberController.text;
//                           if (kDebugMode) {
//                             print('Code sent to $forgotPhoneNumber');
//                           }
//                         }
//                       : null, // Disable button if the phone number is incomplete
//                   child: const Text('Send Code'),
//                 )
//               else
//                 // Show OK button after code is sent and enable it only if the verification code input is complete
//                 TextButton(
//                   onPressed: isVerificationCodeComplete
//                       ? () {
//                           // Combine all digits
//                           String verificationCode =
//                               verificationCodeDigits.join('');
//                           // Logic to verify the entered code
//                           Navigator.of(context)
//                               .pop(); // Close the current dialog
//                           if (kDebugMode) {
//                             print('Verification Code: $verificationCode');
//                           }
//                           // Show the dialog for entering the new PIN
//                           _showNewPinDialog(context);
//                         }
//                       : null, // Disable button if the verification code is incomplete
//                   child: const Text('OK'),
//                 ),
//               // Show Cancel button when phone number input is active, or Back when code input is active
//               TextButton(
//                 onPressed: () {
//                   setState(() {
//                     if (codeSent) {
//                       codeSent = false; // Go back to phone number input
//                     } else {
//                       Navigator.of(context).pop(); // Close the dialog
//                     }
//                   });
//                 },
//                 child: Text(codeSent ? 'Back' : 'Cancel'),
//               ),
//             ],
//           );
//         },
//       );
//     },
//   );
// }

// // Function to show the new PIN entry dialog
// void _showNewPinDialog(BuildContext context) {
//   TextEditingController newPinController = TextEditingController();
//   bool isPinVisible = false; // Track visibility of the PIN

//   showDialog(
//     context: context,
//     builder: (context) {
//       return StatefulBuilder(
//         builder: (context, setState) {
//           // Add a listener to the TextEditingController
//           newPinController.addListener(() {
//             setState(() {
//               // Enable or disable the button based on the input length
//             });
//           });

//           return AlertDialog(
//             backgroundColor: const Color(0xFF2C2C2C),
//             title: const Text('Set New PIN'),
//             content: TextFormField(
//               controller: newPinController,
//               keyboardType: TextInputType.number,
//               maxLength: 4, // Limit the PIN to 4 digits
//               obscureText:
//                   !isPinVisible, // Hide the PIN input based on the toggle
//               decoration: InputDecoration(
//                 labelText: 'New PIN',
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(8),
//                   borderSide: const BorderSide(
//                       color: Colors.grey), // Default border color
//                 ),
//                 focusedBorder: OutlineInputBorder(
//                   // Change color when focused
//                   borderRadius: BorderRadius.circular(8),
//                   borderSide: const BorderSide(
//                       color: Colors.red), // Focused border color
//                 ),
//                 suffixIcon: IconButton(
//                   icon: Icon(
//                     isPinVisible ? Icons.visibility : Icons.visibility_off,
//                   ),
//                   onPressed: () {
//                     setState(() {
//                       isPinVisible = !isPinVisible; // Toggle visibility
//                     });
//                   },
//                 ),
//               ),
//             ),
//             actions: [
//               TextButton(
//                 onPressed: newPinController.text.length == 4
//                     ? () {
//                         String newPin = newPinController.text;
//                         Navigator.of(context).pop(); // Close the new PIN dialog
//                         if (kDebugMode) {
//                           print('New PIN: $newPin');
//                         }
//                       }
//                     : null, // Disable button if the input is not valid
//                 child: const Text('Save'),
//               ),
//             ],
//           );
//         },
//       );
//     },
//   );
// }
