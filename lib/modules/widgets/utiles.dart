import 'package:flutter/material.dart';

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
      backgroundColor: const Color(0xFF2B2B33),
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
      color: const Color(0xFF2B2B33),
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
      mainAxisAlignment: MainAxisAlignment.center,
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
            style: const TextStyle(
              color: Colors.white,
              fontSize: 80,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ),
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
                      ? 125
                      : screenWidth < 1200
                          ? 200
                          : 235,
              fontWeight: FontWeight.w900,
              fontFamily: 'digital7',
            ),
            maxLines: 1,
            textAlign: TextAlign.center,
          ),
        ),
        // const SizedBox(height: 10),
        playerStatusRow(playerStatuses, onPlayerTap),
        // const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            scoreButton(Icons.remove, onDec),
            const SizedBox(width: 16),
            scoreButton(Icons.add, onInc),
          ],
        ),
        // const SizedBox(height: 10),
      ],
    ),
  );
}

Widget scoreButton(IconData icon, VoidCallback onPressed) {
  return Container(
    decoration: BoxDecoration(
      color: const Color(0xFF2B2B33),
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
    crossAxisAlignment: CrossAxisAlignment.start,
    children: List.generate(7, (index) {
      return GestureDetector(
        onTap: () => onPlayerTap(index),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          child: Icon(
            Icons.account_circle_outlined,
            color: playerStatuses[index]
                ? const Color(0xFF00FF00)
                : const Color(0xFFFF0000),
            size: 40,
          ),
        ),
      );
    }),
  );
}
