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
  List<bool> teamADots = [true, true, true];
  List<bool> teamBDots = [true, true, true];
  int teamADotIndex = 0;
  int teamBDotIndex = 0;
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
        if (event is! RawKeyDownEvent) return;

        final ms = context.read<MatchStore>();

        switch (event.logicalKey) {
          // Match Timer Start/Pause
          case LogicalKeyboardKey.keyN:
            ms.pauseAndPlay();
            ms.pauseAndPlayRaid();
            break;

          // Team A +1
          case LogicalKeyboardKey.keyF:
            ms.incrementScoreA();
            break;

          // Team A -1
          case LogicalKeyboardKey.keyD:
            ms.decrementScoreA();
            break;

          // Team B +1
          case LogicalKeyboardKey.keyJ:
            ms.incrementScoreB();
            break;

          // Team B -1
          case LogicalKeyboardKey.keyK:
            ms.decrementScoreB();
            break;

          // Do or Die Sound
          case LogicalKeyboardKey.keyZ:
            _playDoOrDieSound(context);
            break;

          // Buzzer Sound
          case LogicalKeyboardKey.keyX:
            _playBuzzerSound(context);
            break;

          case LogicalKeyboardKey.keyT:
            matchStore.pauseAndPlay();
            break;

          case LogicalKeyboardKey.keyY:
            matchStore.resetMatch();
            break;

          case LogicalKeyboardKey.keyG:
            matchStore.pauseAndPlayRaid();
            break;
          case LogicalKeyboardKey.keyH:
            matchStore.resetRaid();
            break;

// index problem
          // Team B Green (Undo last red)
          case LogicalKeyboardKey.keyO:
            matchStore.inNextPlayerB();
            break;

// Team B Red
          case LogicalKeyboardKey.keyP:
            matchStore.outNextPlayerB();
            break;

// Team A Green (Undo last red)
          case LogicalKeyboardKey.keyW:
            matchStore.inNextPlayerA();
            break;

// Team A Red
          case LogicalKeyboardKey.keyQ:
            matchStore.outNextPlayerA();
            break;

          //team a dot green
          case LogicalKeyboardKey.keyE:
            setState(() {
              final idx = teamADots.lastIndexOf(false);

              if (idx != -1) {
                teamADots[idx] = true;
              }
            });
            break;
          //team a dot red
          case LogicalKeyboardKey.keyR:
            setState(() {
              final idx = teamADots.indexOf(true);

              if (idx != -1) {
                teamADots[idx] = false;
              }
            });
            break;
          //team b dot green
          case LogicalKeyboardKey.keyU:
            setState(() {
              final idx = teamBDots.lastIndexOf(false);

              if (idx != -1) {
                teamBDots[idx] = true;
              }
            });
            break;
          //team b dot red
          case LogicalKeyboardKey.keyI:
            setState(() {
              final idx = teamBDots.indexOf(true);

              if (idx != -1) {
                teamBDots[idx] = false;
              }
            });
            break;
          // case LogicalKeyboardKey.keyH:
          //   matchStore.resetRaid;
          //   break;

          default:
            break;
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF0F1115),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ElevatedButton.icon(
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: 15,
                      ),
                      onPressed: () => matchStore.back(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 16),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                      ),
                      label: const Text(
                        "Back",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontFamily: 'digital7',
                        ),
                      ),
                    ),
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
                        configStore.feild,
                        style: TextStyle(
                          color: Color(0xFF00FFAA),
                          shadows: [
                            // Added text shadow for glow effect
                            BoxShadow(
                              color: Color(0xFF00FF00).withOpacity(0.5),
                              blurRadius: 15,
                            ),
                          ],
                          fontSize: 45,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'digital7',
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    // const SizedBox(width: 100),
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
                      padding: const EdgeInsets.only(
                          bottom: 2.0, top: 2.0, left: 5, right: 5.0),
                      child: Text(
                        textHeightBehavior: const TextHeightBehavior(
                            applyHeightToLastDescent: false,
                            applyHeightToFirstAscent: false,
                            leadingDistribution: TextLeadingDistribution.even),
                        configStore.matchNo,
                        style: TextStyle(
                          color: Color(0xFF00FFAA),
                          shadows: [
                            // Added text shadow for glow effect
                            BoxShadow(
                              color: Color(0xFF00FFCC).withOpacity(1),
                              blurRadius: 25,
                              spreadRadius: 1,
                            ),
                          ],
                          fontSize: 50,
                          fontWeight: FontWeight.w900,
                          fontFamily: 'digital7',
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
              // const SizedBox(height: 10),

              // Scoreboard and Timers Section
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    // Team A Panel
                    Expanded(
                      child: teamPanel(
                        context,
                        configStore.teamA,
                        matchStore.teamAScore,
                        matchStore.teamAFouls,
                        matchStore.teamAPlayerStatuses,
                        () => matchStore.incrementScoreA(),
                        () => matchStore.decrementScoreA(),
                        () => matchStore.recordFoulA(),
                        (index) => matchStore.togglePlayer(true, index),
                      ),
                    ),
                    const SizedBox(width: 14),

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
                            color: Color(0xFF00FFAA),
                            shadows: [
                              // Added text shadow for glow effect
                              BoxShadow(
                                color: Color(0xFF00FF00).withOpacity(0.5),
                                blurRadius: 15,
                              ),
                            ],
                            fontSize: screenWidth < 600
                                ? 80
                                : screenWidth < 900
                                    ? 90
                                    : 120,
                            fontWeight: FontWeight.w900,
                            fontFamily: 'digital7',
                          ),
                        ),
                        SizedBox(),
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
                        Container(
                          decoration: BoxDecoration(),
                          child: Text(
                            round.toString() + " HALF",
                            style: TextStyle(
                              color: Color(0xFF4CAF50),
                              fontSize: 60,
                              fontWeight: FontWeight.w900,
                              fontFamily: 'digital7',
                              shadows: [
                                // Added text shadow for glow effect
                                BoxShadow(
                                  color: Color(0xFF00FFCC).withOpacity(1),
                                  blurRadius: 25,
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
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

                              setState(() {
                                final tmp = _homePlayerStatus;
                                _homePlayerStatus = _awayPlayerStatus;
                                _awayPlayerStatus = tmp;
                              });
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
                            color: const Color(0xFFFF0000),
                            fontSize: screenWidth < 600
                                ? 150
                                : screenWidth < 900
                                    ? 170
                                    : 185,
                            fontWeight: FontWeight.w900,
                            fontFamily: 'digital7',
                            shadows: [
                              // Added text shadow for glow effect
                              BoxShadow(
                                color: Color(0xFFFF0000).withOpacity(1),
                                blurRadius: 15,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(),
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
                        matchStore.teamBPlayerStatuses,
                        () => matchStore.incrementScoreB(),
                        () => matchStore.decrementScoreB(),
                        () => matchStore.recordFoulB(),
                        (index) => matchStore.togglePlayer(false, index),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      spacing: 20.00,
                      children: [
                        soundButton(
                          icon: Icons.volume_up,
                          label: 'Do or Die',
                          onPressed: () => _playDoOrDieSound(context),
                        ),
                        teamDots(
                          teamName: configStore.teamA,
                          dots: teamADots,
                          onTap: (index) {
                            setState(() {
                              teamADots[index] = !teamADots[index];
                            });
                          },
                        ),
                      ]),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      spacing: 20.00,
                      children: [
                        teamDots(
                          teamName: configStore.teamB,
                          dots: teamBDots,
                          onTap: (index) {
                            setState(() {
                              teamBDots[index] = !teamBDots[index];
                            });
                          },
                        ),
                        soundButton(
                          icon: Icons.notifications_active,
                          label: 'Buzzer',
                          onPressed: () => _playBuzzerSound(context),
                        ),
                      ])

                  // const SizedBox(width: 16),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
