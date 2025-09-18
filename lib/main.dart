import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/app.dart';
import 'store/config_store.dart';
import 'store/match_store.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ConfigStore()),
        ChangeNotifierProxyProvider<ConfigStore, MatchStore>(
          create: (context) => MatchStore(context.read<ConfigStore>()),
          update: (context, config, previous) => MatchStore(config),
        ),
      ],
      child: const KabaddiApp(),
    ),
  );
}
