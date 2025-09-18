import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ConfigStore extends ChangeNotifier {
  int matchMinutes = 30;
  int raidSeconds = 30;
  String teamA = "Team A";
  String teamB = "Team B";

  void updateMatchTime(int minutes) {
    print(minutes.toString() + " minutes set in config store");
    this.matchMinutes = minutes;
    notifyListeners();

    print(matchMinutes.toString() + " minutes set in config store");
  }

  void updateTime() {
    print(this.matchMinutes.toString() + " minutes set in config store");
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
