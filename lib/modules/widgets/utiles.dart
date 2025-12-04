import 'package:THAKUR_DIGITAL_SCOREBOARD/core/theme.dart';
import 'package:flutter/material.dart';
import 'package:zo_animated_border/zo_animated_border.dart';

Widget iconButton(IconData icon, VoidCallback onPressed) {
  return Container(
    decoration: BoxDecoration(
      color: const Color(0xFF2B2B33),
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: const Color(0xFF4A4A5A), width: 1),
    ),
    child: IconButton(
      icon: Icon(icon, color: Colors.white),
      onPressed: onPressed,
    ),
  );
}

Widget soundButton({
  required IconData icon,
  required String label,
  required VoidCallback onPressed,
}) {
  return ElevatedButton.icon(
    onPressed: onPressed,
    style: ElevatedButton.styleFrom(
      backgroundColor: AppTheme.darkTheme.primaryColor,
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: const BorderSide(color: Color(0xFF4A4A5A), width: 1),
      ),
    ),
    icon: Icon(icon, size: 20),
    label: Text(label),
  );
}

Widget timerButton({
  required IconData icon,
  required VoidCallback onPressed,
}) {
  return Container(
    decoration: BoxDecoration(
      color: AppTheme.darkTheme.primaryColor,
      borderRadius: BorderRadius.circular(4),
    ),
    child: IconButton(
      icon: Icon(icon, color: Colors.white),
      onPressed: onPressed,
    ),
  );
}

Widget teamPanel(
  BuildContext context,
  String teamName,
  int score,
  int fouls,
  List<bool> playerStatuses,
  VoidCallback onInc,
  VoidCallback onDec,
  VoidCallback onFoul,
  Function(int) onPlayerTap,
) {
  final screenWidth = MediaQuery.of(context).size.width;

  return Container(
    decoration: BoxDecoration(
      color: const Color(0xFF1E1E28),
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: const Color(0xFF3A3A4A), width: 1.5),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.2),
          blurRadius: 10,
          offset: const Offset(0, 5),
        ),
      ],
    ),
    padding: const EdgeInsets.all(0.0),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(0.0),
          child: Text(
            textHeightBehavior: const TextHeightBehavior(
                applyHeightToLastDescent: false,
                applyHeightToFirstAscent: false,
                leadingDistribution: TextLeadingDistribution.even),
            teamName.toUpperCase(),
            style: TextStyle(
              color: Theme.of(context).colorScheme.secondary,
              fontSize: 80,
              fontWeight: FontWeight.w800,
              // fontFamily: 'digital7',
            ),
            textAlign: TextAlign.center,
          ),
        ),
        Spacer(),
        Padding(
          padding: const EdgeInsets.all(0.0),
          child: Text(
            score.toString().padLeft(2, '0'),
            textHeightBehavior: const TextHeightBehavior(
              applyHeightToLastDescent: false,
              applyHeightToFirstAscent: false,
            ),
            style: TextStyle(
              color: const Color(0xFF00FFAA),
              fontSize: screenWidth < 600
                  ? 100
                  : screenWidth < 900
                      ? 150
                      : screenWidth < 1200
                          ? 220
                          : 250,
              fontWeight: FontWeight.w900,
              fontFamily: 'digital7',
            ),
            maxLines: 1,
            textAlign: TextAlign.center,
          ),
        ),

        // const SizedBox(height: 10),
        Spacer(),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            scoreButton(Icons.remove, onDec),
            const SizedBox(width: 16),
            scoreButton(Icons.add, onInc),
          ],
        ),
        Spacer(),
        // const SizedBox(height: 10),
        playerStatusRow(playerStatuses, onPlayerTap),
        // const SizedBox(height: 10),
      ],
    ),
  );
}

Widget scoreButton(IconData icon, VoidCallback onPressed) {
  return Container(
    decoration: BoxDecoration(
      color: AppTheme.darkTheme.primaryColor,
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: const Color(0xFF4A4A5A), width: 1),
    ),
    child: IconButton(
      icon: Icon(icon, color: Colors.white, size: 28),
      onPressed: onPressed,
    ),
  );
}

Widget playerStatusRow(List<bool> playerStatuses, Function(int) onPlayerTap) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: List.generate(7, (index) {
      return GestureDetector(
        onTap: () => onPlayerTap(index),
        child: Container(
          margin: const EdgeInsets.only(bottom: 20),
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: ZoAnimatedGradientBorder(
            borderRadius: 40, borderThickness: 1,
            animationDuration: const Duration(seconds: 3),
            glowOpacity: 1.0,
            animationCurve: Curves.easeInOut,
            // duration: const Duration(seconds: 30),
            gradientColor: playerStatuses[index]
                ? [
                    const Color(0xFF00FF00),
                    const Color(0xFF05F005),
                    const Color.fromARGB(224, 119, 240, 49),
                    const Color(0xE21EF91E),
                  ]
                : [
                    const Color(0xFFFF0000),
                    const Color(0xFFFF0505),
                    const Color(0xFFE13131),
                    const Color(0xFFE21E1E),
                  ],

            child: Icon(
              Icons.person_outline_sharp,
              color: playerStatuses[index]
                  ? const Color(0xFF00FF00)
                  : const Color(0xFFFF0000),
              size: 50,
            ),
          ),
        ),
      );
    }),
  );
}
