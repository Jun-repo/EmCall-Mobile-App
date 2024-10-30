import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactPage extends StatelessWidget {
  const ContactPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.appBarTheme.backgroundColor,
        foregroundColor: theme.appBarTheme.foregroundColor,
        title: Center(
          child: Text(
            'Emergency Contacts',
            style: theme.textTheme.headlineMedium,
          ),
        ),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2, // Two columns in the grid
          childAspectRatio: 1.5, // Aspect ratio for each card
          children: [
            // Header for Quezon Municipal
            const Text(
              'QUEZON MUNICIPAL',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.redAccent,
              ),
            ),
            const SizedBox(height: 16.0), // Add some space below the header
            _buildAgencyCard(context, 'PNP', [
              const ContactCard(name: 'Officer A', phoneNumber: '1234567890'),
              const ContactCard(name: 'Officer B', phoneNumber: '123-456-7891'),
              const ContactCard(name: 'Officer C', phoneNumber: '123-456-7892'),
              const ContactCard(name: 'Officer D', phoneNumber: '123-456-7893'),
              const ContactCard(name: 'Officer E', phoneNumber: '123-456-7894'),
              const ContactCard(name: 'Officer F', phoneNumber: '123-456-7895'),
              const ContactCard(name: 'Officer G', phoneNumber: '123-456-7896'),
              const ContactCard(name: 'Officer H', phoneNumber: '123-456-7897'),
              const ContactCard(name: 'Officer I', phoneNumber: '123-456-7898'),
              const ContactCard(name: 'Officer J', phoneNumber: '123-456-7899'),
            ]),
            _buildAgencyCard(context, 'BFP', [
              const ContactCard(
                  name: 'Firefighter A', phoneNumber: '223-456-7890'),
              const ContactCard(
                  name: 'Firefighter B', phoneNumber: '223-456-7891'),
              const ContactCard(
                  name: 'Firefighter C', phoneNumber: '223-456-7892'),
              const ContactCard(
                  name: 'Firefighter D', phoneNumber: '223-456-7893'),
              const ContactCard(
                  name: 'Firefighter E', phoneNumber: '223-456-7894'),
              const ContactCard(
                  name: 'Firefighter F', phoneNumber: '223-456-7895'),
              const ContactCard(
                  name: 'Firefighter G', phoneNumber: '223-456-7896'),
              const ContactCard(
                  name: 'Firefighter H', phoneNumber: '223-456-7897'),
              const ContactCard(
                  name: 'Firefighter I', phoneNumber: '223-456-7898'),
              const ContactCard(
                  name: 'Firefighter J', phoneNumber: '223-456-7899'),
            ]),
            _buildAgencyCard(context, 'MDRRMO', [
              const ContactCard(
                  name: 'Responder A', phoneNumber: '323-456-7890'),
              const ContactCard(
                  name: 'Responder B', phoneNumber: '323-456-7891'),
              const ContactCard(
                  name: 'Responder C', phoneNumber: '323-456-7892'),
              const ContactCard(
                  name: 'Responder D', phoneNumber: '323-456-7893'),
              const ContactCard(
                  name: 'Responder E', phoneNumber: '323-456-7894'),
              const ContactCard(
                  name: 'Responder F', phoneNumber: '323-456-7895'),
              const ContactCard(
                  name: 'Responder G', phoneNumber: '323-456-7896'),
              const ContactCard(
                  name: 'Responder H', phoneNumber: '323-456-7897'),
              const ContactCard(
                  name: 'Responder I', phoneNumber: '323-456-7898'),
              const ContactCard(
                  name: 'Responder J', phoneNumber: '323-456-7899'),
            ]),
            _buildAgencyCard(context, 'RESCUE', [
              const ContactCard(name: 'Rescuer A', phoneNumber: '423-456-7890'),
              const ContactCard(name: 'Rescuer B', phoneNumber: '423-456-7891'),
              const ContactCard(name: 'Rescuer C', phoneNumber: '423-456-7892'),
              const ContactCard(name: 'Rescuer D', phoneNumber: '423-456-7893'),
              const ContactCard(name: 'Rescuer E', phoneNumber: '423-456-7894'),
              const ContactCard(name: 'Rescuer F', phoneNumber: '423-456-7895'),
              const ContactCard(name: 'Rescuer G', phoneNumber: '423-456-7896'),
              const ContactCard(name: 'Rescuer H', phoneNumber: '423-456-7897'),
              const ContactCard(name: 'Rescuer I', phoneNumber: '423-456-7898'),
              const ContactCard(name: 'Rescuer J', phoneNumber: '423-456-7899'),
            ]),
          ],
        ),
      ),
    );
  }

  Widget _buildAgencyCard(
      BuildContext context, String agencyName, List<ContactCard> contacts) {
    return Card(
      color: Theme.of(context).cardTheme.color,
      elevation: Theme.of(context).cardTheme.elevation,
      shape: Theme.of(context).cardTheme.shape,
      child: InkWell(
        borderRadius:
            BorderRadius.circular(8), // Matching InkWell border radius
        onTap: () {
          // Navigate to a new page or show the contacts for the selected agency
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AgencyContactsPage(
                  agencyName: agencyName, contacts: contacts),
            ),
          );
        },
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              agencyName,
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}

class AgencyContactsPage extends StatelessWidget {
  final String agencyName;
  final List<ContactCard> contacts;

