import 'package:flutter/material.dart';

import 'screens/home_screen.dart';

void main() {
  runApp(const QuizEscudosApp());
}

class AppColors {
  static const Color pitch = Color(0xFF0B3D2E);
  static const Color night = Color(0xFF0C1015);
  static const Color card = Color(0xFF161C24);
  static const Color lime = Color(0xFFB8FF3C);
  static const Color chalk = Color(0xFFF2F4F1);
  static const Color right = Color(0xFF2FBF71);
  static const Color wrong = Color(0xFFE05263);
}

class QuizEscudosApp extends StatelessWidget {
  const QuizEscudosApp({super.key});

  @override
  Widget build(BuildContext context) {
    final base = ThemeData(brightness: Brightness.dark, useMaterial3: true);

    return MaterialApp(
      title: 'Quiz dos Escudos',
      debugShowCheckedModeBanner: false,
      theme: base.copyWith(
        scaffoldBackgroundColor: AppColors.night,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.lime,
          brightness: Brightness.dark,
        ).copyWith(surface: AppColors.card),
        textTheme: base.textTheme.apply(
          bodyColor: AppColors.chalk,
          displayColor: AppColors.chalk,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
        ),
      ),
      home: const HomeScreen(),
    );
  }
}
