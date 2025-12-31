import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gyelyseedz/l10n/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../data/models/member_model.dart';
import '../../../providers/sparring_provider.dart';

class SparringPartnerScreen extends ConsumerStatefulWidget {
  const SparringPartnerScreen({super.key});

  @override
  ConsumerState<SparringPartnerScreen> createState() =>
      _SparringPartnerScreenState();
}

class _SparringPartnerScreenState extends ConsumerState<SparringPartnerScreen> {
  String? _selectedWeight;

  final List<String> _disciplines = [
    'boxe',
    'mma',
    'jiu-jitsu',
    'lutte',
    'kickboxing',
  ];
  final List<String> _levels = [
    'débutant',
    'intermédiaire',
    'avancé',
    'compétition',
  ];
  final List<String> _weightClasses = [
    '< 60kg',
    '60-70kg',
    '70-80kg',
    '80-90kg',
    '> 90kg',
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final partnersAsync = ref.watch(sparringPartnersProvider);
    final currentFilters = ref.watch(partnerFiltersProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.sparringTitle,
                      style: GoogleFonts.oswald(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 1.5,
                      ),
                    ),
                    Text(
                      l10n.sparringSubtitle,
                      style: GoogleFonts.inter(
                        color: Colors.white.withValues(alpha: 0.9),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.inbox, color: Colors.white),
                  onPressed: () {},
                ),
              ],
            ),
          ),

          // Filters
          Container(
            padding: const EdgeInsets.all(16),
            color: isDark
                ? Colors.black.withValues(alpha: 0.3)
                : Colors.grey[200],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.sparringFilters,
                  style: GoogleFonts.oswald(
                    color: isDark ? Colors.grey[400] : Colors.grey[700],
                    fontSize: 12,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 12),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildFilterDropdown(
                        l10n.sparringFilterDiscipline,
                        _disciplines,
                        currentFilters.discipline,
                        (value) => ref
                            .read(partnerFiltersProvider.notifier)
                            .update(
                              (state) => PartnerFilters(
                                branchId: state.branchId,
                                discipline: value,
                                level: state.level,
                              ),
                            ),
                      ),
                      const SizedBox(width: 12),
                      _buildFilterDropdown(
                        l10n.sparringFilterLevel,
                        _levels,
                        currentFilters.level,
                        (value) => ref
                            .read(partnerFiltersProvider.notifier)
                            .update(
                              (state) => PartnerFilters(
                                branchId: state.branchId,
                                discipline: state.discipline,
                                level: value,
                              ),
                            ),
                      ),
                      const SizedBox(width: 12),
                      _buildFilterDropdown(
                        l10n.sparringFilterWeight,
                        _weightClasses,
                        _selectedWeight,
                        (value) => setState(() => _selectedWeight = value),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Partners list
          Expanded(
            child: partnersAsync.when(
              data: (partners) => partners.isEmpty
                  ? Center(
                      child: Text(
                        l10n.sparringNoPartners,
                        style: GoogleFonts.inter(
                          color: isDark ? Colors.white : Colors.black,
                        ),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: partners.length,
                      itemBuilder: (context, index) =>
                          _buildPartnerCard(partners[index]),
                    ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(
                child: Text(
                  'Erreur: $err',
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterDropdown(
    String label,
    List<String> items,
    String? selectedValue,
    ValueChanged<String?> onChanged,
  ) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: selectedValue != null
            ? AppColors.brandOrange.withValues(alpha: 0.2)
            : isDark
            ? Colors.white.withValues(alpha: 0.05)
            : Colors.white,
        border: Border.all(
          color: selectedValue != null
              ? AppColors.brandOrange
              : isDark
              ? Colors.white.withValues(alpha: 0.1)
              : Colors.grey[300]!,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          hint: Text(
            label,
            style: GoogleFonts.inter(
              color: isDark ? Colors.grey[400] : Colors.grey[600],
              fontSize: 13,
            ),
          ),
          value: selectedValue,
          dropdownColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
          style: GoogleFonts.inter(
            color: isDark ? Colors.white : Colors.black,
            fontSize: 13,
          ),
          icon: Icon(
            Icons.arrow_drop_down,
            color: selectedValue != null
                ? AppColors.brandOrange
                : isDark
                ? Colors.grey[400]
                : Colors.grey[600],
          ),
          items: [
            DropdownMenuItem(
              value: null,
              child: Text(
                l10n.bookingFilterAll,
                style: GoogleFonts.inter(
                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                ),
              ),
            ),
            ...items.map(
              (item) => DropdownMenuItem(
                value: item,
                child: Text(
                  item.substring(0, 1).toUpperCase() + item.substring(1),
                  style: GoogleFonts.inter(
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
              ),
            ),
          ],
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildPartnerCard(MemberModel partner) {
    final l10n = AppLocalizations.of(context)!;
    final name = partner.user?.fullName ?? 'Membre';
    final photo = partner.user?.photo;
    final discipline = partner.specializations?.isNotEmpty == true
        ? partner.specializations!.first
        : 'MMA';
    final branchName = partner.primaryBranch?.name ?? 'Unknown';
    final points = partner.loyaltyPoints;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
                ? Colors.black.withValues(alpha: 0.2)
                : Colors.grey.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                // Avatar
                Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: AppColors.fieryGradient,
                  ),
                  child: CircleAvatar(
                    radius: 32,
                    backgroundColor: const Color(0xFF2C2C2C),
                    backgroundImage: photo != null
                        ? CachedNetworkImageProvider(photo)
                        : null,
                    child: photo == null
                        ? Text(
                            name.substring(0, 1),
                            style: GoogleFonts.oswald(
                              fontSize: 24,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        : null,
                  ),
                ),
                const SizedBox(width: 16),
                // Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            name,
                            style: GoogleFonts.oswald(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: isDark ? Colors.white : Colors.black,
                            ),
                          ),
                          const Spacer(),
                          Icon(
                            Icons.star,
                            color: AppColors.brandYellow,
                            size: 16,
                          ),
                          Text(
                            ' ${points > 0 ? points : "New"}',
                            style: GoogleFonts.inter(
                              color: isDark ? Colors.white : Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        discipline.toUpperCase(),
                        style: GoogleFonts.inter(
                          color: isDark ? Colors.grey[400] : Colors.grey[600],
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: _getLevelColor(
                            partner.level,
                          ).withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(
                            color: _getLevelColor(
                              partner.level,
                            ).withValues(alpha: 0.5),
                          ),
                        ),
                        child: Text(
                          partner.level.toUpperCase(),
                          style: GoogleFonts.oswald(
                            color: _getLevelColor(partner.level),
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Stats
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.03)
                    : Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatItem('🥊', '$points', 'POINTS'),
                  _buildStatItem('📍', branchName, l10n.sparringBranch),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Action button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _showRequestDialog(partner),
                icon: const Icon(Icons.sports_mma, color: Colors.white),
                label: Text(
                  l10n.sparringRequestButton,
                  style: GoogleFonts.oswald(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
                style:
                    ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ).copyWith(
                      backgroundBuilder: (context, states, child) => Container(
                        decoration: BoxDecoration(
                          gradient: AppColors.fieryGradient,
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                        ),
                        child: child,
                      ),
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String emoji, String value, String label) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 20)),
        const SizedBox(height: 4),
        Text(
          value,
          style: GoogleFonts.oswald(
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black,
            fontSize: 16,
          ),
        ),
        Text(
          label.toUpperCase(),
          style: GoogleFonts.inter(
            color: isDark ? Colors.grey[500] : Colors.grey[600],
            fontSize: 9,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Color _getLevelColor(String level) {
    switch (level) {
      case 'débutant':
        return Colors.green;
      case 'intermédiaire':
        return AppColors.brandOrange;
      case 'avancé':
        return Colors.red;
      case 'compétition':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  void _showRequestDialog(MemberModel partner) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1E1E1E),
      isScrollControlled: true, // Allow keyboard to push it up
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: _SparringRequestSheet(partner: partner),
      ),
    );
  }
}

class _SparringRequestSheet extends ConsumerStatefulWidget {
  final MemberModel partner;

  const _SparringRequestSheet({required this.partner});

  @override
  ConsumerState<_SparringRequestSheet> createState() =>
      __SparringRequestSheetState();
}

class __SparringRequestSheetState extends ConsumerState<_SparringRequestSheet> {
  final _messageController = TextEditingController();

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.sparringRequestTitle,
            style: GoogleFonts.oswald(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: CircleAvatar(
              backgroundColor: const Color(0xFF2C2C2C),
              child: Text(
                widget.partner.user?.fullName.substring(0, 1) ?? '?',
                style: GoogleFonts.oswald(color: Colors.white),
              ),
            ),
            title: Text(
              widget.partner.user?.fullName ?? 'Membre',
              style: GoogleFonts.oswald(color: Colors.white, fontSize: 18),
            ),
            subtitle: Text(
              widget.partner.level.toUpperCase(),
              style: GoogleFonts.inter(color: Colors.grey[400], fontSize: 12),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _messageController,
            style: GoogleFonts.inter(color: Colors.white),
            decoration: InputDecoration(
              labelText: l10n.sparringMessageLabel,
              labelStyle: TextStyle(color: Colors.grey[400]),
              hintText: l10n.sparringMessageHint,
              hintStyle: TextStyle(color: Colors.grey[600]),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.white.withValues(alpha: 0.1),
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: AppColors.brandOrange),
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: Colors.white.withValues(alpha: 0.05),
            ),
            maxLines: 3,
          ),

          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () async {
                final message = _messageController.text;
                Navigator.pop(context);

                // Show loading/success via provider or local state?
                // For now just call repro
                try {
                  await ref
                      .read(sparringControllerProvider.notifier)
                      .createRequest(
                        requestedId: widget.partner.id,
                        branchId: widget.partner.primaryBranchId,
                        discipline:
                            widget.partner.specializations?.isNotEmpty == true
                            ? widget.partner.specializations!.first
                            : null,
                        message: message.isNotEmpty ? message : null,
                      ); // Assuming controller has this method

                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: AppColors.brandOrange,
                        content: Text(
                          l10n.sparringRequestSent(
                            widget.partner.user?.fullName ?? '',
                          ),
                          style: GoogleFonts.inter(color: Colors.white),
                        ),
                      ),
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: Colors.red,
                        content: Text(
                          'Error: $e',
                          style: GoogleFonts.inter(color: Colors.white),
                        ),
                      ),
                    );
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.brandOrange,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                l10n.sparringSendRequest,
                style: GoogleFonts.oswald(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
