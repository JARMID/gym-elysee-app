import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:gyelyseedz/l10n/app_localizations.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/error_handler.dart';
import '../../providers/landing_providers.dart';
import '../../widgets/mobile/mobile_page_wrapper.dart';

class MobileContactPage extends ConsumerStatefulWidget {
  const MobileContactPage({super.key});

  @override
  ConsumerState<MobileContactPage> createState() => _MobileContactPageState();
}

class _MobileContactPageState extends ConsumerState<MobileContactPage> {
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
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return MobilePageWrapper(
      title: l10n.navContact.toUpperCase(),
      showBackButton: true,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Header
            FadeInDown(
              child: Column(
                children: [
                  Text(
                    l10n.contactTitleFirst,
                    style: GoogleFonts.oswald(
                      fontSize: 32,
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
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        height: 1.0,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    l10n.contactSubtitle,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: isDark ? Colors.grey[400] : Colors.grey[700],
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Form
            FadeInLeft(child: _buildContactForm(l10n, isDark)),
            const SizedBox(height: 32),

            // Info Cards
            FadeInRight(child: _buildInfoCards(l10n, isDark)),
          ],
        ),
      ),
    );
  }

  Widget _buildContactForm(AppLocalizations l10n, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F0F0F) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark
              ? AppColors.brandOrange.withValues(alpha: 0.3)
              : Colors.grey[300]!,
        ),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTextField(l10n.contactNameLabel, l10n.contactNameHint),
            const SizedBox(height: 24),
            _buildTextField(
              l10n.contactEmailLabel,
              l10n.contactEmailPlaceholder,
            ),
            const SizedBox(height: 24),
            _buildTextField(
              l10n.contactPhoneLabel,
              l10n.contactPhonePlaceholder,
            ),
            const SizedBox(height: 24),
            _buildDropdown(l10n.contactBranchLabel, [
              l10n.navAlgiers,
              l10n.navOran,
              l10n.navConstantine,
            ], l10n.contactBranchPlaceholder),
            const SizedBox(height: 24),
            _buildTextField(
              l10n.contactMessageLabel,
              l10n.contactMessageHint,
              maxLines: 5,
            ),
            const SizedBox(height: 32),
            _AnimatedSubmitButton(
              label: l10n.contactSendButton,
              isLoading: _isLoading,
              onTap: _submitForm,
            ),
          ],
        ),
      ),
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
          ),
          items: items
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: (val) {},
        ),
      ],
    );
  }

  Widget _buildInfoCards(AppLocalizations l10n, bool isDark) {
    return Column(
      children: [
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
            ],
          ),
        ),
      ],
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

  const _InteractiveInfoCard({this.title, required this.child});

  @override
  State<_InteractiveInfoCard> createState() => _InteractiveInfoCardState();
}

class _InteractiveInfoCardState extends State<_InteractiveInfoCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accent = AppColors.brandOrange;

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
        padding: const EdgeInsets.all(24),
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
