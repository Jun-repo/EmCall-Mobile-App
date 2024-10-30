import 'dart:math';

import 'package:emcall/services/notification.dart';

class CodeGenerator {
  String _randomNumber = '';

  String generateRandomNumber() {
    // Generate a random 6-digit number
    int randomNumber =
        Random().nextInt(900000) + 100000; // From 100000 to 999999
    _randomNumber = randomNumber.toString();

    // Show notification with the generated random number
    _showNotification(_randomNumber);

    return _randomNumber; // Return the generated number
  }

  void _showNotification(String randomNumber) {
    DateTime scheduledDate = DateTime.now().add(const Duration(seconds: 5));
    NotificationService.scheduleNotification(
      0, // Notification ID
      "EmCall",
      'Sent Code: $randomNumber\n\nExpired after 5 minutes',
      scheduledDate,
      // ignore: void_checks
      () {
        incrementNotificationCount(); // Update count here
      },
      onComplete: () {},
    );
  }

  void incrementNotificationCount() {}
}