  const AgencyContactsPage({
    super.key,
    required this.agencyName,
    required this.contacts,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // Access the current theme
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.appBarTheme.backgroundColor,
        foregroundColor: theme.appBarTheme.foregroundColor,
        title: Text(
          '$agencyName Contacts',
          style: theme.textTheme.titleLarge,
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: contacts,
      ),
    );
  }
}

class ContactCard extends StatelessWidget {
  final String name;
  final String phoneNumber;

  const ContactCard({super.key, required this.name, required this.phoneNumber});

  final String sampleMessage =
      'Hello! This is an emergency message. This is my location!';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // Get the current theme
    return Slidable(
      startActionPane: ActionPane(
        motion: const DrawerMotion(),
        children: [
          SlidableAction(
            onPressed: (context) {
              _sendMessage(phoneNumber, sampleMessage);
            },
            backgroundColor: const Color.fromARGB(255, 71, 0, 110),
            foregroundColor: Colors.white,
            icon: Icons.message,
            label: 'Message',
          ),
          SlidableAction(
            onPressed: (context) {
              _makeCall(phoneNumber);
            },
            backgroundColor: const Color.fromARGB(255, 169, 40, 118),
            foregroundColor: Colors.white,
            icon: Icons.call,
            label: 'Call',
          ),
        ],
      ),
      child: Card(
        color: theme.cardTheme.color, // Use the card color from the theme
        elevation: theme.cardTheme.elevation ?? 4.0, // Use elevation from theme
        shape: theme.cardTheme.shape, // Use shape from theme
        margin: const EdgeInsets.symmetric(vertical: 4.0),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor:
                theme.colorScheme.secondary, // Use secondary color from theme
            child: Text(
              name[0], // Display the first letter of the name
              style: const TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
          title: Text(
            name,
            style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            'Phone: $phoneNumber',
            style: const TextStyle(fontSize: 16.0),
          ),
          trailing: IconButton(
            icon: Icon(Icons.more_vert,
                color: theme.brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black), // Three vertical dots icon
            onPressed: () {
              // Handle more options here, e.g., showing a menu
              _showMoreOptions(context);
            },
          ),
        ),
      ),
    );
  }

  void _showMoreOptions(BuildContext context) {
    final theme = Theme.of(context); // Get the current theme
    // Show the profile view of the contact
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: theme.brightness == Brightness.dark
                ? const Color.fromARGB(255, 35, 35, 35)
                : Colors.white, // Background color of the modal
            borderRadius: const BorderRadius.vertical(
                top: Radius.circular(8.0)), // Rounded top corners
          ),
          child: Stack(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Display profile avatar
                  Positioned(
                    left: 16,
                    child: CircleAvatar(
                      radius: 50.0, // Size of the avatar
                      backgroundColor: Colors.redAccent,
                      child: Text(
                        name.isNotEmpty
                            ? name[0].toUpperCase()
                            : '?', // Display the first letter of the name
                        style: TextStyle(
                          color: theme.brightness == Brightness.dark
                              ? Colors.white
                              : Colors.black, // Change color based on theme
                          fontSize: 40,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  // Display contact name
                  Text(
                    name,
                    style: TextStyle(
                      color: theme.brightness == Brightness.dark
                          ? Colors.white
                          : Colors.black, // Change color based on theme
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  // Display phone number
                  Text(
                    'Phone: $phoneNumber',
                    style: TextStyle(
                      color: theme.brightness == Brightness.dark
                          ? Colors.white
                          : Colors.black, // Change color based on theme
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  // Optionally add more information about the contact
                  Text(
                    'Additional Info:',
                    style: TextStyle(
                      color: theme.brightness == Brightness.dark
                          ? Colors.white
                          : Colors.black, // Change color based on theme
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  // You can add more details about the contact here
                  Text(
                    'rerne erjenenr vnfd ene apddl dkemdkdmfdf  windkfd  ekfmmdf fkdmf fdfd dfjdn fjfnfjnf',
                    style: TextStyle(
                      color: theme.brightness == Brightness.dark
                          ? Colors.white
                          : Colors.black, // Change color based on theme
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                ],
              ),
              // Circular exit icon button at the top right
              Positioned(
                top: 6.0,
                right: 6.0,
                child: CircleAvatar(
                  backgroundColor: Colors.redAccent.withOpacity(0.5),
                  radius: 15.0,
                  child: IconButton(
                    padding: EdgeInsets.zero, // Remove padding from the button
                    icon: const Icon(Icons.close,
                        color: Colors.white), // Close icon
                    onPressed: () {
                      Navigator.pop(context); // Close the modal
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _makeCall(String phoneNumber) async {
    final Uri url = Uri(scheme: 'tel', path: phoneNumber);
    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      } else {
        throw 'Could not launch $url';
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error: $e');
      }
    }
  }

  void _sendMessage(String phoneNumber, String messageBody) async {
    final Uri smsLaunchUri = Uri(
      scheme: 'sms',
      path: phoneNumber,
      queryParameters: <String, String>{
        'body': messageBody,
      },
    );

    try {
      if (await canLaunchUrl(smsLaunchUri)) {
        await launchUrl(smsLaunchUri);
      } else {
        throw 'Could not launch $smsLaunchUri';
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error: $e');
      }
    }
  }
}
