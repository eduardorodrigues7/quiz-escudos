import 'package:flutter/material.dart';

import '../data/teams.dart';
import '../main.dart';
import '../widgets/team_shield.dart';
import 'quiz_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _questions = 10;

  void _start() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => QuizScreen(totalQuestions: _questions)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 32, 24, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'BRASILEIRAO - SERIE A',
                style: TextStyle(
                  color: AppColors.lime,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 2.4,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Quiz dos\nEscudos',
                style: TextStyle(
                  fontSize: 44,
                  height: 1.05,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -1,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Mostramos o escudo. Voce diz de que time e.',
                style: TextStyle(fontSize: 16, color: AppColors.chalk.withOpacity(0.7)),
              ),
              const SizedBox(height: 28),
              Center(
                child: SizedBox(
                  height: 190,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Transform.translate(
                        offset: const Offset(-70, 8),
                        child: Transform.rotate(
                          angle: -0.22,
                          child: TeamShield(team: kTeams[0], size: 110),
                        ),
                      ),
                      Transform.translate(
                        offset: const Offset(70, 8),
                        child: Transform.rotate(
                          angle: 0.22,
                          child: TeamShield(team: kTeams[6], size: 110),
                        ),
                      ),
                      TeamShield(team: kTeams[1], size: 140),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 28),
              const Text(
                'Quantas rodadas?',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 12,
                children: [5, 10, 20].map((value) {
                  final selected = value == _questions;
                  return ChoiceChip(
                    label: Text('$value perguntas'),
                    selected: selected,
                    onSelected: (_) => setState(() => _questions = value),
                    labelStyle: TextStyle(
                      color: selected ? AppColors.night : AppColors.chalk,
                      fontWeight: FontWeight.w600,
                    ),
                    selectedColor: AppColors.lime,
                    backgroundColor: AppColors.card,
                    side: BorderSide(color: AppColors.chalk.withOpacity(0.12)),
                  );
                }).toList(),
              ),
              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _start,
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.lime,
                    foregroundColor: AppColors.night,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    textStyle: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
                  ),
                  child: const Text('Comecar a partida'),
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.chalk.withOpacity(0.08)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.sports_soccer, color: AppColors.lime),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        '${kTeams.length} clubes cadastrados. Cada escudo e desenhado no proprio app, sem imagens externas.',
                        style: TextStyle(fontSize: 13, color: AppColors.chalk.withOpacity(0.75)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
