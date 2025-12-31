import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gyelyseedz/l10n/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../providers/admin_provider.dart';

class AddBranchDialog extends ConsumerStatefulWidget {
  final Map<String, dynamic>? branch;
  const AddBranchDialog({super.key, this.branch});

  @override
  ConsumerState<AddBranchDialog> createState() => _AddBranchDialogState();
}

class _AddBranchDialogState extends ConsumerState<AddBranchDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();
  final _managerController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.branch != null) {
      _nameController.text = widget.branch!['name'] ?? '';
      _addressController.text = widget.branch!['address'] ?? '';
      _phoneController.text = widget.branch!['phone'] ?? '';
      _managerController.text = widget.branch!['manager'] ?? '';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _managerController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final l10n = AppLocalizations.of(context)!;
    if (_formKey.currentState!.validate()) {
      final branchData = {
        'name': _nameController.text,
        'address': _addressController.text,
        'phone': _phoneController.text,
        'manager': _managerController.text,
      };

      try {
        if (widget.branch == null) {
          await ref
              .read(adminControllerProvider.notifier)
              .createBranch(branchData);
        } else {
          await ref
              .read(adminControllerProvider.notifier)
              .updateBranch(widget.branch!['id'], branchData);
        }

        if (mounted) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                widget.branch == null
                    ? l10n.adminDialogBranchSuccessAdd(
                        branchData['name'] as String,
                      )
                    : l10n.adminDialogBranchSuccessUpdate(
                        branchData['name'] as String,
                      ),
              ),
              backgroundColor: Colors.green,
            ),
          );
          ref.invalidate(adminBranchesProvider);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.adminDialogBranchErrorAdd(e.toString())),
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
                widget.branch == null
                    ? l10n.adminDialogAddBranchTitle
                    : l10n.adminDialogEditBranchTitle,
                style: GoogleFonts.oswald(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 24),
              _buildTextField(
                controller: _nameController,
                label: l10n.adminDialogBranchNameLabel,
                icon: Icons.store,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _addressController,
                label: l10n.adminDialogAddressLabel,
                icon: Icons.location_on,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      controller: _phoneController,
                      label: l10n.adminDialogPhone,
                      icon: Icons.phone,
                      keyboardType: TextInputType.phone,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildTextField(
                      controller: _managerController,
                      label: l10n.adminDialogManagerNameLabel,
                      icon: Icons.person_outline,
                    ),
                  ),
                ],
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
                      widget.branch == null
                          ? l10n.adminDialogAddBranchButton
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
  }) {
    final l10n = AppLocalizations.of(context)!;
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
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
