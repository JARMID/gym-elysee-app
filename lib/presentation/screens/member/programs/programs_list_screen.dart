import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gyelyseedz/l10n/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../data/models/program_model.dart';
import '../../../../data/repositories/program_repository.dart';
import '../../../providers/branch_provider.dart';
import '../../../providers/program_provider.dart';
import 'program_detail_screen.dart';

// Provider for programs
final programsProvider =
    FutureProvider.family<List<ProgramModel>, Map<String, dynamic>?>((
      ref,
      filters,
    ) async {
      final apiService = ref.watch(apiServiceProvider);
      final repository = ProgramRepository(apiService);
      return repository.getPrograms(
        type: filters?['type'],
        level: filters?['level'],
        // branchId can be added here if it becomes part of filters
      );
    });

class ProgramsListScreen extends ConsumerStatefulWidget {
  const ProgramsListScreen({super.key});

  @override
  ConsumerState<ProgramsListScreen> createState() => _ProgramsListScreenState();
}

class _ProgramsListScreenState extends ConsumerState<ProgramsListScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String? _selectedLevel;
  String? _selectedType;

  final List<String> _levels = ['beginner', 'intermediate', 'advanced', 'pro'];
  final List<String> _types = [
    'strength',
    'cardio',
    'boxing',
    'mma',
    'grappling',
    'hybrid',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Map<String, dynamic>? get _filters {
    final filters = <String, dynamic>{};
    if (_selectedLevel != null) filters['level'] = _selectedLevel;
    if (_selectedType != null) filters['type'] = _selectedType;
    return filters.isEmpty ? null : filters;
  }

  @override
  Widget build(BuildContext context) {
    final programsAsync = ref.watch(programsProvider(_filters));
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        children: [
          // Custom Gradient Header
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
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      l10n.programsTitle,
                      style: GoogleFonts.oswald(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 1.5,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.filter_list, color: Colors.white),
                      onPressed: _showFiltersBottomSheet,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TabBar(
                  controller: _tabController,
                  indicatorColor: Colors.white,
                  indicatorWeight: 3,
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.white.withValues(alpha: 0.7),
                  labelStyle: GoogleFonts.oswald(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                  tabs: [
                    Tab(text: l10n.programsTabDiscover),
                    Tab(text: l10n.programsTabMyPrograms),
                    Tab(text: l10n.programsTabHistory),
                  ],
                ),
              ],
            ),
          ),

          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildProgramsGrid(programsAsync),
                _buildMyPrograms(),
                _buildHistory(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgramsGrid(AsyncValue<List<ProgramModel>> programsAsync) {
    final l10n = AppLocalizations.of(context)!;
    return programsAsync.when(
      loading: () => _buildLoadingGrid(),
      error: (error, stack) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text(l10n.programsError(error.toString())),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => ref.refresh(programsProvider(_filters)),
              child: Text(l10n.programsRetry),
            ),
          ],
        ),
      ),
      data: (programs) {
        if (programs.isEmpty) {
          return _buildEmptyState();
        }
        return RefreshIndicator(
          onRefresh: () async => ref.refresh(programsProvider(_filters)),
          child: GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.75,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: programs.length,
            itemBuilder: (context, index) => _buildProgramCard(programs[index]),
          ),
        );
      },
    );
  }

  Widget _buildProgramCard(ProgramModel program) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ProgramDetailScreen(program: program),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark
                ? Colors.white.withValues(alpha: 0.05)
                : Colors.grey.withValues(alpha: 0.2),
          ),
          boxShadow: [
            BoxShadow(
              color: isDark
                  ? Colors.black.withValues(alpha: 0.3)
                  : Colors.grey.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  program.coverImage != null
                      ? CachedNetworkImage(
                          imageUrl: program.coverImage!,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            color: const Color(0xFF2C2C2C),
                            child: const Center(
                              child: CircularProgressIndicator(
                                color: AppColors.brandOrange,
                              ),
                            ),
                          ),
                          errorWidget: (context, url, error) => Image.asset(
                            'assets/images/program_${program.type}.jpg',
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                _buildPlaceholderImage(),
                          ),
                        )
                      : Image.asset(
                          'assets/images/program_${program.type}.jpg',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              _buildPlaceholderImage(),
                        ),
                  // Gradient Overlay
                  Positioned.fill(
                    child: Container(
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
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: _getLevelColor(program.level),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.5),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      child: Text(
                        _getLevelLabel(program.level).toUpperCase(),
                        style: GoogleFonts.oswald(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      program.name.toUpperCase(),
                      style: GoogleFonts.oswald(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.person,
                          size: 12,
                          color: AppColors.brandOrange,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            program.coachName,
                            style: GoogleFonts.inter(
                              color: isDark
                                  ? Colors.grey[400]
                                  : Colors.grey[600],
                              fontSize: 12,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        Icon(
                          Icons.star,
                          size: 14,
                          color: AppColors.brandYellow,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          program.rating.toStringAsFixed(1),
                          style: GoogleFonts.inter(
                            color: isDark ? Colors.white : Colors.black,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        Icon(
                          Icons.people,
                          size: 14,
                          color: isDark ? Colors.grey[500] : Colors.grey,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${program.enrolledCount}',
                          style: GoogleFonts.inter(
                            color: isDark ? Colors.grey[500] : Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholderImage() {
    return Container(
      color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
      child: Icon(
        Icons.fitness_center,
        size: 48,
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  Widget _buildLoadingGrid() {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: 6,
      itemBuilder: (context, index) => Shimmer.fromColors(
        baseColor: Colors.grey.shade800,
        highlightColor: Colors.grey.shade700,
        child: Card(child: Container()),
      ),
    );
  }

  Widget _buildEmptyState() {
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.fitness_center, size: 64, color: Colors.grey.shade600),
          const SizedBox(height: 16),
          Text(
            l10n.programsEmpty,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            l10n.programsEmptyHint,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildMyPrograms() {
    final myProgramsAsync = ref.watch(myProgramsProvider);
    final l10n = AppLocalizations.of(context)!;

    return myProgramsAsync.when(
      loading: () => _buildLoadingGrid(),
      error: (error, stack) =>
          Center(child: Text(l10n.programsError(error.toString()))),
      data: (programs) {
        if (programs.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.fitness_center,
                  size: 64,
                  color: Colors.grey.shade600,
                ),
                const SizedBox(height: 16),
                Text(
                  l10n.programNoEnrollments,
                  style: Theme.of(
                    context,
                  ).textTheme.titleMedium?.copyWith(color: Colors.white),
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () =>
                      _tabController.animateTo(0), // Switch to Discover
                  child: Text(
                    l10n.programDiscoverCta,
                    style: TextStyle(color: AppColors.brandOrange),
                  ),
                ),
              ],
            ),
          );
        }
        return RefreshIndicator(
          onRefresh: () async => ref.refresh(myProgramsProvider),
          child: GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.75,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: programs.length,
            itemBuilder: (context, index) => _buildProgramCard(programs[index]),
          ),
        );
      },
    );
  }

  Widget _buildHistory() {
    final l10n = AppLocalizations.of(context)!;
    return Center(child: Text(l10n.programsPlaceholderHistory));
  }

  void _showFiltersBottomSheet() {
    final l10n = AppLocalizations.of(context)!;
    showModalBottomSheet(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.programsFilterTitle,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 24),
              Text(
                l10n.programsFilterLevel,
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: _levels
                    .map(
                      (level) => FilterChip(
                        label: Text(_getLevelLabel(level)),
                        selected: _selectedLevel == level,
                        onSelected: (selected) => setModalState(
                          () => _selectedLevel = selected ? level : null,
                        ),
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 16),
              Text(
                l10n.programsFilterType,
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: _types
                    .map(
                      (type) => FilterChip(
                        label: Text(_getTypeLabel(type)),
                        selected: _selectedType == type,
                        onSelected: (selected) => setModalState(
                          () => _selectedType = selected ? type : null,
                        ),
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {});
                    Navigator.pop(context);
                  },
                  child: Text(l10n.programsFilterApply),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getLevelColor(String level) => switch (level) {
    'beginner' => Colors.green,
    'intermediate' => Colors.orange,
    'advanced' => Colors.red,
    'pro' => Colors.purple,
    _ => Colors.grey,
  };

  String _getLevelLabel(String level) {
    final l10n = AppLocalizations.of(context)!;
    return switch (level) {
      'beginner' => l10n.programLevelBeginner,
      'intermediate' => l10n.programLevelIntermediate,
      'advanced' => l10n.programLevelAdvanced,
      'pro' => l10n.programLevelPro,
      _ => level,
    };
  }

  String _getTypeLabel(String type) {
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
}
