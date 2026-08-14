import 'package:flutter/material.dart';

import '../main.dart';
import 'quiz_screen.dart';

class ResultScreen extends StatelessWidget {
  final int score;
  final int total;

  const ResultScreen({super.key, required this.score, required this.total});

  String get _message {
    final ratio = score / total;
    if (ratio == 1) return 'Campeao brasileiro. Gabaritou o quiz.';
    if (ratio >= 0.7) return 'Vaga na Libertadores garantida.';
    if (ratio >= 0.4) return 'Meio de tabela. Da para melhorar na proxima rodada.';
    return 'Zona de rebaixamento. Bora treinar os escudos.';
  }

  @override
  Widget build(BuildContext context) {
    final percent = (score / total * 100).round();

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'FIM DE JOGO',
                style: TextStyle(
                  color: AppColors.lime,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 2.4,
                ),
              ),
              const SizedBox(height: 14),
              Text(
                '$score de $total',
                style: const TextStyle(fontSize: 56, fontWeight: FontWeight.w800, height: 1),
              ),
              const SizedBox(height: 8),
              Text(
                '$percent% de aproveitamento',
                style: TextStyle(fontSize: 16, color: AppColors.chalk.withOpacity(0.7)),
              ),
              const SizedBox(height: 20),
              Text(_message, style: const TextStyle(fontSize: 18, height: 1.4)),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () => Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (_) => QuizScreen(totalQuestions: total)),
                  ),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.lime,
                    foregroundColor: AppColors.night,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    textStyle: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
                  ),
                  child: const Text('Jogar de novo'),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.chalk,
                    side: BorderSide(color: AppColors.chalk.withOpacity(0.25)),
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  child: const Text('Voltar ao inicio'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
