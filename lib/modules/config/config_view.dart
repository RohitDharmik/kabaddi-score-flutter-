import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../store/config_store.dart';

class ConfigView extends StatefulWidget {
  const ConfigView({super.key});

  @override
  State<ConfigView> createState() => _ConfigViewState();
}

class _ConfigViewState extends State<ConfigView> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _matchDurController;
  late TextEditingController _raidDurController;
  late TextEditingController _teamAController;
  late TextEditingController _teamBController;

  @override
  void initState() {
    super.initState();
    final config = context.read<ConfigStore>();
    _matchDurController =
        TextEditingController(text: config.matchMinutes.toString());
    _raidDurController =
        TextEditingController(text: config.raidSeconds.toString());
    _teamAController = TextEditingController(text: config.teamA);
    _teamBController = TextEditingController(text: config.teamB);
  }

  @override
  void dispose() {
    _matchDurController.dispose();
    _raidDurController.dispose();
    _teamAController.dispose();
    _teamBController.dispose();
    super.dispose();
  }

  void _onSave() {
    if (_formKey.currentState?.validate() ?? false) {
      final config = context.read<ConfigStore>();
      config.updateMatchTime(int.parse(_matchDurController.text));
      config.updateRaid(int.parse(_raidDurController.text));
      config.updateTeamA(_teamAController.text.trim());
      config.updateTeamB(_teamBController.text.trim());
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Settings saved')));
      Navigator.pop(context); // or stay, depending on your flow
    }
  }

  void _onResetDefaults() {
    final config = context.read<ConfigStore>();
    setState(() {
      _matchDurController.text = '20';
      _raidDurController.text = '30';
      _teamAController.text = 'Team A';
      _teamBController.text = 'Team B';
    });
    // Optionally update store too
    config.updateMatchTime(20);
    config.updateRaid(30);
    config.updateTeamA('Team A');
    config.updateTeamB('Team B');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: const Color(0xFF0F1115),
      appBar: AppBar(
        title: const Text('Configure Match'),
        backgroundColor: theme.primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Match Duration Field
              TextFormField(
                controller: _matchDurController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Match Duration (minutes)',
                  labelStyle: TextStyle(color: Colors.white70),
                  filled: true,
                  fillColor: Color(0xFF1E1E28),
                ),
                style: const TextStyle(color: Colors.white),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Enter match duration';
                  }
                  final v = int.tryParse(value);
                  if (v == null || v < 5 || v > 60) {
                    return 'Enter between 5 and 60';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              // Raid Duration Field
              TextFormField(
                controller: _raidDurController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Raid Duration (seconds)',
                  labelStyle: TextStyle(color: Colors.white70),
                  filled: true,
                  fillColor: Color(0xFF1E1E28),
                ),
                style: const TextStyle(color: Colors.white),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Enter raid duration';
                  }
                  final v = int.tryParse(value);
                  if (v == null || v < 10 || v > 60) {
                    return 'Enter between 10 and 60';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              // Team A Name
              TextFormField(
                controller: _teamAController,
                decoration: const InputDecoration(
                  labelText: 'Team A Name',
                  labelStyle: TextStyle(color: Colors.white70),
                  filled: true,
                  fillColor: Color(0xFF1E1E28),
                ),
                style: const TextStyle(color: Colors.white),
                validator: (value) {
                  if (value == null || value.trim().length < 2) {
                    return 'Team name too short';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              // Team B Name
              TextFormField(
                controller: _teamBController,
                decoration: const InputDecoration(
                  labelText: 'Team B Name',
                  labelStyle: TextStyle(color: Colors.white70),
                  filled: true,
                  fillColor: Color(0xFF1E1E28),
                ),
                style: const TextStyle(color: Colors.white),
                validator: (value) {
                  if (value == null || value.trim().length < 2) {
                    return 'Team name too short';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              // Buttons
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _onSave,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.primaryColor,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text('Save'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _onResetDefaults,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: theme.colorScheme.secondary,
                        side: BorderSide(color: theme.colorScheme.secondary),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text('Reset Defaults'),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
