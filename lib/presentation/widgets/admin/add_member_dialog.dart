import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gyelyseedz/l10n/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../providers/admin_provider.dart';

class AddMemberDialog extends ConsumerStatefulWidget {
  final Map<String, dynamic>? member;
  const AddMemberDialog({super.key, this.member});

  @override
  ConsumerState<AddMemberDialog> createState() => _AddMemberDialogState();
}

class _AddMemberDialogState extends ConsumerState<AddMemberDialog> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  String _gender = 'male';

  @override
  void initState() {
    super.initState();
    if (widget.member != null) {
      _firstNameController.text = widget.member!['first_name'] ?? '';
      _lastNameController.text = widget.member!['last_name'] ?? '';
      _emailController.text = widget.member!['email'] ?? '';
      _phoneController.text = widget.member!['phone'] ?? '';
      _gender = widget.member!['gender'] ?? 'male';
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final l10n = AppLocalizations.of(context)!;
    if (_formKey.currentState!.validate()) {
      final memberData = {
        'first_name': _firstNameController.text,
        'last_name': _lastNameController.text,
        'email': _emailController.text,
        'phone': _phoneController.text,
        'gender': _gender,
        'password': 'password123', // Default password
        'password_confirmation': 'password123',
        'type': 'member',
      };

      try {
        if (widget.member == null) {
          // Add
          await ref
              .read(adminControllerProvider.notifier)
              .addMember(memberData);
        } else {
          // Edit
          await ref
              .read(adminControllerProvider.notifier)
              .updateMember(widget.member!['id'], memberData);
        }

        if (mounted) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                widget.member == null
                    ? l10n.adminDialogMemberSuccessAdd
                    : l10n.adminDialogMemberSuccessUpdate,
              ),
              backgroundColor: Colors.green,
            ),
          );
          // Refresh list
          ref.invalidate(adminMembersProvider);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.adminDialogMemberErrorSave(e.toString())),
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Dialog(
      backgroundColor: isDark ? AppColors.cardDark : Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        padding: const EdgeInsets.all(24),
        constraints: const BoxConstraints(maxWidth: 400),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.member == null
                    ? l10n.adminDialogAddMemberTitle
                    : l10n.adminDialogEditMemberTitle,
                style: GoogleFonts.oswald(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
              const SizedBox(height: 24),
              _buildTextField(l10n.adminDialogFirstName, _firstNameController),
              const SizedBox(height: 16),
              _buildTextField(l10n.adminDialogLastName, _lastNameController),
              const SizedBox(height: 16),
              _buildTextField(
                l10n.adminDialogEmail,
                _emailController,
                TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                l10n.adminDialogPhone,
                _phoneController,
                TextInputType.phone,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                // ignore: deprecated_member_use
                value: _gender,
                dropdownColor: isDark ? AppColors.cardDark : Colors.white,
                style: GoogleFonts.inter(
                  color: isDark ? Colors.white : Colors.black,
                ),
                decoration: InputDecoration(
                  labelText: l10n.adminDialogGender,
                  labelStyle: const TextStyle(color: Colors.grey),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: isDark
                          ? Colors.white.withValues(alpha: 0.1)
                          : Colors.grey[300]!,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: AppColors.brandOrange),
                  ),
                ),
                items: [
                  DropdownMenuItem(
                    value: 'male',
                    child: Text(l10n.adminDialogGenderMale),
                  ),
                  DropdownMenuItem(
                    value: 'female',
                    child: Text(l10n.adminDialogGenderFemale),
                  ),
                ],
                onChanged: (val) => setState(() => _gender = val!),
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(
                      l10n.adminDialogCancel,
                      style: TextStyle(
                        color: isDark ? Colors.grey[400] : Colors.grey[600],
                      ),
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
                      widget.member == null
                          ? l10n.adminDialogAddMemberButton
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

  Widget _buildTextField(
    String label,
    TextEditingController controller, [
    TextInputType? type,
  ]) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return TextFormField(
      controller: controller,
      keyboardType: type,
      style: TextStyle(color: isDark ? Colors.white : Colors.black),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.grey),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: isDark
                ? Colors.white.withValues(alpha: 0.1)
                : Colors.grey[300]!,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.brandOrange),
        ),
      ),
      validator: (value) =>
          value?.isEmpty ?? true ? l10n.adminDialogRequired : null,
    );
  }
}
