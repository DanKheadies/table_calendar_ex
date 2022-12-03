import 'package:flutter/material.dart';

import 'package:table_calendar_ex/screens/screens.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TableCalendar Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20.0),
            ElevatedButton(
              child: const Text('Basics'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const BasicScreen(),
                  ),
                );
              },
            ),
            const SizedBox(height: 12.0),
            ElevatedButton(
              child: const Text('Range Selection'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const RangeScreen(),
                  ),
                );
              },
            ),
            const SizedBox(height: 12.0),
            ElevatedButton(
              child: const Text('Events'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const EventsScreen(),
                  ),
                );
              },
            ),
            const SizedBox(height: 12.0),
            ElevatedButton(
              child: const Text('Multiple Selection'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const MultiScreen(),
                  ),
                );
              },
            ),
            const SizedBox(height: 12.0),
            ElevatedButton(
              child: const Text('Complex'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ComplexScreen(),
                  ),
                );
              },
            ),
            const SizedBox(height: 20.0),
          ],
        ),
      ),
    );
  }
}
