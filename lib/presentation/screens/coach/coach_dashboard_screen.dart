import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../../providers/coach_provider.dart';
import '../../providers/auth_provider.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../data/models/program_model.dart';

class CoachDashboardScreen extends ConsumerWidget {
  const CoachDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardAsync = ref.watch(coachDashboardProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        children: [
          // Gradient Header
          Container(
            padding: const EdgeInsets.only(
              top: 50,
              left: 20,
              right: 20,
              bottom: 20,
            ),
            decoration: BoxDecoration(
              gradient: AppColors.fieryGradient,
              boxShadow: [
                BoxShadow(
                  color: AppColors.brandOrange.withValues(alpha: 0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'TABLEAU DE BORD',
                      style: GoogleFonts.oswald(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 1.5,
                      ),
                    ),
                    Text(
                      'Coach Panel',
                      style: GoogleFonts.inter(
                        color: Colors.white.withValues(alpha: 0.9),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.logout, color: Colors.white),
                  onPressed: () {
                    ref.read(authNotifierProvider.notifier).logout();
                  },
                ),
              ],
            ),
          ),

          // Dashboard Content
          Expanded(
            child: dashboardAsync.when(
              data: (data) =>
                  _buildDashboardContent(context, ref, data, isDark),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Erreur: $err',
                      style: const TextStyle(color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => ref.invalidate(coachDashboardProvider),
                      child: const Text('Réessayer'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardContent(
    BuildContext context,
    WidgetRef ref,
    Map<String, dynamic> data,
    bool isDark,
  ) {
    final stats = data['stats'] as Map<String, dynamic>? ?? {};
    final upcomingBookings = data['upcoming_bookings'] as List? ?? [];

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Stats Cards
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                'Séances Aujourd\'hui',
                stats['today_bookings']?.toString() ?? '0',
                Icons.calendar_today,
                isDark,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                'Total Élèves',
                stats['total_students']?.toString() ?? '0',
                Icons.people,
                isDark,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                'Note',
                '${stats['rating'] ?? 0}⭐',
                Icons.star,
                isDark,
              ),
            ),
          ],
        ),

        const SizedBox(height: 24),

        // Quick Actions
        Text(
          'ACTIONS RAPIDES',
          style: GoogleFonts.oswald(
            color: AppColors.brandOrange,
            fontSize: 14,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildActionCard(
                context,
                'Mon Équipe',
                Icons.groups,
                () => _showSquadSheet(context, ref),
                isDark,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildActionCard(
                context,
                'Mes Programmes',
                Icons.fitness_center,
                () => _showProgramsSheet(context, ref),
                isDark,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildActionCard(
                context,
                'Mon Planning',
                Icons.calendar_month,
                () => _showScheduleSheet(context, ref),
                isDark,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildActionCard(
                context,
                'Mes Réservations',
                Icons.book_online,
                () => _showBookingsSheet(context, ref),
                isDark,
              ),
            ),
          ],
        ),

        const SizedBox(height: 24),

        // Upcoming Bookings
        Text(
          'PROCHAINES SÉANCES',
          style: GoogleFonts.oswald(
            color: AppColors.brandOrange,
            fontSize: 14,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 12),
        if (upcomingBookings.isEmpty)
          Card(
            color: isDark ? Colors.grey[900] : Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Aucune séance prévue',
                style: GoogleFonts.inter(color: Colors.grey),
              ),
            ),
          )
        else
          ...upcomingBookings.map((booking) => _buildBookingCard(booking)),
      ],
    );
  }

  Widget _buildStatCard(
    String label,
    String value,
    IconData icon,
    bool isDark,
  ) {
    return Card(
      color: isDark ? Colors.grey[900] : Colors.white,
      elevation: isDark ? 0 : 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, color: AppColors.brandOrange, size: 28),
            const SizedBox(height: 8),
            Text(
              value,
              style: GoogleFonts.oswald(
                color: isDark ? Colors.white : Colors.black,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              label,
              style: GoogleFonts.inter(color: Colors.grey, fontSize: 10),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionCard(
    BuildContext context,
    String label,
    IconData icon,
    VoidCallback onTap,
    bool isDark,
  ) {
    return InkWell(
      onTap: onTap,
      child: Card(
        color: isDark ? Colors.grey[900] : Colors.white,
        elevation: isDark ? 0 : 2,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Icon(icon, color: AppColors.brandOrange, size: 32),
              const SizedBox(height: 8),
              Text(
                label,
                style: GoogleFonts.inter(
                  color: isDark ? Colors.white : Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBookingCard(dynamic booking) {
    final member = booking['member']?['user'];
    final memberName = member != null
        ? '${member['first_name']} ${member['last_name']}'
        : 'Membre';
    final scheduledAt = booking['scheduled_at'] ?? '';

    return Card(
      color: Colors.grey[900],
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppColors.brandOrange,
          child: Text(
            memberName.isNotEmpty ? memberName[0].toUpperCase() : 'M',
            style: const TextStyle(color: Colors.black),
          ),
        ),
        title: Text(memberName, style: const TextStyle(color: Colors.white)),
        subtitle: Text(scheduledAt, style: TextStyle(color: Colors.grey[400])),
        trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      ),
    );
  }

  void _showSquadSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.grey[900],
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) {
          final squadAsync = ref.watch(coachSquadProvider);
          return Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'MON ÉQUIPE',
                  style: GoogleFonts.oswald(
                    color: AppColors.brandOrange,
                    fontSize: 18,
                    letterSpacing: 1,
                  ),
                ),
              ),
              Expanded(
                child: squadAsync.when(
                  data: (squad) => ListView.builder(
                    controller: scrollController,
                    itemCount: squad.length,
                    itemBuilder: (context, index) {
                      final member = squad[index];
                      final firstName = member.user?.firstName ?? '';
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: AppColors.brandOrange,
                          child: Text(
                            firstName.isNotEmpty
                                ? firstName[0].toUpperCase()
                                : 'M',
                            style: const TextStyle(color: Colors.black),
                          ),
                        ),
                        title: Text(
                          member.user?.fullName ?? 'Membre',
                          style: const TextStyle(color: Colors.white),
                        ),
                        subtitle: Text(
                          member.level,
                          style: TextStyle(color: Colors.grey[400]),
                        ),
                      );
                    },
                  ),
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (err, _) => Center(
                    child: Text(
                      'Erreur: $err',
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showProgramsSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.grey[900],
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) {
          final programsAsync = ref.watch(coachProgramsProvider);
          return Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'MES PROGRAMMES',
                      style: GoogleFonts.oswald(
                        color: AppColors.brandOrange,
                        fontSize: 18,
                        letterSpacing: 1,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add, color: AppColors.brandOrange),
                      onPressed: () {
                        _showCreateProgramDialog(context, ref);
                      },
                    ),
                  ],
                ),
              ),
              Expanded(
                child: programsAsync.when(
                  data: (programs) => ListView.builder(
                    controller: scrollController,
                    itemCount: programs.length,
                    itemBuilder: (context, index) {
                      final program = programs[index];
                      return Card(
                        color: Colors.grey[850],
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 4,
                        ),
                        child: ListTile(
                          title: Text(
                            program.name,
                            style: const TextStyle(color: Colors.white),
                          ),
                          subtitle: Text(
                            '${program.level} • ${program.type}',
                            style: TextStyle(color: Colors.grey[400]),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '${program.sessionsPerWeek}x/sem',
                                style: const TextStyle(
                                  color: AppColors.brandOrange,
                                ),
                              ),
                              const SizedBox(width: 8),
                              IconButton(
                                icon: const Icon(
                                  Icons.edit,
                                  color: Colors.grey,
                                  size: 20,
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                  _showEditProgramDialog(context, ref, program);
                                },
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                  size: 20,
                                ),
                                onPressed: () {
                                  ref
                                      .read(coachControllerProvider.notifier)
                                      .deleteProgram(program.id);
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (err, _) => Center(
                    child: Text(
                      'Erreur: $err',
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showScheduleSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.grey[900],
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) {
          final scheduleAsync = ref.watch(coachScheduleProvider);
          return Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'MON PLANNING',
                  style: GoogleFonts.oswald(
                    color: AppColors.brandOrange,
                    fontSize: 18,
                    letterSpacing: 1,
                  ),
                ),
              ),
              Expanded(
                child: scheduleAsync.when(
                  data: (scheduleData) {
                    final schedule =
                        scheduleData['schedule'] as Map<String, dynamic>? ?? {};
                    if (schedule.isEmpty) {
                      return Center(
                        child: Text(
                          'Aucune séance cette semaine',
                          style: GoogleFonts.inter(color: Colors.grey),
                        ),
                      );
                    }
                    final days = schedule.keys.toList()..sort();
                    return ListView.builder(
                      controller: scrollController,
                      itemCount: days.length,
                      itemBuilder: (context, index) {
                        final day = days[index];
                        final bookings = schedule[day] as List? ?? [];
                        return ExpansionTile(
                          title: Text(
                            day,
                            style: const TextStyle(color: Colors.white),
                          ),
                          subtitle: Text(
                            '${bookings.length} séance(s)',
                            style: TextStyle(color: Colors.grey[400]),
                          ),
                          children: bookings.map<Widget>((booking) {
                            final member = booking['member']?['user'];
                            final memberName = member != null
                                ? '${member['first_name']} ${member['last_name']}'
                                : 'Membre';
                            final time = booking['scheduled_at'] ?? '';
                            return ListTile(
                              leading: CircleAvatar(
                                backgroundColor: AppColors.brandOrange,
                                child: Text(
                                  memberName.isNotEmpty
                                      ? memberName[0].toUpperCase()
                                      : 'M',
                                  style: const TextStyle(color: Colors.black),
                                ),
                              ),
                              title: Text(
                                memberName,
                                style: const TextStyle(color: Colors.white),
                              ),
                              subtitle: Text(
                                time,
                                style: TextStyle(color: Colors.grey[400]),
                              ),
                              trailing: _buildStatusBadge(booking['status']),
                            );
                          }).toList(),
                        );
                      },
                    );
                  },
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (err, _) => Center(
                    child: Text(
                      'Erreur: $err',
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showBookingsSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.grey[900],
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) {
          final bookingsAsync = ref.watch(coachBookingsProvider(null));
          return Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'MES RÉSERVATIONS',
                  style: GoogleFonts.oswald(
                    color: AppColors.brandOrange,
                    fontSize: 18,
                    letterSpacing: 1,
                  ),
                ),
              ),
              Expanded(
                child: bookingsAsync.when(
                  data: (bookingsData) {
                    final bookings = bookingsData['data'] as List? ?? [];
                    if (bookings.isEmpty) {
                      return Center(
                        child: Text(
                          'Aucune réservation',
                          style: GoogleFonts.inter(color: Colors.grey),
                        ),
                      );
                    }
                    return ListView.builder(
                      controller: scrollController,
                      itemCount: bookings.length,
                      itemBuilder: (context, index) {
                        final booking = bookings[index];
                        final member = booking['member']?['user'];
                        final memberName = member != null
                            ? '${member['first_name']} ${member['last_name']}'
                            : 'Membre';
                        final scheduledAt = booking['scheduled_at'] ?? '';
                        final status = booking['status'] ?? 'pending';

                        return Card(
                          color: Colors.grey[850],
                          margin: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 4,
                          ),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: AppColors.brandOrange,
                              child: Text(
                                memberName.isNotEmpty
                                    ? memberName[0].toUpperCase()
                                    : 'M',
                                style: const TextStyle(color: Colors.black),
                              ),
                            ),
                            title: Text(
                              memberName,
                              style: const TextStyle(color: Colors.white),
                            ),
                            subtitle: Text(
                              scheduledAt,
                              style: TextStyle(color: Colors.grey[400]),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                _buildStatusBadge(status),
                                if (status == 'pending') ...[
                                  const SizedBox(width: 8),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.check_circle,
                                      color: Colors.green,
                                    ),
                                    onPressed: () {
                                      ref
                                          .read(
                                            coachControllerProvider.notifier,
                                          )
                                          .updateBooking(
                                            booking['id'],
                                            'confirmed',
                                          );
                                      Navigator.pop(context);
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.cancel,
                                      color: Colors.red,
                                    ),
                                    onPressed: () {
                                      ref
                                          .read(
                                            coachControllerProvider.notifier,
                                          )
                                          .updateBooking(
                                            booking['id'],
                                            'cancelled',
                                          );
                                      Navigator.pop(context);
                                    },
                                  ),
                                ],
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (err, _) => Center(
                    child: Text(
                      'Erreur: $err',
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildStatusBadge(String? status) {
    Color color;
    switch (status) {
      case 'confirmed':
        color = Colors.green;
        break;
      case 'cancelled':
        color = Colors.red;
        break;
      case 'completed':
        color = Colors.blue;
        break;
      default:
        color = Colors.orange;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        status ?? 'pending',
        style: TextStyle(color: color, fontSize: 12),
      ),
    );
  }

  void _showEditProgramDialog(
    BuildContext context,
    WidgetRef ref,
    ProgramModel program,
  ) {
    showDialog(
      context: context,
      builder: (context) => _EditProgramDialog(program: program),
    );
  }

  void _showCreateProgramDialog(BuildContext context, WidgetRef ref) {
    showDialog(context: context, builder: (context) => _CreateProgramDialog());
  }
}

class _CreateProgramDialog extends ConsumerStatefulWidget {
  @override
  ConsumerState<_CreateProgramDialog> createState() =>
      _CreateProgramDialogState();
}

class _CreateProgramDialogState extends ConsumerState<_CreateProgramDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  String _type = 'crossfit';
  String _level = 'Tous niveaux';
  int _sessionsPerWeek = 3;
  bool _isLoading = false;

  Future<void> _create() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    try {
      await ref.read(coachRepositoryProvider).createProgram({
        'name': _nameController.text,
        'description': _descController.text,
        'type': _type,
        'level': _level,
        'sessions_per_week': _sessionsPerWeek,
      });

      if (mounted) {
        Navigator.pop(context);
        ref.invalidate(coachProgramsProvider);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Programme créé!')));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Erreur: $e')));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return AlertDialog(
      title: Text(l10n.coachNewProgramTitle),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: l10n.coachProgramName),
                validator: (v) =>
                    v?.isNotEmpty == true ? null : l10n.commonRequired,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descController,
                decoration: InputDecoration(labelText: l10n.coachProgramDesc),
                maxLines: 2,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: _type,
                decoration: InputDecoration(labelText: l10n.coachProgramType),
                items: const [
                  DropdownMenuItem(value: 'crossfit', child: Text('CrossFit')),
                  DropdownMenuItem(value: 'boxing', child: Text('Boxe')),
                  DropdownMenuItem(value: 'mma', child: Text('MMA')),
                  DropdownMenuItem(
                    value: 'bodybuilding',
                    child: Text('Musculation'),
                  ),
                ],
                onChanged: (v) => setState(() => _type = v!),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: _level,
                decoration: InputDecoration(labelText: l10n.coachProgramLevel),
                items: [
                  DropdownMenuItem(
                    value: 'Débutant',
                    child: Text(l10n.programLevelBeginner),
                  ),
                  DropdownMenuItem(
                    value: 'Intermédiaire',
                    child: Text(l10n.programLevelIntermediate),
                  ),
                  DropdownMenuItem(
                    value: 'Avancé',
                    child: Text(l10n.programLevelAdvanced),
                  ),
                  DropdownMenuItem(
                    value: 'Tous niveaux',
                    child: Text(l10n.adminProgramsAllLevels),
                  ),
                ],
                onChanged: (v) => setState(() => _level = v!),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<int>(
                initialValue: _sessionsPerWeek,
                decoration: InputDecoration(
                  labelText: l10n.coachProgramSessions,
                ),
                items: [1, 2, 3, 4, 5, 6, 7]
                    .map((e) => DropdownMenuItem(value: e, child: Text('$e')))
                    .toList(),
                onChanged: (v) => setState(() => _sessionsPerWeek = v!),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.settingsCancel),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _create,
          child: _isLoading
              ? const CircularProgressIndicator()
              : Text(l10n.coachCreate),
        ),
      ],
    );
  }
}

class _EditProgramDialog extends ConsumerStatefulWidget {
  final ProgramModel program;

  const _EditProgramDialog({required this.program});

  @override
  ConsumerState<_EditProgramDialog> createState() => _EditProgramDialogState();
}

class _EditProgramDialogState extends ConsumerState<_EditProgramDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descController;
  late String _type;
  late String _level;
  late int _sessionsPerWeek;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.program.name);
    _descController = TextEditingController(text: widget.program.description);
    _type = widget.program.type;
    _level = widget.program.level;
    _sessionsPerWeek = widget.program.sessionsPerWeek;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    super.dispose();
  }

  Future<void> _update() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    try {
      await ref
          .read(coachControllerProvider.notifier)
          .updateProgram(widget.program.id, {
            'name': _nameController.text,
            'description': _descController.text,
            'type': _type,
            'level': _level,
            'sessions_per_week': _sessionsPerWeek,
          });

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Programme mis à jour!')));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Erreur: $e')));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return AlertDialog(
      title: const Text('Modifier le programme'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: l10n.coachProgramName),
                validator: (v) =>
                    v?.isNotEmpty == true ? null : l10n.commonRequired,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descController,
                decoration: InputDecoration(labelText: l10n.coachProgramDesc),
                maxLines: 2,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: _type,
                decoration: InputDecoration(labelText: l10n.coachProgramType),
                items: const [
                  DropdownMenuItem(value: 'crossfit', child: Text('CrossFit')),
                  DropdownMenuItem(value: 'boxing', child: Text('Boxe')),
                  DropdownMenuItem(value: 'mma', child: Text('MMA')),
                  DropdownMenuItem(
                    value: 'bodybuilding',
                    child: Text('Musculation'),
                  ),
                ],
                onChanged: (v) => setState(() => _type = v!),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: _level,
                decoration: InputDecoration(labelText: l10n.coachProgramLevel),
                items: [
                  DropdownMenuItem(
                    value: 'beginner',
                    child: Text(l10n.programLevelBeginner),
                  ),
                  DropdownMenuItem(
                    value: 'intermediate',
                    child: Text(l10n.programLevelIntermediate),
                  ),
                  DropdownMenuItem(
                    value: 'advanced',
                    child: Text(l10n.programLevelAdvanced),
                  ),
                  DropdownMenuItem(
                    value: 'pro',
                    child: Text(l10n.adminProgramsAllLevels),
                  ),
                ],
                onChanged: (v) => setState(() => _level = v!),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<int>(
                initialValue: _sessionsPerWeek,
                decoration: InputDecoration(
                  labelText: l10n.coachProgramSessions,
                ),
                items: [1, 2, 3, 4, 5, 6, 7]
                    .map((e) => DropdownMenuItem(value: e, child: Text('$e')))
                    .toList(),
                onChanged: (v) => setState(() => _sessionsPerWeek = v!),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.settingsCancel),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _update,
          child: _isLoading
              ? const CircularProgressIndicator()
              : const Text('Enregistrer'),
        ),
      ],
    );
  }
}
