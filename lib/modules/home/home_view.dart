import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:zo_animated_border/zo_animated_border.dart'; // for date parsing

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            ZoRippleEffect(
                minCircleSize: 150,
                animationDuration: Duration(seconds: 5),
                borderRadius: BorderRadius.all(Radius.circular(100)),
                numberOfCircles: 5,
                rippleColor: Color(
                  0xFF3A82F8,
                ).withOpacity(0.3),
                child: Icon(Icons.emoji_events_outlined,
                    color: Theme.of(context).colorScheme.onPrimary, size: 80)),
            const SizedBox(height: 20),
            const Text("THAKUR DIGITAL SCOREBOARD KOMAKHAN",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'digital7',
                )),
            const SizedBox(height: 40),
            Wrap(
              spacing: 20,
              children: [
                ElevatedButton.icon(
                  icon: const Icon(Icons.settings),
                  label: const Text("Match Settings"),
                  onPressed: () => Navigator.pushNamed(context, '/config'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // current date
                    DateTime today = DateTime.now();

                    DateTime cutoffDate =
                        DateFormat("dd/MM/yyyy").parse("14/07/2026");
                    // DateTime cutoffDate =
                    //     DateFormat("dd/MM/yyyy").parse("15/12/2027");

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
                                      fontFamily: 'digital7',
                                      fontSize: 16),
                                ),
                                SizedBox(height: 12),
                                Text(
                                  // "this is a demo version.",
                                  "Your version is deprecated. please Contact the developer team.",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontFamily: 'digital7',
                                  ),
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
            ),
            const Spacer(), // Push trademark section to the bottom

            // Trademark Section
            Column(
              children: [
                Image.asset(
                  'assets/images/company_logo.jpeg', // Replace with actual logo path
                  height: 80,
                ),
                const SizedBox(height: 10),
                const Text(
                  '© 2025 36-Central.All rights reserved.',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                  'Developed by: 36-Central (7987262422)',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
