import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gyelyseedz/l10n/app_localizations.dart';
import '../../../core/theme/app_colors.dart';
import '../../widgets/web/web_footer.dart';
import '../../providers/landing_providers.dart';
import '../../providers/theme_provider.dart';
import '../../widgets/web/web_nav_bar.dart';
import '../../../data/models/branch_model.dart';
import '../../../data/models/program_model.dart';
import '../../../core/utils/error_handler.dart';

class WebBranchDetailsPage extends ConsumerStatefulWidget {
  final String branchId;
  const WebBranchDetailsPage({super.key, required this.branchId});

  @override
  ConsumerState<WebBranchDetailsPage> createState() =>
      _WebBranchDetailsPageState();
}

class _WebBranchDetailsPageState extends ConsumerState<WebBranchDetailsPage> {
  final ScrollController _scrollController = ScrollController();
  final _visitFormKey = GlobalKey<FormState>();
  final _visitNameCtrl = TextEditingController();
  final _visitEmailCtrl = TextEditingController();
  final _visitPhoneCtrl = TextEditingController();
  final _visitDateCtrl = TextEditingController();
  final _visitMsgCtrl = TextEditingController();
  bool _isVisitLoading = false;

  @override
  void dispose() {
    _scrollController.dispose();
    _visitNameCtrl.dispose();
    _visitEmailCtrl.dispose();
    _visitPhoneCtrl.dispose();
    _visitDateCtrl.dispose();
    _visitMsgCtrl.dispose();
    super.dispose();
  }

