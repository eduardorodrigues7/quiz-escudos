import 'dart:math';

import 'package:flutter/material.dart';

import '../data/teams.dart';
import '../main.dart';
import '../models/team.dart';
import '../widgets/team_shield.dart';
import 'result_screen.dart';

class Question {
  final Team correct;
  final List<Team> options;

  const Question({required this.correct, required this.options});
}

class QuizScreen extends StatefulWidget {
  final int totalQuestions;

  const QuizScreen({super.key, required this.totalQuestions});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final Random _random = Random();
  late final List<Question> _questions = _buildQuestions();

  int _index = 0;
  int _score = 0;
  Team? _selected;
  bool _hintVisible = false;

  /// Sorteia os times e monta 4 alternativas para cada rodada.
  List<Question> _buildQuestions() {
    final pool = List<Team>.from(kTeams)..shuffle(_random);
    final total = min(widget.totalQuestions, pool.length);

    return pool.take(total).map((correct) {
      final distractors = List<Team>.from(kTeams)
        ..remove(correct)
        ..shuffle(_random);
      final options = <Team>[correct, ...distractors.take(3)]..shuffle(_random);
      return Question(correct: correct, options: options);
    }).toList();
  }

  Question get _current => _questions[_index];
  bool get _answered => _selected != null;
  bool get _isLast => _index == _questions.length - 1;

  void _answer(Team team) {
    if (_answered) return;
    setState(() {
      _selected = team;
      if (team == _current.correct) _score++;
    });
  }

  void _next() {
    if (_isLast) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => ResultScreen(score: _score, total: _questions.length),
        ),
      );
      return;
    }
    setState(() {
      _index++;
      _selected = null;
      _hintVisible = false;
    });
  }

  Color _optionColor(Team option) {
    if (!_answered) return AppColors.card;
    if (option == _current.correct) return AppColors.right;
    if (option == _selected) return AppColors.wrong;
    return AppColors.card;
  }

  @override
  Widget build(BuildContext context) {
    final progress = (_index + (_answered ? 1 : 0)) / _questions.length;

    return Scaffold(
      appBar: AppBar(
        title: Text('Rodada ${_index + 1} de ${_questions.length}'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 18),
              child: Text(
                'Acertos: $_score',
                style: TextStyle(fontWeight: FontWeight.w700, color: AppColors.lime),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 8,
                  backgroundColor: AppColors.card,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.lime),
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 24),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [AppColors.pitch, AppColors.night],
                        ),
                      ),
                      child: Center(
                        child: TeamShield(team: _current.correct, size: 170),
                      ),
                    ),
                    const SizedBox(height: 18),
                    Text(
                      'De qual clube e este escudo?',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.chalk,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ..._current.options.map(_buildOption),
                    const SizedBox(height: 8),
                    if (!_answered)
                      TextButton.icon(
                        onPressed: () => setState(() => _hintVisible = true),
                        icon: const Icon(Icons.lightbulb_outline),
                        style: TextButton.styleFrom(foregroundColor: AppColors.lime),
                        label: Text(_hintVisible
                            ? '${_current.correct.nickname} (${_current.correct.state})'
                            : 'Ver dica'),
                      ),
                    if (_answered) _buildFeedback(),
                  ],
                ),
              ),
            ),
            if (_answered)
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
                child: SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: _next,
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.lime,
                      foregroundColor: AppColors.night,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      textStyle: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
                    ),
                    child: Text(_isLast ? 'Ver resultado' : 'Proxima rodada'),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildOption(Team option) {
    final background = _optionColor(option);
    final highlighted = background != AppColors.card;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: background,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () => _answer(option),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: highlighted ? Colors.transparent : AppColors.chalk.withOpacity(0.1),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    option.name,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
                if (_answered && option == _current.correct)
                  const Icon(Icons.check_circle, size: 22)
                else if (_answered && option == _selected)
                  const Icon(Icons.cancel, size: 22),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeedback() {
    final hit = _selected == _current.correct;
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 4),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: (hit ? AppColors.right : AppColors.wrong).withOpacity(0.14),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Text(
        hit
            ? 'Acertou. ${_current.correct.name} - ${_current.correct.nickname}.'
            : 'Era ${_current.correct.name} (${_current.correct.state}), o ${_current.correct.nickname}.',
        style: const TextStyle(fontSize: 14, height: 1.4),
      ),
    );
  }
}
