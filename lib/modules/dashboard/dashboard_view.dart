import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:zo_animated_border/zo_animated_border.dart';

import '../../store/config_store.dart';
import '../../store/match_store.dart';
import '../widgets/utiles.dart';

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
    _homePlayerStatus.clear();
    _awayPlayerStatus.clear();
    round = 1;

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

  void _playHalf(BuildContext context) async {
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
                        padding: const EdgeInsets.all(5.0),
                        child: Text(
                          textHeightBehavior: const TextHeightBehavior(
                              applyHeightToLastDescent: false,
                              applyHeightToFirstAscent: false,
                              leadingDistribution:
                                  TextLeadingDistribution.even),
                          configStore.feild,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 110),
                  Container(
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
                    padding: const EdgeInsets.all(5.0),
                    child: Text(
                      textHeightBehavior: const TextHeightBehavior(
                          applyHeightToLastDescent: false,
                          applyHeightToFirstAscent: false,
                          leadingDistribution: TextLeadingDistribution.even),
                      configStore.matchNo,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'digital7',
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
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
                      child: teamPanel(
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
                            fontFamily: 'digital7',
                          ),
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            timerButton(
                              icon: matchStore.isMatchRunning
                                  ? Icons.pause
                                  : Icons.play_arrow,
                              onPressed: matchStore.pauseAndPlay,
                            ),
                            const SizedBox(width: 8),
                            timerButton(
                              icon: Icons.refresh,
                              onPressed: matchStore.resetMatch,
                            ),
                          ],
                        ),
                        Text(
                          round.toString() + " half",
                          style: const TextStyle(
                            color: Color(0xFF4CAF50),
                            fontSize: 30,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: ZoAnimatedGradientBorder(
                            borderRadius: 16,
                            // duration: const Duration(seconds: 30),
                            gradientColor: [
                              Colors.red,
                              Colors.orange,
                              Colors.yellow,
                              Colors.green,
                              Colors.blue,
                              Colors.indigo,
                              Colors.purple,
                            ],
                            child: iconButton(Icons.sync, () {
                              matchStore.swapSides();
                              _playHalf(context);
                            }),
                          ),
                        ),
                        Text(
                          formatDurationRaid(matchStore.raidRemaining),
                          textHeightBehavior: const TextHeightBehavior(
                            applyHeightToLastDescent: false,
                            applyHeightToFirstAscent: false,
                          ),
                          style: TextStyle(
                            color: const Color.fromARGB(255, 255, 0, 0),
                            fontSize: screenWidth < 600
                                ? 150
                                : screenWidth < 900
                                    ? 170
                                    : 185,
                            fontWeight: FontWeight.w900,
                            fontFamily: 'digital7',
                          ),
                        ),
                        Row(
                          children: [
                            timerButton(
                              icon: matchStore.isRaidRunning
                                  ? Icons.pause
                                  : Icons.play_arrow,
                              onPressed: matchStore.pauseAndPlayRaid,
                            ),
                            const SizedBox(width: 4),
                            timerButton(
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
                      child: teamPanel(
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  soundButton(
                    icon: Icons.volume_up,
                    label: 'Do or Die',
                    onPressed: () => _playDoOrDieSound(context),
                  ),
                  // const SizedBox(width: 16),
                  soundButton(
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
}
