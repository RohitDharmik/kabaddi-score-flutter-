import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class MatchStore with ChangeNotifier {
  int teamAScore = 0;
  int teamBScore = 0;
  int teamAFouls = 0;
  int teamBFouls = 0;

  final _timerBeepPlayer = AudioPlayer();

  Duration matchDuration = const Duration(minutes: 20);
  Duration raidDuration = const Duration(seconds: 30);

  Timer? _matchTimer;
  Timer? _raidTimer;

  bool isMatchRunning = false;
  bool isRaidRunning = false;

  Duration matchRemaining = const Duration(minutes: 20);
  Duration raidRemaining = const Duration(seconds: 30);

  // Play a unique beep sound for timers
  void _playTimerBeep() async {
    // You must place your sound files in assets/sounds/shortbeep.mp3
    // and declare the assets folder in pubspec.yaml
    await _timerBeepPlayer.play(AssetSource('sounds/shortbeep.mp3'));
  }

  void _playTimerBuzzer() async {
    // You must place your sound files in assets/sounds/shortbeep.mp3
    // and declare the assets folder in pubspec.yaml
    await _timerBeepPlayer.play(AssetSource('sounds/buzzer.mp3'));
  }

  // Updated `startMatch` with sound logic and duration parameter
  void startMatch(int matchMinutes) {
    if (_matchTimer != null) return;
    isMatchRunning = true;
    matchDuration = Duration(minutes: matchMinutes);
    matchRemaining = matchDuration;

    _matchTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (matchRemaining.inSeconds <= 0) {
      } else {
        matchRemaining = matchRemaining - const Duration(seconds: 1);

        // Sound logic for Match Timer
        if (matchRemaining.inMinutes == 5 &&
            matchRemaining.inSeconds % 60 == 0) {
          _playTimerBeep(); // Last 5 minutes, 1 beep every minute
        }
        if (matchRemaining.inMinutes == 2 &&
            matchRemaining.inSeconds % 30 == 0) {
          _playTimerBeep(); // Last 2 minutes, 1 beep every 30 seconds
        }
        if (matchRemaining.inMinutes == 0 &&
            matchRemaining.inSeconds % 10 == 0) {
          _playTimerBeep(); // Last 1 minute, 1 beep every 10 seconds
        }

        notifyListeners();
      }
    });
  }

  void pauseAndPlay() {
    if (isMatchRunning) {
      _matchTimer?.cancel();
      isMatchRunning = false;
      notifyListeners();
    } else {
      _matchTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (matchRemaining.inSeconds <= 0) {
        } else {
          matchRemaining = matchRemaining - const Duration(seconds: 1);

          // Sound logic for Match Timer
          if (matchRemaining.inMinutes == 5 &&
              matchRemaining.inSeconds % 60 == 0) {
            _playTimerBeep(); // Last 5 minutes, 1 beep every minute
          }
          if (matchRemaining.inMinutes == 2 &&
              matchRemaining.inSeconds % 30 == 0) {
            _playTimerBeep(); // Last 2 minutes, 1 beep every 30 seconds
          }
          if (matchRemaining.inMinutes == 0 &&
              matchRemaining.inSeconds % 10 == 0) {
            _playTimerBeep(); // Last 1 minute, 1 beep every 10 seconds
          }

          notifyListeners();
        }
      });
      isMatchRunning = true;
    }
  }

  void stopMatch() {
    if (_matchTimer != null) {
      _matchTimer?.cancel();
      _matchTimer = null;
      isMatchRunning = false;
    } else {
      startMatch(matchDuration.inMinutes);
    }
    notifyListeners();
  }

  void resetMatch() {
    stopMatch();
    // isMatchRunning = false;
    matchRemaining = matchDuration;
    notifyListeners();
  }

  // Updated `startRaid` with sound logic and duration parameter
  void startRaid(int raidSeconds) {
    if (_raidTimer != null) return;
    isRaidRunning = true;
    raidDuration = Duration(seconds: raidSeconds);
    raidRemaining = raidDuration;
    _raidTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (raidRemaining.inSeconds <= 0) {
        stopRaid();
      } else {
        raidRemaining = raidRemaining - const Duration(seconds: 1);

        // Sound logic for Raid Timer
        if (raidRemaining.inSeconds <= 10 && raidRemaining.inSeconds > 0) {
          _playTimerBeep(); // Last 10 seconds, 1 beep every second
        }
        if (raidRemaining.inSeconds == 0) {
          _playTimerBuzzer(); // Raid over beep
        }

        notifyListeners();
      }
    });
  }

  void stopRaid() {
    _raidTimer?.cancel();
    _raidTimer = null;
    isRaidRunning = false;
    notifyListeners();
  }

  void resetRaid() {
    stopRaid();
    raidRemaining = raidDuration;
    notifyListeners();
  }

  void incrementScoreA() {
    teamAScore++;
    notifyListeners();
  }

  void decrementScoreA() {
    if (teamAScore > 0) teamAScore--;
    notifyListeners();
  }

  void incrementScoreB() {
    teamBScore++;
    notifyListeners();
  }

  void decrementScoreB() {
    if (teamBScore > 0) teamBScore--;
    notifyListeners();
  }

  void recordFoulA() {
    teamAFouls++;
    notifyListeners();
  }

  void recordFoulB() {
    teamBFouls++;
    notifyListeners();
  }

  void resetAll() {
    stopMatch();
    stopRaid();
    teamAScore = 0;
    teamBScore = 0;
    teamAFouls = 0;
    teamBFouls = 0;
    matchRemaining = matchDuration;
    raidRemaining = raidDuration;
    notifyListeners();
  }
}
