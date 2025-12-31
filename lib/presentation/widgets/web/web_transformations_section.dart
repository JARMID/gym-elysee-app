import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../l10n/app_localizations.dart';

class WebTransformationsSection extends StatefulWidget {
  const WebTransformationsSection({super.key});

  @override
  State<WebTransformationsSection> createState() =>
      _WebTransformationsSectionState();
}

class _WebTransformationsSectionState extends State<WebTransformationsSection> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;
  Timer? _autoPlayTimer;
  late List<Map<String, dynamic>> _transformations;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final l10n = AppLocalizations.of(context)!;
    _transformations = [
      {
        'name': l10n.trName1,
        'age': l10n.trAge1,
        'gym': l10n.trGym1,
        'duration': l10n.trDuration1,
        'program': l10n.trProgram1,
        'beforeWeight': '95kg',
        'beforeFat': '28%',
        'afterWeight': '77kg',
        'afterFat': '12%',
        'weightLoss': l10n.trWeight1,
        'muscleGain': l10n.trMuscle1,
        'quote': '"${l10n.trQuote1}"',
      },
      {
        'name': l10n.trName2,
        'age': l10n.trAge2,
        'gym': l10n.trGym2,
        'duration': l10n.trDuration2,
        'program': l10n.trProgram2,
        'beforeWeight': '78kg',
        'beforeFat': '35%',
        'afterWeight': '62kg',
        'afterFat': '22%',
        'weightLoss': l10n.trWeight2,
        'muscleGain': l10n.trMuscle2,
        'quote': '"${l10n.trQuote2}"',
      },
      {
        'name': l10n.trName3,
        'age': l10n.trAge3,
        'gym': l10n.trGym3,
        'duration': l10n.trDuration3,
        'program': l10n.trProgram3,
        'beforeWeight': '85kg',
        'beforeFat': '22%',
        'afterWeight': '75kg',
        'afterFat': '10%',
        'weightLoss': l10n.trWeight3,
        'muscleGain': l10n.trMuscle3,
        'quote': '"${l10n.trQuote3}"',
      },
    ];
  }

  @override
  void initState() {
    super.initState();
    _startAutoPlay();
  }

  @override
  void dispose() {
    _autoPlayTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _startAutoPlay() {
    _autoPlayTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (!mounted) return;
      if (_currentIndex < _transformations.length - 1) {
        _pageController.nextPage(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      } else {
        _pageController.animateToPage(
          0,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      color: isDark ? Colors.black : Colors.grey[100],
      padding: const EdgeInsets.symmetric(vertical: 100, horizontal: 24),
      child: Column(
        children: [
          // Header
          Text(
            "SUCCESS STORIES",
            style: GoogleFonts.inter(
              color: AppColors.brandOrange,
              letterSpacing: 3,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 20),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: GoogleFonts.oswald(
                fontSize: 56,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black,
                height: 1.1,
              ),
              children: [
                const TextSpan(text: "TRANSFORMATIONS "),
                TextSpan(
                  text: "INSPIRANTES",
                  style: GoogleFonts.oswald(
                    fontSize: 56,
                    fontWeight: FontWeight.bold,
                    color: AppColors.brandOrange,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 60),

          // Carousel
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1000),
              child: SizedBox(
                height: 450,
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() => _currentIndex = index);
                  },
                  itemCount: _transformations.length,
                  itemBuilder: (context, index) {
                    return _TransformationCard(
                      transformation: _transformations[index],
                    );
                  },
                ),
              ),
            ),
          ),
          const SizedBox(height: 40),

          // Carousel Indicators
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Previous Button
              IconButton(
                onPressed: () {
                  _pageController.previousPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
                icon: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white24),
                  ),
                  child: const Icon(
                    Icons.chevron_left,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // Dots
              Row(
                children: List.generate(_transformations.length, (index) {
                  final isActive = index == _currentIndex;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: isActive ? 32 : 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: isActive
                          ? AppColors.brandOrange
                          : Colors.grey[700],
                      borderRadius: BorderRadius.circular(5),
                    ),
                  );
                }),
              ),
              const SizedBox(width: 16),
              // Next Button
              IconButton(
                onPressed: () {
                  _pageController.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
                icon: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white24),
                  ),
                  child: const Icon(
                    Icons.chevron_right,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TransformationCard extends StatelessWidget {
  final Map<String, dynamic> transformation;

  const _TransformationCard({required this.transformation});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth > 700;

        if (isDesktop) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Before/After Visual
              Expanded(flex: 5, child: _buildBeforeAfterSection(context)),
              const SizedBox(width: 40),
              // Details
              Expanded(flex: 5, child: _buildDetailsSection(context)),
            ],
          );
        } else {
          return SingleChildScrollView(
            child: Column(
              children: [
                _buildBeforeAfterSection(context),
                const SizedBox(height: 24),
                _buildDetailsSection(context),
              ],
            ),
          );
        }
      },
    );
  }

  Widget _buildBeforeAfterSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? const Color(0xFF0F0F0F)
            : Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.white10
              : Colors.grey[300]!,
        ),
      ),
      child: Row(
        children: [
          // Before
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white24),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'AVANT',
                    style: GoogleFonts.oswald(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'AVANT',
                  style: GoogleFonts.oswald(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  transformation['beforeWeight'],
                  style: GoogleFonts.oswald(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[400],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  transformation['beforeFat'],
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
          // Arrow
          Container(
            width: 50,
            height: 50,
            decoration: const BoxDecoration(
              color: AppColors.brandOrange,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.arrow_forward,
              color: Colors.black,
              size: 24,
            ),
          ),
          // After
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.brandOrange.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.brandOrange),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.brandOrange,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'APRÈS',
                      style: GoogleFonts.oswald(
                        color: Colors.black,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'APRÈS',
                    style: GoogleFonts.oswald(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: AppColors.brandOrange,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    transformation['afterWeight'],
                    style: GoogleFonts.oswald(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: AppColors.brandOrange,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    transformation['afterFat'],
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: AppColors.brandOrange,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Tags
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.brandOrange,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                transformation['duration'],
                style: GoogleFonts.oswald(
                  color: Colors.black,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.brandOrange),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                transformation['program'],
                style: GoogleFonts.oswald(
                  color: AppColors.brandOrange,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),

        // Name
        Text(
          transformation['name'],
          style: GoogleFonts.oswald(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white
                : Colors.black,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '${transformation['age']} • ${transformation['gym']}',
          style: GoogleFonts.inter(fontSize: 14, color: Colors.grey[500]),
        ),
        const SizedBox(height: 24),

        // Results
        Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? const Color(0xFF0F0F0F)
                      : Colors.grey[50],
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: Colors.white10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.trending_down,
                          color: Colors.grey[500],
                          size: 14,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'RÉSULTAT',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            color: Colors.grey[500],
                            letterSpacing: 1,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      transformation['weightLoss'],
                      style: GoogleFonts.oswald(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? const Color(0xFF0F0F0F)
                      : Colors.grey[50],
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: Colors.white10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.bolt,
                          color: AppColors.brandOrange,
                          size: 14,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'GAINS',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            color: Colors.grey[500],
                            letterSpacing: 1,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      transformation['muscleGain'],
                      style: GoogleFonts.oswald(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),

        // Quote
        Container(
          padding: const EdgeInsets.only(left: 16),
          decoration: const BoxDecoration(
            border: Border(
              left: BorderSide(color: AppColors.brandOrange, width: 3),
            ),
          ),
          child: Text(
            transformation['quote'],
            style: GoogleFonts.inter(
              fontSize: 14,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.grey[400]
                  : Colors.grey[700],
              fontStyle: FontStyle.italic,
              height: 1.6,
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Stars
        Row(
          children: List.generate(
            5,
            (index) => const Padding(
              padding: EdgeInsets.only(right: 4),
              child: Icon(Icons.star, color: AppColors.brandOrange, size: 20),
            ),
          ),
        ),
      ],
    );
  }
}