  Future<void> _submitVisitRequest() async {
    if (!_visitFormKey.currentState!.validate()) return;

    final l10n = AppLocalizations.of(context)!;
    setState(() => _isVisitLoading = true);

    try {
      await ref.read(landingRepositoryProvider).requestVisit({
        'name': _visitNameCtrl.text,
        'email': _visitEmailCtrl.text,
        'phone': _visitPhoneCtrl.text,
        'date': _visitDateCtrl.text,
        'branch_id': widget.branchId,
        'message': _visitMsgCtrl.text,
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.branchVisitSuccess),
            backgroundColor: Colors.green,
          ),
        );
        _visitFormKey.currentState!.reset();
        _visitNameCtrl.clear();
        _visitEmailCtrl.clear();
        _visitPhoneCtrl.clear();
        _visitDateCtrl.clear();
        _visitMsgCtrl.clear();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(ErrorHandler.getErrorMessage(context, e)),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isVisitLoading = false);
    }
  }

  String _getLocalizedBranchType(String type, AppLocalizations l10n) {
    switch (type.toLowerCase()) {
      case 'mixte':
        return l10n.branchTypeMixte.toUpperCase();
      case 'women_only':
        return l10n.branchTypeWomen.toUpperCase();
      case 'crossfit':
        return l10n.branchTypeCrossfit.toUpperCase();
      default:
        return type.toUpperCase();
    }
  }

  @override
  Widget build(BuildContext context) {
    final branchesAsync = ref.watch(branchesProvider);
    final isRamadanMode = ref.watch(ramadanModeProvider);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      body: branchesAsync.when(
        data: (branches) {
          final branchIdInt = int.tryParse(widget.branchId);
          if (branchIdInt == null) {
            return Center(
              child: Text(
                l10n.branchErrorId,
                style: const TextStyle(color: Colors.white),
              ),
            );
          }

          if (branches.isEmpty) {
            return Center(
              child: Text(
                l10n.branchErrorNotFound,
                style: const TextStyle(color: Colors.white),
              ),
            );
          }

          final branch = branches.firstWhere(
            (b) => b.id == branchIdInt,
            orElse: () => branches.first,
          );

          return Stack(
            children: [
              SingleChildScrollView(
                controller: _scrollController,
                child: Column(
                  children: [
                    SizedBox(height: isRamadanMode ? 130 : 0),
                    _buildHero(context, branch, isRamadanMode, l10n),

                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 60,
                        vertical: 60,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                FadeInUp(
                                  duration: const Duration(milliseconds: 600),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      _buildSectionTitle(l10n.branchAbout),
                                      const SizedBox(height: 20),
                                      Text(
                                        branch.description,
                                        style: GoogleFonts.inter(
                                          fontSize: 18,
                                          color: Colors.grey[400],
                                          height: 1.6,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 60),
                                FadeInUp(
                                  delay: const Duration(milliseconds: 200),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      _buildSectionTitle(l10n.branchGallery),
                                      const SizedBox(height: 30),
                                      _buildGallery(
                                        branch.photos.isNotEmpty
                                            ? branch.photos
                                            : ['branch_${branch.type}.jpg'],
                                        branch.type,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 60),
                                FadeInUp(
                                  delay: const Duration(milliseconds: 400),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      _buildSectionTitle(l10n.branchEquipments),
                                      const SizedBox(height: 30),
                                      _buildEquipments(branch.equipment),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 60),

                                // New: Coaches Section
                                FadeInUp(
                                  delay: const Duration(milliseconds: 600),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      _buildSectionTitle(l10n.branchTeam),
                                      const SizedBox(height: 30),
                                      _buildCoaches(branch, l10n),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 60),

                                // New: Programs Section (if any)
                                if (branch.programs != null &&
                                    branch.programs!.isNotEmpty) ...[
                                  FadeInUp(
                                    delay: const Duration(milliseconds: 700),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        _buildSectionTitle(l10n.programsTitle),
                                        const SizedBox(height: 30),
                                        _buildPrograms(branch.programs!),
                                        const SizedBox(height: 60),
                                      ],
                                    ),
                                  ),
                                ],
                                const SizedBox(height: 60),

                                // New: Location Map
                                FadeInUp(
                                  delay: const Duration(milliseconds: 800),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      _buildSectionTitle(l10n.branchLocation),
                                      const SizedBox(height: 30),
                                      _buildMapSection(branch),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 60),
                              ],
                            ),
                          ),
                          const SizedBox(width: 60),
                          Expanded(
                            child: Column(
                              children: [
                                FadeInRight(
                                  delay: const Duration(milliseconds: 200),
                                  child: _buildHoursCard(
                                    branch.openingHours,
                                    branch.ramadanHours,
                                    l10n,
                                  ),
                                ),
                                const SizedBox(height: 30),
                                FadeInRight(
                                  delay: const Duration(milliseconds: 400),
                                  child: _buildContactCard(branch, l10n),
                                ),
                                const SizedBox(height: 30),
                                FadeInRight(
                                  delay: const Duration(milliseconds: 600),
                                  child: _buildVisitForm(l10n),
                                ),
                                const SizedBox(height: 30),
                                FadeInRight(
                                  delay: const Duration(milliseconds: 800),
                                  child: _buildReviewsCard(l10n),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const WebFooter(),
                  ],
                ),
              ),
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: WebNavBar(isScrolled: true),
              ),
            ],
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.gold),
        ),
        error: (err, stack) => Center(
          child: Text(
            'Erreur: $err',
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }

  // --- New Helper Methods ---

  Widget _buildCoaches(BranchModel branch, AppLocalizations l10n) {
    if (branch.coaches != null && branch.coaches!.isNotEmpty) {
      return Wrap(
        spacing: 20,
        runSpacing: 20,
        children: branch.coaches!.map((coach) {
          final user = coach.user;
          final name = user != null
              ? '${user.firstName} ${user.lastName}'
              : 'Coach';
          final initials = user != null
              ? '${user.firstName.characters.first}${user.lastName.characters.first}'
                    .toUpperCase()
              : 'CO';
          final specialty = coach.specializations.isNotEmpty
              ? coach.specializations.first
              : l10n.featureCoachTitle;
          final certification = coach.certifications.isNotEmpty
              ? coach.certifications.first
              : null;

          return Container(
            width: 280,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.cardDark,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white10),
            ),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: AppColors.gold,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      initials,
                      style: GoogleFonts.outfit(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: GoogleFonts.outfit(
                          color: AppColors.gold,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        specialty,
                        style: GoogleFonts.inter(
                          color: Colors.grey[400],
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 8),
                      if (certification != null)
                        Row(
                          children: [
                            Icon(
                              Icons.star_outline,
                              color: Colors.grey[600],
                              size: 14,
                            ),
                            const SizedBox(width: 4),
                            Flexible(
                              child: Text(
                                certification,
                                style: GoogleFonts.inter(
                                  color: Colors.grey[500],
                                  fontSize: 11,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      );
    }

    return Center(
      child: Text(
        'Aucun coach assigné pour le moment.',
        style: TextStyle(color: Colors.grey),
      ),
    );
  }

  Widget _buildPrograms(List<ProgramModel> programs) {
    return SizedBox(
      height: 380,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: programs.length,
        separatorBuilder: (context, index) => const SizedBox(width: 24),
        itemBuilder: (context, index) {
          final program = programs[index];
          return Container(
            width: 300,
            decoration: BoxDecoration(
              color: AppColors.cardDark,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white10),
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 160,
                  decoration: BoxDecoration(
                    color: Colors.grey[900],
                    image: program.coverImage != null
                        ? DecorationImage(
                            image: NetworkImage(program.coverImage!),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: program.coverImage == null
                      ? const Center(
                          child: Icon(
                            Icons.fitness_center,
                            color: Colors.white24,
                            size: 48,
                          ),
                        )
                      : null,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.brandOrange.withValues(
                                  alpha: 0.2,
                                ),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                program.level,
                                style: const TextStyle(
                                  color: AppColors.brandOrange,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const Spacer(),
                            Text(
                              '${program.durationWeeks} semaines',
                              style: TextStyle(
                                color: Colors.grey[400],
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          program.name,
                          style: GoogleFonts.oswald(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          program.description,
                          style: GoogleFonts.inter(
                            color: Colors.grey[400],
                            fontSize: 13,
                            height: 1.4,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const Spacer(),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white10,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text('Voir le programme'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildMapSection(BranchModel branch) {
    // Placeholder for actual map
    return Container(
      height: 300,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(24),
        image: const DecorationImage(
          image: NetworkImage(
            'https://i.imgur.com/kK5w5fC.png',
          ), // Mock dark map
          fit: BoxFit.cover,
          opacity: 0.5,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.location_on, color: AppColors.gold, size: 48),
            const SizedBox(height: 16),
            Text(
              branch.address,
              style: GoogleFonts.outfit(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '${branch.city}, ${branch.wilaya}',
              style: GoogleFonts.inter(color: Colors.grey[400]),
            ),
            if (branch.latitude != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Chip(
                  label: Text('GPS: ${branch.latitude}, ${branch.longitude}'),
                  backgroundColor: Colors.black54,
                  labelStyle: const TextStyle(
                    color: Colors.white70,
                    fontSize: 10,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildReviewsCard(AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.star, color: AppColors.gold, size: 24),
              const SizedBox(width: 8),
              Text(
                l10n.branchReviewsTitle,
                style: GoogleFonts.outfit(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildReviewItem('Karim M.', l10n.reviewPlaceholder1),
          const Divider(color: Colors.white10, height: 30),
          _buildReviewItem('Yasmine S.', l10n.reviewPlaceholder2),
        ],
      ),
    );
  }

  Widget _buildReviewItem(String name, String comment) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const CircleAvatar(
              radius: 12,
              backgroundColor: Colors.white24,
              child: Icon(Icons.person, size: 12, color: Colors.white),
            ),
            const SizedBox(width: 8),
            Text(
              name,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            Row(
              children: List.generate(
                5,
                (i) => Icon(Icons.star, size: 12, color: AppColors.gold),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          comment,
          style: TextStyle(color: Colors.grey[400], fontSize: 13, height: 1.4),
        ),
      ],
    );
  }

  Widget _buildHero(
    BuildContext context,
    BranchModel branch,
    bool isRamadan,
    AppLocalizations l10n,
  ) {
    return SizedBox(
      height: 600,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(
            _getBranchCoverImage(branch.type),
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) =>
                Container(color: Colors.grey[900]),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.3),
                  AppColors.brandOrange.withValues(
                    alpha: 0.1,
                  ), // Subtle fiery tint
                  Colors.black.withValues(alpha: 0.8),
                  AppColors.darkBackground,
                ],
              ),
            ),
          ),
          // Navbar Overlay Removed (Now Global)

          // Content
          Positioned(
            bottom: 100,
            left: 60,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextButton.icon(
                  onPressed: () => context.go('/branches'), // Fixed route
                  icon: const Icon(Icons.arrow_back, color: Colors.grey),
                  label: Text(
                    l10n.branchBackLink,
                    style: const TextStyle(color: Colors.grey),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.gold,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    _getLocalizedBranchType(branch.type, l10n),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                ShaderMask(
                  blendMode: BlendMode.srcIn,
                  shaderCallback: (bounds) =>
                      AppColors.fieryGradient.createShader(bounds),
                  child: Text(
                    branch.name,
                    style: GoogleFonts.outfit(
                      fontSize: 64,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Icon(
                      Icons.location_on,
                      color: AppColors.gold,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      branch.fullAddress,
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        color: Colors.grey[300],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.outfit(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }

  Widget _buildGallery(List<String> images, String branchType) {
    // Use premium gym images from Unsplash
    final galleryImages = [
      'https://images.unsplash.com/photo-1534438327276-14e5300c3a48?w=800&fit=crop',
      'https://images.unsplash.com/photo-1540497077202-7c8a3999166f?w=800&fit=crop',
      'https://images.unsplash.com/photo-1571902943202-507ec2618e8f?w=800&fit=crop',
      'https://images.unsplash.com/photo-1574680096141-9877477ce5f0?w=800&fit=crop',
    ];

    return SizedBox(
      height: 350,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: galleryImages.length,
        padding: const EdgeInsets.symmetric(vertical: 20),
        separatorBuilder: (context, index) => const SizedBox(width: 24),
        itemBuilder: (_, index) {
          return _GalleryItem(
            imageUrl: galleryImages[index],
            onTap: () {
              showDialog(
                context: context,
                builder: (context) =>
                    _GalleryLightbox(imageUrl: galleryImages[index]),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildEquipments(List<String> items) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 5,
        mainAxisSpacing: 20,
        crossAxisSpacing: 20,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: const Color(0xFF1A1A1A),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white10),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.gold.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.check, color: AppColors.gold, size: 16),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  item,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHoursCard(
    Map<String, String> hours,
    Map<String, Map<String, String>>? ramadanHours,
    AppLocalizations l10n,
  ) {
    return Container(
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: const Color(0xFF151515),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(FontAwesomeIcons.clock, color: AppColors.gold),
              const SizedBox(width: 12),
              Text(
                l10n.branchHours,
                style: GoogleFonts.outfit(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Dynamic hours rendering
          ...hours.entries.map(
            (e) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _buildHourRow(e.key, e.value),
            ),
          ),

          if (ramadanHours != null) ...[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Divider(color: Colors.white.withValues(alpha: 0.1)),
            ),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: ramadanHours.entries
                    .map(
                      (e) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          children: [
                            const Icon(
                              FontAwesomeIcons.moon,
                              color: Colors.redAccent,
                              size: 16,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                '${l10n.branchRamadan} (${e.key})',
                                style: const TextStyle(
                                  color: Colors.redAccent,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                            Text(
                              '${e.value['open']} - ${e.value['close']}',
                              style: const TextStyle(
                                color: Colors.redAccent,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildHourRow(String label, String time) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(color: Colors.grey[400])),
        Text(
          time,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildContactCard(BranchModel branch, AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: const Color(0xFF151515),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.branchContactTitle,
            style: GoogleFonts.outfit(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 24),
          _buildInfoTile(Icons.phone, branch.phone),
          const SizedBox(height: 16),
          _buildInfoTile(
            Icons.email,
            'contact@gymelysee.dz',
          ), // Generic email if not in model
        ],
      ),
    );
  }

  Widget _buildInfoTile(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.gold, size: 20),
          const SizedBox(width: 16),
          Text(text, style: const TextStyle(color: Colors.white)),
        ],
      ),
    );
  }

  Widget _buildVisitForm(AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: const Color(0xFF151515),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Form(
        key: _visitFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  FontAwesomeIcons.userGroup,
                  color: AppColors.brandOrange,
                ),
                const SizedBox(width: 12),
                Text(
                  l10n.branchVisitTitle,
                  style: GoogleFonts.outfit(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            _buildTxField(
              l10n.branchVisitName,
              controller: _visitNameCtrl,
              l10n: l10n,
              icon: Icons.person_outline,
            ),
            const SizedBox(height: 12),
            _buildTxField(
              l10n.branchVisitEmail,
              controller: _visitEmailCtrl,
              l10n: l10n,
              icon: Icons.email_outlined,
            ),
            const SizedBox(height: 12),
            _buildTxField(
              l10n.branchVisitPhone,
              controller: _visitPhoneCtrl,
              l10n: l10n,
              icon: Icons.phone_outlined,
            ),
            const SizedBox(height: 12),
            _buildTxField(
              l10n.branchVisitDate,
              icon: Icons.calendar_today_outlined,
              controller: _visitDateCtrl,
              l10n: l10n,
            ),
            const SizedBox(height: 12),
            _buildTxField(
              l10n.branchVisitMessage,
              maxLines: 4,
              controller: _visitMsgCtrl,
              l10n: l10n,
            ),
            const SizedBox(height: 24),
            Container(
              width: double.infinity,
              height: 54,
              decoration: BoxDecoration(
                gradient: AppColors.fieryGradient,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.brandOrange.withValues(alpha: 0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: _isVisitLoading ? null : _submitVisitRequest,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: _isVisitLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.black,
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            l10n.branchVisitButton.toUpperCase(),
                            style: GoogleFonts.oswald(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              letterSpacing: 1,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(Icons.send, size: 18),
                        ],
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getBranchCoverImage(String type) {
    switch (type) {
      case 'flagship':
        return 'https://images.unsplash.com/photo-1540497077202-7c8a3999166f?w=1200&fit=crop';
      case 'boxing':
        return 'https://images.unsplash.com/photo-1599058945522-28d584b6f0ff?w=1200&fit=crop';
      case 'mma':
        return 'https://images.unsplash.com/photo-1595078475328-1ab05d0a6a0e?w=1200&fit=crop';
      case 'grappling':
        return 'https://images.unsplash.com/photo-1615117968536-bb1d8820c4aa?w=1200&fit=crop';
      case 'women':
        return 'https://images.unsplash.com/photo-1518310383802-640c2de311b2?w=1200&fit=crop';
      case 'crossfit':
        return 'https://images.unsplash.com/photo-1517963879466-8025ikde4383?w=1200&fit=crop';
      default:
        return 'https://images.unsplash.com/photo-1534438327276-14e5300c3a48?w=1200&fit=crop';
    }
  }

  Widget _buildTxField(
    String hint, {
    int maxLines = 1,
    IconData? icon,
    TextEditingController? controller,
    required AppLocalizations l10n,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      style: GoogleFonts.inter(color: Colors.white),
      validator: (value) {
        if (hint == l10n.branchVisitMessage) return null;
        if (value == null || value.isEmpty) {
          return l10n.formRequiredField;
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: hint,
        labelStyle: GoogleFonts.inter(color: Colors.grey[500]),
        alignLabelWithHint: true,
        filled: true,
        fillColor: const Color(0xFF0A0A0A),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.brandOrange),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 18,
        ),
        prefixIcon: icon != null
            ? Icon(icon, color: AppColors.brandOrange, size: 20)
            : null,
      ),
    );
  }
}

class _GalleryItem extends StatefulWidget {
  final String imageUrl;
  final VoidCallback onTap;

  const _GalleryItem({required this.imageUrl, required this.onTap});

  @override
  State<_GalleryItem> createState() => _GalleryItemState();
}

class _GalleryItemState extends State<_GalleryItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: _isHovered ? 420 : 400, // Expand width
          curve: Curves.easeOutCubic,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: _isHovered
                    ? AppColors.brandOrange.withValues(alpha: 0.4)
                    : Colors.black.withValues(alpha: 0.5),
                blurRadius: _isHovered ? 30 : 10,
                offset: _isHovered ? const Offset(0, 10) : Offset.zero,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Stack(
              fit: StackFit.expand,
              children: [
                AnimatedScale(
                  scale: _isHovered ? 1.1 : 1.0,
                  duration: const Duration(milliseconds: 500),
                  child: Image.network(widget.imageUrl, fit: BoxFit.cover),
                ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: _isHovered
                          ? AppColors.gold.withValues(alpha: 0.5)
                          : Colors.transparent,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    gradient: _isHovered
                        ? LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              Colors.black.withValues(alpha: 0.6),
                              Colors.transparent,
                            ],
                          )
                        : null,
                  ),
                ),
                if (_isHovered)
                  const Center(
                    child: Icon(Icons.zoom_in, color: Colors.white, size: 40),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _GalleryLightbox extends StatelessWidget {
  final String imageUrl;

  const _GalleryLightbox({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(40),
      child: Stack(
        alignment: Alignment.center,
        children: [
          InteractiveViewer(
            clipBehavior: Clip.none,
            maxScale: 4,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(imageUrl),
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: FloatingActionButton(
              onPressed: () => Navigator.pop(context),
              backgroundColor: Colors.black54,
              child: const Icon(Icons.close, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
