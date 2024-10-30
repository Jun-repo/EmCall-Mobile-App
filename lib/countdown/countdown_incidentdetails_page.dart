import 'package:flutter/material.dart';

class CountdownIncidentdetailsPage extends StatelessWidget {
  final String incident;
  final String agency;

  const CountdownIncidentdetailsPage({
    super.key,
    required this.incident,
    required this.agency,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Incident Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Incident: $incident',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 10),
            Text(
              'Agency: $agency',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Navigate back to the previous page
              },
              child: const Text('Go Back'),
            ),
          ],
        ),
      ),
    );
  }
}
