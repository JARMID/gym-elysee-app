import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gyelyseedz/l10n/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../providers/admin_provider.dart';

class AddCoachDialog extends ConsumerStatefulWidget {
  final Map<String, dynamic>? coach;
  const AddCoachDialog({super.key, this.coach});

  @override
  ConsumerState<AddCoachDialog> createState() => _AddCoachDialogState();
}

class _AddCoachDialogState extends ConsumerState<AddCoachDialog> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _specializationController = TextEditingController();
  final _bioController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.coach != null) {
      _firstNameController.text = widget.coach!['first_name'] ?? '';
      _lastNameController.text = widget.coach!['last_name'] ?? '';
      _specializationController.text = widget.coach!['specialization'] ?? '';
      _bioController.text = widget.coach!['bio'] ?? '';
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _specializationController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final l10n = AppLocalizations.of(context)!;
    if (_formKey.currentState!.validate()) {
      final coachData = {
        'first_name': _firstNameController.text,
        'last_name': _lastNameController.text,
        'specialization': _specializationController.text,
        'bio': _bioController.text,
        // 'image': ... // Image upload to be implemented
      };

      try {
        if (widget.coach == null) {
          // Add
          await ref.read(adminControllerProvider.notifier).addCoach(coachData);
        } else {
          // Edit
          await ref
              .read(adminControllerProvider.notifier)
              .updateCoach(widget.coach!['id'], coachData);
        }

        if (mounted) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                widget.coach == null
                    ? l10n.adminDialogCoachSuccessAdd
                    : l10n.adminDialogCoachSuccessUpdate,
              ),
              backgroundColor: Colors.green,
            ),
          );
          // Trigger refresh
          ref.invalidate(adminCoachesProvider);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.adminDialogCoachErrorSave(e.toString())),
              backgroundColor: AppColors.error,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Dialog(
      backgroundColor: AppColors.cardDark,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        padding: const EdgeInsets.all(24),
        constraints: const BoxConstraints(maxWidth: 500),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.coach == null
                    ? l10n.adminDialogAddCoachTitle
                    : l10n.adminDialogEditCoachTitle,
                style: GoogleFonts.oswald(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      controller: _firstNameController,
                      label: l10n.adminDialogFirstName,
                      icon: Icons.person,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildTextField(
                      controller: _lastNameController,
                      label: l10n.adminDialogLastName,
                      icon: Icons.person_outline,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _specializationController,
                label: l10n.adminDialogSpecialization,
                icon: Icons.fitness_center,
                hint: l10n.adminDialogSpecializationHint,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _bioController,
                label: l10n.adminDialogBio,
                icon: Icons.info_outline,
                maxLines: 3,
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(
                      l10n.adminDialogCancel,
                      style: TextStyle(color: Colors.grey[400]),
                    ),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.brandOrange,
                      foregroundColor: Colors.white,
                    ),
                    child: Text(
                      widget.coach == null
                          ? l10n.adminDialogAddCoachButton
                          : l10n.adminDialogSaveChanges,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? hint,
    int maxLines = 1,
  }) {
    final l10n = AppLocalizations.of(context)!;
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.grey),
        alignLabelWithHint: true,
        hintText: hint,
        hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.3)),
        prefixIcon: Icon(icon, color: Colors.grey, size: 20),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.brandOrange),
        ),
        filled: true,
        fillColor: Colors.black.withValues(alpha: 0.2),
      ),
      validator: (value) =>
          value?.isEmpty ?? true ? l10n.adminDialogRequired : null,
    );
  }
}
