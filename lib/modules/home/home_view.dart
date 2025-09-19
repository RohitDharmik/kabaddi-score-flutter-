import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // for date parsing

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.emoji_events, color: Colors.cyan, size: 80),
            const SizedBox(height: 20),
            const Text("Kabaddi League",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            const SizedBox(height: 40),
            Wrap(
              spacing: 20,
              children: [
                ElevatedButton.icon(
                  icon: const Icon(Icons.settings),
                  label: const Text("Configure Match Settings"),
                  onPressed: () => Navigator.pushNamed(context, '/config'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // current date
                    DateTime today = DateTime.now();

                    DateTime cutoffDate =
                        DateFormat("dd/MM/yyyy").parse("25/09/2025");
                    // DateTime cutoffDate =
                    //     DateFormat("dd/MM/yyyy").parse("18/09/2025");

                    if (today.isAfter(cutoffDate)) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            title: const Text("Notice"),
                            content: const Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  "please Contact the developer team",
                                  // "Date: 27/01/2026",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                                SizedBox(height: 12),
                                Text(
                                  "this is a demo version.",
                                  // "Your version is deprecated. please Contact the developer team.",
                                  style: TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                            actions: [
                              TextButton(
                                onPressed: () =>
                                    Navigator.pop(context), // close modal
                                child: const Text("OK"),
                              ),
                            ],
                          );
                        },
                      );
                    } else {
                      // normal navigation
                      Navigator.pushNamed(context, '/dashboard');
                    }
                  },
                  child: const Text("Start Match"),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
