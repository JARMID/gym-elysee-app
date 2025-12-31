import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../data/models/program_model.dart';

class WorkoutPlayerScreen extends ConsumerStatefulWidget {
  final ProgramModel program;
  final int weekNumber;
  final int dayNumber;

  const WorkoutPlayerScreen({
    super.key,
    required this.program,
    required this.weekNumber,
    required this.dayNumber,
  });

  @override
  ConsumerState<WorkoutPlayerScreen> createState() =>
      _WorkoutPlayerScreenState();
}

class _WorkoutPlayerScreenState extends ConsumerState<WorkoutPlayerScreen> {
  int _currentExercise = 0;
  bool _isResting = false;
  int _restSeconds = 60;
  Timer? _restTimer;
  int _completedSets = 0;

  // Mock exercises - in real app, fetch from API
  final List<Map<String, dynamic>> _exercises = [
    {'name': 'Squat', 'sets': 3, 'reps': '12', 'rest': 60, 'weight': 0.0},
    {
      'name': 'Développé Couché',
      'sets': 3,
      'reps': '10',
      'rest': 90,
      'weight': 0.0,
    },
    {
      'name': 'Rowing Barre',
      'sets': 3,
      'reps': '12',
      'rest': 60,
      'weight': 0.0,
    },
    {
      'name': 'Soulevé de Terre',
      'sets': 3,
      'reps': '8',
      'rest': 120,
      'weight': 0.0,
    },
    {
      'name': 'Développé Épaules',
      'sets': 3,
      'reps': '12',
      'rest': 60,
      'weight': 0.0,
    },
  ];

  @override
  void dispose() {
    _restTimer?.cancel();
    super.dispose();
  }

  void _startRestTimer() {
    setState(() {
      _isResting = true;
      _restSeconds = _exercises[_currentExercise]['rest'] as int;
    });

    _restTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_restSeconds > 0) {
          _restSeconds--;
        } else {
          _isResting = false;
          timer.cancel();
        }
      });
    });
  }

  void _skipRest() {
    _restTimer?.cancel();
    setState(() => _isResting = false);
  }

  void _completeSet() {
    setState(() {
      _completedSets++;
      if (_completedSets >= _exercises[_currentExercise]['sets']) {
        // Move to next exercise
        if (_currentExercise < _exercises.length - 1) {
          _currentExercise++;
          _completedSets = 0;
        } else {
          // Workout complete
          _showCompletionDialog();
        }
      } else {
        _startRestTimer();
      }
    });
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.celebration, color: Colors.amber),
            SizedBox(width: 8),
            Text('Bravo!'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 64),
            const SizedBox(height: 16),
            Text(
              'Tu as terminé la séance!',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Semaine ${widget.weekNumber} - Jour ${widget.dayNumber}',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.grey),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Go back to program detail
            },
            child: const Text('Terminer'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final exercise = _exercises[_currentExercise];
    final progress = (_currentExercise + 1) / _exercises.length;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text('Semaine ${widget.weekNumber} - Jour ${widget.dayNumber}'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Quitter', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
      body: Column(
        children: [
          // Progress bar
          LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.grey.shade800,
            color: Theme.of(context).colorScheme.primary,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Exercice ${_currentExercise + 1}/${_exercises.length}',
                  style: const TextStyle(color: Colors.grey),
                ),
                Text(
                  widget.program.name,
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),

          // Video placeholder area
          Expanded(
            flex: 3,
            child: Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade900,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.play_circle_outline,
                      size: 80,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Vidéo exercice',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Rest timer overlay
          if (_isResting)
            Container(
              padding: const EdgeInsets.all(24),
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              child: Column(
                children: [
                  const Text(
                    'REPOS',
                    style: TextStyle(letterSpacing: 4, color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '$_restSeconds',
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextButton(onPressed: _skipRest, child: const Text('Passer')),
                ],
              ),
            ),

          // Exercise info
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    exercise['name'],
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      _buildInfoChip(
                        Icons.repeat,
                        '${exercise['sets']} séries',
                      ),
                      const SizedBox(width: 12),
                      _buildInfoChip(
                        Icons.fitness_center,
                        '${exercise['reps']} reps',
                      ),
                      const SizedBox(width: 12),
                      _buildInfoChip(Icons.timer, '${exercise['rest']}s repos'),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Sets progress
                  Row(
                    children: List.generate(
                      exercise['sets'],
                      (index) => Expanded(
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          height: 8,
                          decoration: BoxDecoration(
                            color: index < _completedSets
                                ? Theme.of(context).colorScheme.primary
                                : Colors.grey.shade800,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Série ${_completedSets + 1} sur ${exercise['sets']}',
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),

          // Action button
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _isResting ? null : _completeSet,
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Text(
                  _completedSets >= exercise['sets'] - 1 &&
                          _currentExercise >= _exercises.length - 1
                      ? 'Terminer la séance'
                      : 'Série terminée ✓',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 4),
          Text(label, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}

