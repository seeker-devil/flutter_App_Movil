import 'package:flutter/material.dart';
import 'app_router.dart';
import 'app_theme.dart';

class TrainingQuizApp extends StatelessWidget {
  const TrainingQuizApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Training & Quiz',
      theme: appTheme,
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
    );
  }
}
