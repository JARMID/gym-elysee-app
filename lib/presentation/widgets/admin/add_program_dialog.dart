import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gyelyseedz/l10n/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../providers/admin_provider.dart';

class AddProgramDialog extends ConsumerStatefulWidget {
  final Map<String, dynamic>? program;
  const AddProgramDialog({super.key, this.program});

  @override
  ConsumerState<AddProgramDialog> createState() => _AddProgramDialogState();
}

class _AddProgramDialogState extends ConsumerState<AddProgramDialog> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _durationController = TextEditingController();
  String _selectedLevel =
      'Beginner'; // Key used for logic, should map to localized display but here we just need to be careful.
  // Actually, _selectedLevel is likely used as a value in the backend. If the backend expects specific strings like "Beginner",
  // we should keep the internal value as "Beginner" but display the localized version.

  // Let's assume the backend expects English keys.
  final List<String> _levels = [
    'Beginner',
    'Intermediate',
    'Advanced',
    'All Levels',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.program != null) {
      _titleController.text =
          widget.program!['name'] ?? widget.program!['title'] ?? '';
      _descriptionController.text = widget.program!['description'] ?? '';
      _durationController.text =
          (widget.program!['duration_weeks'] ??
                  widget.program!['duration'] ??
                  4)
              .toString();
      // Map backend level values to display values
      final level = widget.program!['level'] ?? 'beginner';
      _selectedLevel = _mapLevelFromApi(level);
    }
  }

  String _mapLevelFromApi(String level) {
    switch (level.toLowerCase()) {
      case 'beginner':
        return 'Beginner';
      case 'intermediate':
        return 'Intermediate';
      case 'advanced':
        return 'Advanced';
      case 'pro':
      case 'all_levels':
        return 'All Levels';
      default:
        return 'Beginner';
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _durationController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final l10n = AppLocalizations.of(context)!;
    if (_formKey.currentState!.validate()) {
      final programData = {
        'name': _titleController.text,
        'description': _descriptionController.text,
        'duration_weeks': int.tryParse(_durationController.text) ?? 4,
        'level': _selectedLevel.toLowerCase().replaceAll(' ', '_'),
        'branch_id':
            1, // Default branch - should be selectable in full implementation
        'type': 'general', // Default type
        'is_public': true,
      };

      try {
        if (widget.program == null) {
          await ref
              .read(adminControllerProvider.notifier)
              .createProgram(programData);
        } else {
          await ref
              .read(adminControllerProvider.notifier)
              .updateProgram(widget.program!['id'], programData);
        }

        if (mounted) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                widget.program == null
                    ? l10n.adminDialogProgramSuccessCreate(
                        programData['title'] as String,
                      )
                    : l10n.adminDialogProgramSuccessUpdate(
                        programData['title'] as String,
                      ),
              ),
              backgroundColor: Colors.green,
            ),
          );
          ref.invalidate(adminProgramsProvider);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.adminDialogProgramErrorCreate(e.toString())),
              backgroundColor: AppColors.error,
            ),
          );
        }
      }
    }
  }

  String _getLocalizedLevel(String level) {
    final l10n = AppLocalizations.of(context)!;
    switch (level) {
      case 'Beginner':
        return l10n.adminDialogLevelBeginner;
      case 'Intermediate':
        return l10n.adminDialogLevelIntermediate;
      case 'Advanced':
        return l10n.adminDialogLevelAdvanced;
      case 'All Levels':
        return l10n.adminDialogLevelAll;
      default:
        return level;
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
                widget.program == null
                    ? l10n.adminDialogCreateProgramTitle
                    : l10n.adminDialogEditProgramTitle,
                style: GoogleFonts.oswald(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 24),
              _buildTextField(
                controller: _titleController,
                label: l10n.adminDialogProgramTitleLabel,
                icon: Icons.title,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      controller: _durationController,
                      label: l10n.adminDialogDurationLabel,
                      icon: Icons.timer,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      // ignore: deprecated_member_use
                      value: _selectedLevel,
                      dropdownColor: AppColors.cardDark,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: l10n.adminDialogLevelLabel,
                        labelStyle: const TextStyle(color: Colors.grey),
                        prefixIcon: const Icon(
                          Icons.bar_chart,
                          color: Colors.grey,
                          size: 20,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: Colors.white.withValues(alpha: 0.1),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: AppColors.brandOrange,
                          ),
                        ),
                        filled: true,
                        fillColor: Colors.black.withValues(alpha: 0.2),
                      ),
                      items: _levels.map((level) {
                        return DropdownMenuItem(
                          value: level,
                          child: Text(_getLocalizedLevel(level)),
                        );
                      }).toList(),
                      onChanged: (val) => setState(() => _selectedLevel = val!),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _descriptionController,
                label: l10n.adminDialogDescriptionLabel,
                icon: Icons.description,
                maxLines: 4,
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
                      widget.program == null
                          ? l10n.adminDialogCreateProgramButton
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
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    final l10n = AppLocalizations.of(context)!;
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.grey),
        alignLabelWithHint: true,
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
