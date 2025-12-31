import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:gyelyseedz/l10n/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../data/models/program_model.dart';
import '../../../providers/program_provider.dart';
import 'workout_player_screen.dart';

class ProgramDetailScreen extends ConsumerWidget {
  final ProgramModel program;

  const ProgramDetailScreen({super.key, required this.program});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Hero header with cover image
          SliverAppBar(
            expandedHeight: 250,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                program.name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  shadows: [Shadow(color: Colors.black54, blurRadius: 4)],
                ),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  program.coverImage != null
                      ? CachedNetworkImage(
                          imageUrl: program.coverImage!,
                          fit: BoxFit.cover,
                        )
                      : Container(
                          color: Theme.of(context).colorScheme.primary,
                          child: const Icon(
                            Icons.fitness_center,
                            size: 80,
                            color: Colors.white24,
                          ),
                        ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.7),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Program details
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Coach info
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 24,
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        backgroundImage: program.coachPhoto != null
                            ? CachedNetworkImageProvider(program.coachPhoto!)
                            : null,
                        child: program.coachPhoto == null
                            ? const Icon(Icons.person, color: Colors.white)
                            : null,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              program.coachName,
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              l10n.programCoach,
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                      // Rating
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.amber.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.star,
                              color: Colors.amber,
                              size: 18,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              program.rating.toStringAsFixed(1),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Stats row
                  Row(
                    children: [
                      _buildStatCard(
                        context,
                        Icons.calendar_month,
                        l10n.programWeeks(program.durationWeeks),
                        l10n.programDuration,
                      ),
                      const SizedBox(width: 12),
                      _buildStatCard(
                        context,
                        Icons.repeat,
                        '${program.sessionsPerWeek}x',
                        l10n.programPerWeek,
                      ),
                      const SizedBox(width: 12),
                      _buildStatCard(
                        context,
                        Icons.people,
                        '${program.enrolledCount}',
                        l10n.programEnrolled,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Type and Level badges
                  Wrap(
                    spacing: 8,
                    children: [
                      Chip(
                        avatar: Icon(_getTypeIcon(program.type), size: 18),
                        label: Text(_getTypeLabel(context, program.type)),
                      ),
                      Chip(
                        backgroundColor: _getLevelColor(
                          program.level,
                        ).withValues(alpha: 0.2),
                        label: Text(
                          _getLevelLabel(context, program.level),
                          style: TextStyle(
                            color: _getLevelColor(program.level),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Description
                  Text(
                    l10n.programDescription,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    program.description,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.grey.shade300
                          : Colors.grey.shade700,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Week breakdown (placeholder)
                  Text(
                    l10n.programSchedule,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 12),
                  ...List.generate(
                    program.durationWeeks,
                    (weekIndex) => _buildWeekTile(context, weekIndex + 1),
                  ),
                  const SizedBox(height: 100), // Space for FAB
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: _buildFab(context, ref, l10n),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildFab(BuildContext context, WidgetRef ref, AppLocalizations l10n) {
    // Check enrollment status
    final myProgramsAsync = ref.watch(myProgramsProvider);
    final isEnrolled = myProgramsAsync.maybeWhen(
      data: (programs) => programs.any((p) => p.id == program.id),
      orElse: () => false,
    );

    // Check loading state of enrollment
    final enrollState = ref.watch(enrollControllerProvider);
    final isLoading = enrollState is AsyncLoading;

    if (isEnrolled) {
      return FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => WorkoutPlayerScreen(
                program: program,
                weekNumber: 1,
                dayNumber: 1,
              ),
            ),
          );
        },
        icon: const Icon(Icons.play_arrow),
        label: Text(l10n.programStart),
      );
    }

    return FloatingActionButton.extended(
      onPressed: isLoading
          ? null
          : () async {
              await ref
                  .read(enrollControllerProvider.notifier)
                  .enroll(program.id);

              if (context.mounted) {
                final state = ref.read(enrollControllerProvider);
                if (state is AsyncError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        l10n.programEnrollError(state.error.toString()),
                      ),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(l10n.programEnrollSuccess)),
                  );
                }
              }
            },
      icon: isLoading
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
              ),
            )
          : const Icon(Icons.add),
      label: Text(isLoading ? l10n.programJoining : l10n.programJoin),
      backgroundColor: AppColors.brandOrange,
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    IconData icon,
    String value,
    String label,
  ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            Text(
              label,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeekTile(BuildContext context, int weekNumber) {
    final l10n = AppLocalizations.of(context)!;
    return ExpansionTile(
      leading: CircleAvatar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: Text(
          l10n.programWeekShort(weekNumber),
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ),
      title: Text(l10n.programWeekTile(weekNumber)),
      subtitle: Text(
        l10n.programSessionsCount(program.sessionsPerWeek),
        style: const TextStyle(color: Colors.grey),
      ),
      children: List.generate(
        program.sessionsPerWeek,
        (dayIndex) => ListTile(
          leading: const Icon(Icons.fitness_center),
          title: Text(l10n.programDayTile(dayIndex + 1)),
          subtitle: Text(l10n.programExercisesCount(5)),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => WorkoutPlayerScreen(
                  program: program,
                  weekNumber: weekNumber,
                  dayNumber: dayIndex + 1,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  IconData _getTypeIcon(String type) => switch (type) {
    'strength' => Icons.fitness_center,
    'cardio' => Icons.directions_run,
    'boxing' => Icons.sports_mma,
    'mma' => Icons.sports_kabaddi,
    'grappling' => Icons.sports_martial_arts,
    'hybrid' => Icons.all_inclusive,
    _ => Icons.sports,
  };

  String _getTypeLabel(BuildContext context, String type) {
    final l10n = AppLocalizations.of(context)!;
    return switch (type) {
      'strength' => l10n.programTypeStrength,
      'cardio' => l10n.programTypeCardio,
      'boxing' => l10n.programTypeBoxing,
      'mma' => l10n.programTypeMma,
      'grappling' => l10n.programTypeGrappling,
      'hybrid' => l10n.programTypeHybrid,
      _ => type,
    };
  }

  Color _getLevelColor(String level) => switch (level) {
    'beginner' => Colors.green,
    'intermediate' => Colors.orange,
    'advanced' => Colors.red,
    'pro' => Colors.purple,
    _ => Colors.grey,
  };

  String _getLevelLabel(BuildContext context, String level) {
    final l10n = AppLocalizations.of(context)!;
    return switch (level) {
      'beginner' => l10n.programLevelBeginner,
      'intermediate' => l10n.programLevelIntermediate,
      'advanced' => l10n.programLevelAdvanced,
      'pro' => l10n.programLevelPro,
      _ => level,
    };
  }
}
