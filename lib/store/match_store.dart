import 'dart:async';

import 'package:THAKUR_DIGITAL_SCOREBOARD/store/config_store.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class MatchStore with ChangeNotifier {
  int teamAScore = 0;
  int teamBScore = 0;
  int teamAFouls = 0;
  int teamBFouls = 0;
  int playerAId = 0;
  int playerBId = 0;

  // ConfigStore configStore = ConfigStore();
  // NEW: Player status lists
  // Default to `true` so player icons show green by default.
  List<bool> teamAPlayerStatuses = List.generate(7, (_) => true);
  List<bool> teamBPlayerStatuses = List.generate(7, (_) => true);
  void togglePlayer(bool isTeamA, int index) {
    if (isTeamA) {
      teamAPlayerStatuses[index] = !teamAPlayerStatuses[index];
    } else {
      teamBPlayerStatuses[index] = !teamBPlayerStatuses[index];
    }
    notifyListeners();
  }

  late Duration matchDuration = Duration(minutes: ConfigStore().matchMinutes);
  late Duration matchRemaining;
  late Duration raidDuration = Duration(minutes: ConfigStore().raidSeconds);
  late Duration raidRemaining;
  // Duration matchDuration = ;
  final ConfigStore configStore;

  MatchStore(this.configStore) {
    // Initialize using configStore
    print(ConfigStore().matchMinutes.toString() +
        "123 minutes set in match store");
    this.matchDuration = Duration(minutes: configStore.matchMinutes);
    matchRemaining = matchDuration;
    this.raidDuration = Duration(seconds: configStore.raidSeconds);
    raidRemaining = raidDuration;
  }
  final _timerBeepPlayer = AudioPlayer();

  // Duration matchDuration = const Duration(minutes: configStore.matchMinutes);
  // Duration raidDuration = const Duration(seconds: 30);
  // Duration raidDuration = Duration(minutes: ConfigStore().raidSeconds);

  Timer? _matchTimer;
  Timer? _raidTimer;

  bool isMatchRunning = false;
  bool isRaidRunning = false;

  // flags to ensure sounds play only once per match lifecycle
  // bool _halfTimePlayed = false;
  bool _startSoundPlayed = false;

  // Duration matchRemaining = const Duration(minutes: configStore.matchMinutes);
  // Duration raidRemaining = const Duration(seconds: 30);

  // Play a unique beep sound for timers
  // void _playTimerBeep() async {
  //   // You must place your sound files in assets/sounds/shortbeep.mp3
  //   // and declare the assets folder in pubspec.yaml
  //   await _timerBeepPlayer.play(AssetSource('sounds/tensec.mp3'));
  // }
  void _playTensecSound() async {
    // You must place your sound files in assets/sounds/shortbeep.mp3
    // and declare the assets folder in pubspec.yaml
    // stop any currently playing beep before starting a new one
    try {
      await _timerBeepPlayer.stop();
    } catch (_) {}
    await _timerBeepPlayer.play(AssetSource('sounds/tensec.mp3'));
  }
  // void _timeOverSound() async {
  //   await _timerBeepPlayer.play(AssetSource('sounds/timeover.mp3'));
  // }

  // void _playTimerBuzzer() async {
  //   // You must place your sound files in assets/sounds/shortbeep.mp3
  //   // and declare the assets folder in pubspec.yaml
  //   await _timerBeepPlayer.play(AssetSource('sounds/buzzer.mp3'));
  // }

  // void _playHalfTimerSound() async {
  //   // You must place your sound files in assets/sounds/shortbeep.mp3
  //   // and declare the assets folder in pubspec.yaml
  //   await _timerBeepPlayer.play(AssetSource('sounds/halftime.mp3'));
  // }

  // void _playStartTimerSound() async {
  //   // You must place your sound files in assets/sounds/shortbeep.mp3
  //   // and declare the assets folder in pubspec.yaml
  //   await _timerBeepPlayer.play(AssetSource('sounds/matchstart.mp3'));
  // }

  void swapSides() {
    final tempScore = teamAScore;
    teamAScore = teamBScore;
    teamBScore = tempScore;

    final tempFouls = teamAFouls;
    teamAFouls = teamBFouls;
    teamBFouls = tempFouls;

    final tempName = configStore.teamA;
    configStore.teamA = configStore.teamB;
    configStore.teamB = tempName;

    // Lists
    final tmpList = teamAPlayerStatuses;
    teamAPlayerStatuses = teamBPlayerStatuses;
    teamBPlayerStatuses = tmpList;
    // swap color change
    // If any team has all players toggled off (red), turn them all on (green).
    if (teamAPlayerStatuses.isNotEmpty &&
        teamAPlayerStatuses.every((v) => v == false)) {
      teamAPlayerStatuses =
          List.generate(teamAPlayerStatuses.length, (_) => true);
    }
    if (teamBPlayerStatuses.isNotEmpty &&
        teamBPlayerStatuses.every((v) => v == false)) {
      teamBPlayerStatuses =
          List.generate(teamBPlayerStatuses.length, (_) => true);
    }

    notifyListeners();
  }

  // Updated `startMatch` with sound logic and duration parameter
  void startMatch(int matchMinutes) {
    if (_matchTimer != null) return;
    isMatchRunning = true;
    matchDuration = Duration(minutes: matchMinutes);
    matchRemaining = matchDuration;
    // new match: reset flags and play start sound
    // _halfTimePlayed = false;
    // _startSoundPlayed = true;
    // _playStartTimerSound();

    _matchTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (matchRemaining.inSeconds <= 0) {
        // ensure final state
        // _timeOverSound();
        // _matchTimer?.cancel();
        // _matchTimer = null;
        // isMatchRunning = false;
        // matchRemaining = Duration.zero;
        // notifyListeners();
      } else {
        matchRemaining = matchRemaining - const Duration(seconds: 1);

        // play halftime once when remaining equals half the original duration
        // final halfSeconds = matchDuration.inSeconds ~/ 2;
        // if (!_halfTimePlayed &&
        //     matchRemaining.inSeconds == halfSeconds &&
        //     matchRemaining.inSeconds % 60 == 0) {
        //   _halfTimePlayed = true;
        //   _playHalfTimerSound();
        // }

        // Sound logic for Match Timer (beeps)
        // if (matchRemaining.inMinutes == 5 &&
        //     matchRemaining.inSeconds % 60 == 0) {
        //   _playTimerBeep(); // Last 5 minutes, 1 beep every minute
        // }
        // if (matchRemaining.inMinutes == 2 &&
        //     matchRemaining.inSeconds % 30 == 0) {
        //   _playTimerBeep(); // Last 2 minutes, 1 beep every 30 seconds
        // }
        // if (matchRemaining.inMinutes == 0 &&
        //     matchRemaining.inSeconds % 10 == 0) {
        //   _playTimerBeep(); // Last 1 minute, 1 beep every 10 seconds
        // }

        // if time reaches 00:00 after decrement, play time-over and stop
        if (matchRemaining.inMinutes == 0 && matchRemaining.inSeconds == 0) {
          // _timeOverSound();
          // _matchTimer?.cancel();
          // _matchTimer = null;
          // isMatchRunning = false;
        }

        notifyListeners();
      }
    });
  }

  void pauseAndPlay() {
    if (isMatchRunning) {
      _matchTimer?.cancel();
      isMatchRunning = false;
      // stop any timer-related beep audio when pausing
      try {
        _timerBeepPlayer.stop();
      } catch (_) {}
      notifyListeners();
    } else {
      // If starting from full remaining time, treat as first start and play start sound
      if (!_startSoundPlayed && matchRemaining == matchDuration) {
        // _startSoundPlayed = true;
        // _halfTimePlayed = false;
        // _playStartTimerSound();
      }

      _matchTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (matchRemaining.inSeconds <= 0) {
          // _timeOverSound();
          // _matchTimer?.cancel();
          // _matchTimer = null;
          // isMatchRunning = false;
          // matchRemaining = Duration.zero;
          // notifyListeners();
        } else {
          matchRemaining = matchRemaining - const Duration(seconds: 1);

          // play halftime once when remaining equals half the original duration
          // final halfSeconds = matchDuration.inSeconds ~/ 2;
          // if (!_halfTimePlayed &&
          //     matchRemaining.inSeconds == halfSeconds &&
          //     matchRemaining.inSeconds % 60 == 0) {
          //   _halfTimePlayed = true;
          //   _playHalfTimerSound();
          // }

          // Sound logic for Match Timer (beeps)
          // if (matchRemaining.inMinutes == 5 &&
          //     matchRemaining.inSeconds % 60 == 0) {
          //   _playTimerBeep(); // Last 5 minutes, 1 beep every minute
          // }
          // if (matchRemaining.inMinutes == 2 &&
          //     matchRemaining.inSeconds % 30 == 0) {
          //   _playTimerBeep(); // Last 2 minutes, 1 beep every 30 seconds
          // }
          // if (matchRemaining.inMinutes == 0 &&
          //     matchRemaining.inSeconds % 10 == 0) {
          //   _playTimerBeep(); // Last 1 minute, 1 beep every 10 seconds
          // }

          // if time reaches 00:00 after decrement, play time-over and stop
          if (matchRemaining.inMinutes == 0 && matchRemaining.inSeconds == 0) {
            // _timeOverSound();
            // _matchTimer?.cancel();
            // _matchTimer = null;
            // isMatchRunning = false;
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
      // stop any timer-related beep audio when stopping
      try {
        _timerBeepPlayer.stop();
      } catch (_) {}
    } else {
      startMatch(matchDuration.inMinutes);
    }
    notifyListeners();
  }

  void resetMatch() {
    stopMatch();
    // isMatchRunning = false;
    matchRemaining = matchDuration;
    // _halfTimePlayed = false;
    // _startSoundPlayed = false;
    // ensure beep player is stopped on reset
    try {
      _timerBeepPlayer.stop();
    } catch (_) {}
    notifyListeners();
  }

  // Updated `startRaid` with sound logic and duration parameter
  void startRaid(int raidSeconds) {
    print(raidSeconds.toString() + " raidraidSeconds");
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
        // if (raidRemaining.inSeconds <= 10 && raidRemaining.inSeconds > 0) {
        //   _playTimerBeep(); // Last 10 seconds, 1 beep every second
        // }
        // if (raidRemaining.inSeconds == 0) {
        //   _playTimerBuzzer(); // Raid over beep
        // }

        notifyListeners();
      }
    });
  }

  void pauseAndPlayRaid() {
    if (isRaidRunning) {
      _raidTimer?.cancel();
      isRaidRunning = false;
      // // stop any timer-related beep audio when pausing raid
      // try {
      //   _timerBeepPlayer.stop();
      // } catch (_) {}
      notifyListeners();
    } else {
      _raidTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (raidRemaining.inSeconds <= 0) {
          stopRaid();
        } else {
          raidRemaining = raidRemaining - const Duration(seconds: 1);

          // Sound logic for Raid Timer
          // if (raidRemaining.inSeconds <= 10 && raidRemaining.inSeconds > 0) {
          //   _playTimerBeep(); // Last 10 seconds, 1 beep every second
          // }
          if (raidRemaining.inSeconds == 11 && raidRemaining.inSeconds > 0) {
            _playTensecSound(); // Last 10 seconds, 1 beep every second
          }
          // if (raidRemaining.inSeconds == 0) {
          //   _playTimerBuzzer(); // Raid over beep
          // }

          notifyListeners();
        }
      });
      isRaidRunning = true;
    }
  }

  void stopRaid() {
    _raidTimer?.cancel();
    _raidTimer = null;
    isRaidRunning = false;
    raidRemaining = raidDuration;
    // stop any timer-related beep audio when stopping raid
    try {
      _timerBeepPlayer.stop();
    } catch (_) {}
    notifyListeners();
  }

  void resetRaid() {
    stopRaid();
    raidRemaining = raidDuration;
    // ensure beep player is stopped on reset
    try {
      _timerBeepPlayer.stop();
    } catch (_) {}
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

  void back(BuildContext context) {
    Navigator.pop(context);
    resetAll();
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
