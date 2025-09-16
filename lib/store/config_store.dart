import 'package:flutter/foundation.dart';

class ConfigStore extends ChangeNotifier {
  int matchMinutes = 20;
  int raidSeconds = 30;
  String teamA = "Team A";
  String teamB = "Team B";

  void updateMatch(int minutes) {
    matchMinutes = minutes;
    notifyListeners();
  }

  void updateRaid(int seconds) {
    raidSeconds = seconds;
    notifyListeners();
  }

  void updateTeamA(String name) {
    teamA = name;
    notifyListeners();
  }

  void updateTeamB(String name) {
    teamB = name;
    notifyListeners();
  }
}
