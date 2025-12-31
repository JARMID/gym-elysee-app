import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gyelyseedz/l10n/app_localizations.dart';
import '../../../core/routing/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/error_handler.dart';
import '../../widgets/web/web_footer.dart';
import '../../providers/landing_providers.dart';
import '../../providers/theme_provider.dart';
import '../../widgets/web/web_map_section.dart';
import '../../widgets/web/web_nav_bar.dart';

class WebContactPage extends ConsumerStatefulWidget {
  const WebContactPage({super.key});

  @override
  ConsumerState<WebContactPage> createState() => _WebContactPageState();
}

class _WebContactPageState extends ConsumerState<WebContactPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _messageController = TextEditingController();
  String? _selectedBranch;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    final l10n = AppLocalizations.of(context)!;

    setState(() => _isLoading = true);

    try {
      await ref.read(landingRepositoryProvider).submitContact({
        'name': _nameController.text,
        'email': _emailController.text,
        'phone': _phoneController.text,
        'branch': _selectedBranch,
        'message': _messageController.text,
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.contactSuccessMessage),
            backgroundColor: Colors.green,
          ),
        );
        _formKey.currentState!.reset();
        _nameController.clear();
        _emailController.clear();
        _phoneController.clear();
        _messageController.clear();
        setState(() => _selectedBranch = null);
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
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isRamadanMode = ref.watch(ramadanModeProvider);
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: isRamadanMode ? 130 : 80),

                // Header
                FadeInDown(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 80),
                    child: Column(
                      children: [
                        Text(
                          l10n.contactTitleFirst,
                          style: GoogleFonts.oswald(
                            fontSize: 60,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : Colors.black,
                          ),
                        ),
                        ShaderMask(
                          blendMode: BlendMode.srcIn,
                          shaderCallback: (bounds) =>
                              AppColors.fieryGradient.createShader(bounds),
                          child: Text(
                            l10n.contactTitleSecond,
                            style: GoogleFonts.oswald(
                              fontSize: 60,
                              fontWeight: FontWeight.bold,
                              height: 1.0,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: 800,
                          child: Text(
                            l10n.contactSubtitle,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                              fontSize: 18,
                              color: isDark
                                  ? Colors.grey[400]
                                  : Colors.grey[700],
                              height: 1.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Main Content
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 100,
                  ).copyWith(bottom: 100),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Left: Form
                      Expanded(
                        flex: 6,
                        child: FadeInLeft(
                          child: Container(
                            padding: const EdgeInsets.all(40),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? const Color(0xFF0F0F0F)
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: isDark
                                    ? AppColors.brandOrange.withValues(
                                        alpha: 0.3,
                                      )
                                    : Colors.grey[300]!,
                              ),
                              boxShadow: isDark
                                  ? null
                                  : [
                                      BoxShadow(
                                        color: Colors.black.withValues(
                                          alpha: 0.05,
                                        ),
                                        blurRadius: 10,
                                        offset: const Offset(0, 5),
                                      ),
                                    ],
                            ),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.send_outlined,
                                        color: AppColors
                                            .brandOrange, // Updated to Orange
                                        size: 24,
                                      ),
                                      const SizedBox(width: 12),
                                      Text(
                                        l10n.contactFormTitle,
                                        style: GoogleFonts.oswald(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                          color: isDark
                                              ? Colors.white
                                              : Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 40),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: _buildTextField(
                                          l10n.contactNameLabel,
                                          l10n.contactNameHint,
                                        ),
                                      ),
                                      const SizedBox(width: 24),
                                      Expanded(
                                        child: _buildTextField(
                                          l10n.contactEmailLabel,
                                          l10n.contactEmailPlaceholder,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 24),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: _buildTextField(
                                          l10n.contactPhoneLabel,
                                          l10n.contactPhonePlaceholder,
                                        ),
                                      ),
                                      const SizedBox(width: 24),
                                      Expanded(
                                        child: _buildDropdown(
                                          l10n.contactBranchLabel,
                                          [
                                            l10n.navAlgiers,
                                            l10n.navOran,
                                            l10n.navConstantine,
                                          ],
                                          l10n.contactBranchPlaceholder,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 24),
                                  _buildTextField(
                                    l10n.contactMessageLabel,
                                    l10n.contactMessageHint,
                                    maxLines: 5,
                                  ),
                                  const SizedBox(height: 40),
                                  _AnimatedSubmitButton(
                                    label: l10n.contactSendButton,
                                    isLoading: _isLoading,
                                    onTap: _submitForm,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 40),

                      // Right: Info Cards
                      Expanded(
                        flex: 4,
                        child: FadeInRight(
                          child: Column(
                            children: [
                              // WhatsApp Card
                              _InteractiveInfoCard(
                                accentColor: Colors.green,
                                child: Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: Colors.green.withValues(
                                          alpha: 0.1,
                                        ),
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: Colors.green.withValues(
                                            alpha: 0.3,
                                          ),
                                        ),
                                      ),
                                      child: const FaIcon(
                                        FontAwesomeIcons.whatsapp,
                                        color: Colors.green,
                                        size: 28,
                                      ),
                                    ),
                                    const SizedBox(width: 20),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          l10n.contactWhatsappTitle,
                                          style: GoogleFonts.oswald(
                                            color: isDark
                                                ? Colors.white
                                                : Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          l10n.contactWhatsappSubtitle,
                                          style: GoogleFonts.inter(
                                            color: isDark
                                                ? Colors.grey[500]
                                                : Colors.grey[600],
                                            fontSize: 12,
                                          ),
                                        ),
                                        Text(
                                          '+213 555 123 456',
                                          style: GoogleFonts.inter(
                                            color: Colors.green,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 24),

                              // Info Card
                              _InteractiveInfoCard(
                                title: l10n.contactInfoTitle,
                                child: Column(
                                  children: [
                                    _buildContactRow(
                                      Icons.phone_outlined,
                                      l10n.contactPhone,
                                      l10n.contactPhoneValue,
                                    ),
                                    const SizedBox(height: 24),
                                    _buildContactRow(
                                      Icons.email_outlined,
                                      l10n.contactEmailLabel,
                                      l10n.contactEmailValue,
                                    ),
                                    const SizedBox(height: 24),
                                    _buildContactRow(
                                      Icons.access_time,
                                      l10n.contactHours,
                                      l10n.contactHoursValue,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 24),

                              // Address Card
                              _InteractiveInfoCard(
                                title: l10n.contactAddressTitle,
                                child: _buildContactRow(
                                  Icons.location_on_outlined,
                                  'GYM ÉLYSÉE DZ',
                                  l10n.contactAddressValue,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 60),
                Column(
                  children: [
                    Text(
                      l10n.contactFindUsTitle,
                      style: GoogleFonts.oswald(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: AppColors.brandYellow,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l10n.contactFindUsSubtitle,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: isDark ? Colors.white : Colors.black,
                        letterSpacing: 2,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                const WebMapSection(),

                const WebFooter(),
              ],
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: WebNavBar(
              isScrolled: true,
              activeRoute: AppRoutes.webContact,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactRow(IconData icon, String label, String value) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.brandOrange.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: AppColors.brandOrange, size: 20),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.oswald(
                  color: isDark ? Colors.white : Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: GoogleFonts.inter(
                  color: isDark ? Colors.grey[400] : Colors.grey[700],
                  fontSize: 14,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTextField(String label, String hint, {int maxLines = 1}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            color: isDark ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          maxLines: maxLines,
          style: TextStyle(color: isDark ? Colors.white : Colors.black),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: isDark ? Colors.grey[800] : Colors.grey[400],
              fontSize: 14,
            ),
            filled: true,
            fillColor: isDark ? const Color(0xFF0A0A0A) : Colors.grey[50],
            contentPadding: const EdgeInsets.all(16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.1)
                    : Colors.black.withValues(alpha: 0.1),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.1)
                    : Colors.black.withValues(alpha: 0.1),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.brandOrange),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown(String label, List<String> items, String hint) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            color: isDark ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          dropdownColor: isDark ? const Color(0xFF0A0A0A) : Colors.white,
          style: TextStyle(color: isDark ? Colors.white : Colors.black),
          icon: const Icon(Icons.expand_more, color: Colors.grey),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: isDark ? Colors.grey[800] : Colors.grey[400],
              fontSize: 14,
            ),
            filled: true,
            fillColor: isDark ? const Color(0xFF0A0A0A) : Colors.grey[50],
            contentPadding: const EdgeInsets.all(16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.1)
                    : Colors.black.withValues(alpha: 0.1),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.1)
                    : Colors.black.withValues(alpha: 0.1),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.brandOrange),
            ),
          ),
          items: items
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: (val) {},
        ),
      ],
    );
  }
}

class _AnimatedSubmitButton extends StatefulWidget {
  final String label;
  final bool isLoading;
  final VoidCallback onTap;

  const _AnimatedSubmitButton({
    required this.label,
    required this.isLoading,
    required this.onTap,
  });

  @override
  State<_AnimatedSubmitButton> createState() => _AnimatedSubmitButtonState();
}

class _AnimatedSubmitButtonState extends State<_AnimatedSubmitButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.isLoading ? null : widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
          transform: Matrix4.identity()
            // ignore: deprecated_member_use
            ..translate(0.0, _isHovered ? -4.0 : 0.0),
          width: double.infinity,
          height: 56,
          decoration: BoxDecoration(
            gradient: AppColors.fieryGradient,
            borderRadius: BorderRadius.circular(8),
            boxShadow: _isHovered
                ? [
                    BoxShadow(
                      color: AppColors.brandOrange.withValues(alpha: 0.4),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ]
                : [],
          ),
          child: Center(
            child: widget.isLoading
                ? const CircularProgressIndicator(color: Colors.black)
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        widget.label,
                        style: GoogleFonts.oswald(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          letterSpacing: 1,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(width: 12),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        transform: Matrix4.identity()
                          // ignore: deprecated_member_use
                          ..translate(_isHovered ? 5.0 : 0.0, 0.0),
                        child: const Icon(
                          Icons.arrow_forward,
                          size: 18,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

class _InteractiveInfoCard extends StatefulWidget {
  final String? title;
  final Widget child;
  final Color? accentColor;

  const _InteractiveInfoCard({
    this.title,
    required this.child,
    this.accentColor,
  });

  @override
  State<_InteractiveInfoCard> createState() => _InteractiveInfoCardState();
}

class _InteractiveInfoCardState extends State<_InteractiveInfoCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accent = widget.accentColor ?? AppColors.brandOrange;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
        transform: Matrix4.identity()
          // ignore: deprecated_member_use
          ..translate(0.0, _isHovered ? -6.0 : 0.0),
        width: double.infinity,
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF0F0F0F) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _isHovered
                ? accent.withValues(alpha: 0.5)
                : (isDark
                      ? AppColors.brandOrange.withValues(alpha: 0.3)
                      : Colors.grey[300]!),
            width: _isHovered ? 2 : 1,
          ),
          boxShadow: _isHovered
              ? [
                  BoxShadow(
                    color: accent.withValues(alpha: 0.15),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ]
              : (isDark
                    ? null
                    : [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ]),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.title != null) ...[
              Text(
                widget.title!,
                style: GoogleFonts.oswald(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: _isHovered
                      ? accent
                      : (isDark ? Colors.white : Colors.black),
                ),
              ),
              const SizedBox(height: 24),
            ],
            widget.child,
          ],
        ),
      ),
    );
  }
}
