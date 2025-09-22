import 'package:flutter/material.dart';

import 'router.dart';
import 'theme.dart';

class KabaddiApp extends StatelessWidget {
  const KabaddiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BARIHA DIGITAL',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      initialRoute: '/',
      onGenerateRoute: AppRouter.generateRoute,
    );
  }
}
