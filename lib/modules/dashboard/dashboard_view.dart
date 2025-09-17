import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../store/config_store.dart';
import '../../store/match_store.dart';

// Create a global AudioPlayer instance for sound buttons
final _audioPlayer = AudioPlayer();

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  String formatDuration(Duration d) {
    final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  // Play both long beep and buzzer sounds for button clicks
  void _playButtonSounds() async {
    // Ensure you have these sound files in your assets folder
    // e.g., assets/sounds/longbeep.mp3 and assets/sounds/buzzer.mp3
    // and declare them in pubspec.yaml
    await _audioPlayer.setReleaseMode(ReleaseMode.stop);
    await _audioPlayer.play(AssetSource('sounds/longbeep.mp3'));
    await _audioPlayer.play(AssetSource('sounds/buzzer.mp3'));
  }

  // Dedicated function for the 'Beep' sound with SnackBar feedback
  void _playBeepSound(BuildContext context) {
    // TODO: Implement actual sound playback logic here.
    // E.g., using an audio package like audioplayers
    final player = AudioPlayer();
    player.play(AssetSource('sounds/longbeep.mp3'));
  }

  // Dedicated function for the 'Buzzer' sound with SnackBar feedback
  void _playBuzzerSound(BuildContext context) {
    // TODO: Implement actual sound playback logic here.
    final player = AudioPlayer();
    player.play(AssetSource('sounds/buzzer.mp3'));
  }

  void _playDoOrDieSound(BuildContext context) {
    // TODO: Implement actual sound playback logic here.
    final player = AudioPlayer();
    player.play(AssetSource('sounds/doordie.mp3'));
  }

  @override
  Widget build(BuildContext context) {
    final matchStore = context.watch<MatchStore>();
    final configStore = context.watch<ConfigStore>();

    onStartMatch() {
      matchStore.startMatch(configStore.matchMinutes);
    }

    onStartRaid() {
      matchStore.startRaid(configStore.raidSeconds);
    }

    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: const Color(0xFF0F1115),
      appBar: AppBar(
        title: const Text('Dashboard'),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // _soundButton(
                //   icon: Icons.volume_up,
                //   label: 'Beep',
                //   onPressed: () => _playBeepSound(context),
                // ),
                _soundButton(
                  icon: Icons.volume_up,
                  label: 'Do or Die',
                  onPressed: () => _playDoOrDieSound(context),
                ),
                const SizedBox(width: 16),
                _soundButton(
                  icon: Icons.notifications_active,
                  label: 'Buzzer',
                  onPressed: () => _playBuzzerSound(context),
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Sound Buttons Section

            // Scoreboard and Timers Section
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Team A Panel
                  Expanded(
                    child: _teamPanel(
                      context,
                      configStore.teamA,
                      matchStore.teamAScore,
                      matchStore.teamAFouls,
                      () => matchStore.incrementScoreA(),
                      () => matchStore.decrementScoreA(),
                      () => matchStore.recordFoulA(),
                    ),
                  ),
                  const SizedBox(width: 24),

                  // Center Timer Section
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'MATCH TIMER',
                        style: TextStyle(
                            color: Colors.white70,
                            fontSize: 24,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        formatDuration(matchStore.matchRemaining),
                        style: const TextStyle(
                            color: Color(0xFF00FFAA),
                            fontSize: 72,
                            fontWeight: FontWeight.w900),
                      ),
                      Row(
                        children: [
                          _timerButton(
                              icon: matchStore.isMatchRunning
                                  ? Icons.pause
                                  : Icons.play_arrow,
                              onPressed: matchStore.isMatchRunning
                                  ? matchStore.stopMatch
                                  : onStartMatch),
                          const SizedBox(width: 8),
                          _timerButton(
                              icon: Icons.refresh,
                              onPressed: matchStore.resetMatch),
                        ],
                      ),
                      const SizedBox(height: 32),
                      const Text(
                        'RAID TIMER',
                        style: TextStyle(
                            color: Colors.white70,
                            fontSize: 50,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        formatDuration(matchStore.raidRemaining),
                        style: TextStyle(
                            color: Color(0xFF00E5FF),
                            fontSize: screenWidth < 600
                                ? 80
                                : screenWidth < 900
                                    ? 100
                                    : 150,
                            fontWeight: FontWeight.w900),
                      ),
                      Row(
                        children: [
                          _timerButton(
                              icon: matchStore.isRaidRunning
                                  ? Icons.pause
                                  : Icons.play_arrow,
                              onPressed: matchStore.isRaidRunning
                                  ? matchStore.stopRaid
                                  : onStartRaid),
                          const SizedBox(width: 8),
                          _timerButton(
                              icon: Icons.refresh,
                              onPressed: matchStore.resetRaid),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(width: 24),

                  // Team B Panel
                  Expanded(
                    child: _teamPanel(
                      context,
                      configStore.teamB,
                      matchStore.teamBScore,
                      matchStore.teamBFouls,
                      () => matchStore.incrementScoreB(),
                      () => matchStore.decrementScoreB(),
                      () => matchStore.recordFoulB(),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: matchStore.resetAll,
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF4D4D),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8))),
              child: const Text('RESET ALL DATA',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _soundButton(
      {required IconData icon,
      required String label,
      required VoidCallback onPressed}) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF2B2B33),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(color: Color(0xFF4A4A5A), width: 1),
        ),
      ),
      icon: Icon(icon, size: 20),
      label: Text(label),
    );
  }

  Widget _timerButton(
      {required IconData icon, required VoidCallback onPressed}) {
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

  Widget _teamPanel(
    BuildContext context,
    String teamName,
    int score,
    int fouls,
    VoidCallback onInc,
    VoidCallback onDec,
    VoidCallback onFoul,
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
      padding: const EdgeInsets.all(1.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: 00,
        children: [
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: [
          Text(
            teamName.toUpperCase(),
            style: TextStyle(
              color: Colors.white,
              fontSize: 50,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          // const SizedBox(width: 8),
          // const Icon(Icons.edit, color: Colors.white54, size: 24),
          //   ],
          // ),
          // const SizedBox(height: 15),
          Text(score.toString().padLeft(2, '0'),
              style: TextStyle(
                  color: Color(0xFF00FFAA),
                  fontSize: screenWidth < 600
                      ? 100
                      : screenWidth < 900
                          ? 175
                          : screenWidth < 1200
                              ? 250
                              : 275,
                  fontWeight: FontWeight.w900,
                  fontStyle: FontStyle.normal),
              maxLines: 1,
              textAlign: TextAlign.center),

          // const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _scoreButton(Icons.remove, onDec),
              const SizedBox(width: 16),
              _scoreButton(Icons.add, onInc),
            ],
          ),
          // const SizedBox(height: 48),
        ],
      ),
    );
  }

  Widget _scoreButton(IconData icon, VoidCallback onPressed) {
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
}
