import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../store/config_store.dart';
import '../../store/match_store.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  int round = 1;
  final FocusNode _focusNode = FocusNode();
  List<bool> _homePlayerStatus = List.generate(7, (index) => true);
  List<bool> _awayPlayerStatus = List.generate(7, (index) => true);

  String formatDuration(Duration d) {
    final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  String formatDurationRaid(Duration d) {
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$seconds';
  }

  @override
  void initState() {
    super.initState();
    _focusNode.requestFocus();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void _playBuzzerSound(BuildContext context) {
    final player = AudioPlayer();
    player.play(AssetSource('sounds/buzzer.mp3'));
  }

  void _playDoOrDieSound(BuildContext context) {
    final player = AudioPlayer();
    player.play(AssetSource('sounds/doordie2.mp3'));
  }

  void _playHalfTimerSound(BuildContext context) async {
    final player = AudioPlayer();
    player.play(AssetSource('sounds/halftime.mp3'));
    setState(() {
      round = 2;
    });
  }

  @override
  Widget build(BuildContext context) {
    final matchStore = context.watch<MatchStore>();
    final configStore = context.watch<ConfigStore>();

    final screenWidth = MediaQuery.of(context).size.width;

    return RawKeyboardListener(
      focusNode: _focusNode,
      onKey: (RawKeyEvent event) {
        if (event is RawKeyDownEvent) {
          if (event.logicalKey == LogicalKeyboardKey.keyN) {
            final ms = context.read<MatchStore>();
            ms.pauseAndPlay();
            ms.pauseAndPlayRaid();
          }
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF0F1115),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ElevatedButton.icon(
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: 15,
                    ),
                    onPressed: () => matchStore.back(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4CAF50),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                    ),
                    label: const Text(
                      "Back",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w800),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E1E28),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                              color: const Color(0xFF3A3A4A), width: 1.5),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          round.toString(),
                          style: const TextStyle(
                            color: Color(0xFF4CAF50),
                            fontSize: 40,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 110),
                ],
              ),
              const SizedBox(height: 5),

              // Scoreboard and Timers Section
              Expanded(
                flex: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Team A Panel
                    Expanded(
                      child: _teamPanel(
                        context,
                        configStore.teamA,
                        matchStore.teamAScore,
                        matchStore.teamAFouls,
                        _homePlayerStatus,
                        () => matchStore.incrementScoreA(),
                        () => matchStore.decrementScoreA(),
                        () => matchStore.recordFoulA(),
                        (index) => setState(() {
                          _homePlayerStatus[index] = !_homePlayerStatus[index];
                        }),
                      ),
                    ),
                    const SizedBox(width: 24),

                    // Center Timer Section
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          formatDuration(matchStore.matchRemaining),
                          textHeightBehavior: const TextHeightBehavior(
                            applyHeightToLastDescent: false,
                            applyHeightToFirstAscent: false,
                          ),
                          style: TextStyle(
                            color: const Color(0xFF00FFAA),
                            fontSize: screenWidth < 600
                                ? 80
                                : screenWidth < 900
                                    ? 90
                                    : 120,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _timerButton(
                              icon: matchStore.isMatchRunning
                                  ? Icons.pause
                                  : Icons.play_arrow,
                              onPressed: matchStore.pauseAndPlay,
                            ),
                            const SizedBox(width: 8),
                            _timerButton(
                              icon: Icons.refresh,
                              onPressed: matchStore.resetMatch,
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: iconButton(Icons.sync, () {
                            matchStore.swapSides();
                          }),
                        ),
                        Text(
                          formatDurationRaid(matchStore.raidRemaining),
                          textHeightBehavior: const TextHeightBehavior(
                            applyHeightToLastDescent: false,
                            applyHeightToFirstAscent: false,
                          ),
                          style: TextStyle(
                            color: const Color(0xFF00E5FF),
                            fontSize: screenWidth < 600
                                ? 150
                                : screenWidth < 900
                                    ? 170
                                    : 190,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        Row(
                          children: [
                            _timerButton(
                              icon: matchStore.isRaidRunning
                                  ? Icons.pause
                                  : Icons.play_arrow,
                              onPressed: matchStore.pauseAndPlayRaid,
                            ),
                            const SizedBox(width: 4),
                            _timerButton(
                              icon: Icons.refresh,
                              onPressed: matchStore.resetRaid,
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(width: 14),

                    // Team B Panel
                    Expanded(
                      child: _teamPanel(
                        context,
                        configStore.teamB,
                        matchStore.teamBScore,
                        matchStore.teamBFouls,
                        _awayPlayerStatus,
                        () => matchStore.incrementScoreB(),
                        () => matchStore.decrementScoreB(),
                        () => matchStore.recordFoulB(),
                        (index) => setState(() {
                          _awayPlayerStatus[index] = !_awayPlayerStatus[index];
                        }),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _soundButton(
                    icon: Icons.volume_up,
                    label: 'Half Time',
                    onPressed: () => _playHalfTimerSound(context),
                  ),
                  const SizedBox(width: 16),
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
            ],
          ),
        ),
      ),
    );
  }

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

  Widget _soundButton({
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

  Widget _timerButton({
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

  Widget _teamPanel(
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
      padding: const EdgeInsets.all(1.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(0.0),
            child: Text(
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
                            ? 250
                            : 275,
                fontWeight: FontWeight.w900,
              ),
              maxLines: 1,
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 10),
          _playerStatusRow(playerStatuses, onPlayerTap),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _scoreButton(Icons.remove, onDec),
              const SizedBox(width: 16),
              _scoreButton(Icons.add, onInc),
            ],
          ),
          const SizedBox(height: 10),
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

  Widget _playerStatusRow(
      List<bool> playerStatuses, Function(int) onPlayerTap) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
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
              size: 28,
            ),
          ),
        );
      }),
    );
  }
}
