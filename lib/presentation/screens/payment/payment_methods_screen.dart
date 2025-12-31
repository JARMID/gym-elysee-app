import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gyelyseedz/l10n/app_localizations.dart';
import 'package:image_picker/image_picker.dart';
import '../../providers/payment_provider.dart';

class PaymentMethodsScreen extends ConsumerStatefulWidget {
  final double amount;
  final Function(String method)? onMethodSelected;

  const PaymentMethodsScreen({
    super.key,
    required this.amount,
    this.onMethodSelected,
  });

  @override
  ConsumerState<PaymentMethodsScreen> createState() =>
      _PaymentMethodsScreenState();
}

class _PaymentMethodsScreenState extends ConsumerState<PaymentMethodsScreen> {
  String? _selectedMethod;

  List<PaymentMethod> _getMethods(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return [
      PaymentMethod(
        id: 'edahabia',
        name: l10n.paymentMethodEdahabia,
        description: l10n.paymentMethodEdahabiaDesc,
        iconPath: 'assets/images/edahabia_logo.png',
        color: const Color(0xFF0066CC),
      ),
      PaymentMethod(
        id: 'cib',
        name: l10n.paymentMethodCib,
        description: l10n.paymentMethodCibDesc,
        iconPath: 'assets/images/cib_logo.png',
        color: const Color(0xFF1E88E5),
      ),

      PaymentMethod(
        id: 'cash',
        name: l10n.paymentMethodCash,
        description: l10n.paymentMethodCashDesc,
        iconPath: null,
        icon: Icons.money,
        color: const Color(0xFF4CAF50),
      ),
      PaymentMethod(
        id: 'bank_transfer',
        name: l10n.paymentMethodTransfer,
        description: l10n.paymentMethodTransferDesc,
        iconPath: null,
        icon: Icons.account_balance,
        color: const Color(0xFF9C27B0),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final methods = _getMethods(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.paymentTitle)),
      body: Column(
        children: [
          // Amount Display
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Theme.of(
                context,
              ).colorScheme.primary.withValues(alpha: 0.1),
            ),
            child: Column(
              children: [
                Text(
                  l10n.paymentAmount,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: Colors.grey),
                ),
                const SizedBox(height: 8),
                Text(
                  '${widget.amount.toStringAsFixed(0)} DZD',
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),

          // Payment Methods List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: methods.length,
              itemBuilder: (context, index) {
                final method = methods[index];
                final isSelected = _selectedMethod == method.id;

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  elevation: isSelected ? 4 : 1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(
                      color: isSelected ? method.color : Colors.transparent,
                      width: 2,
                    ),
                  ),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _selectedMethod = method.id;
                      });
                      widget.onMethodSelected?.call(method.id);
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          // Icon/Logo
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: method.color.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: method.iconPath != null
                                ? Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Image.asset(
                                      method.iconPath!,
                                      fit: BoxFit.contain,
                                    ),
                                  )
                                : Icon(
                                    method.icon,
                                    color: method.color,
                                    size: 30,
                                  ),
                          ),
                          const SizedBox(width: 16),

                          // Info
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  method.name,
                                  style: Theme.of(context).textTheme.titleMedium
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  method.description,
                                  style: Theme.of(context).textTheme.bodySmall
                                      ?.copyWith(color: Colors.grey),
                                ),
                              ],
                            ),
                          ),

                          // Radio Button
                          Radio<String>(
                            value: method.id,
                            // ignore: deprecated_member_use
                            groupValue: _selectedMethod,
                            // ignore: deprecated_member_use
                            onChanged: (value) {
                              setState(() {
                                _selectedMethod = value;
                              });
                              widget.onMethodSelected?.call(method.id);
                            },
                            activeColor: method.color,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Continue Button
          if (_selectedMethod != null)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    _handlePayment();
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(l10n.paymentContinue),
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _handlePayment() {
    if (_selectedMethod == null) return;

    switch (_selectedMethod) {
      case 'edahabia':
      case 'cib':
      case 'baridimob':
        // Navigate to payment webview or instructions
        _showPaymentInstructions(_selectedMethod!);
        break;
      case 'cash':
        // Show cash payment confirmation
        _showCashConfirmation();
        break;
      case 'bank_transfer':
        // Show bank transfer details
        _showBankTransferDetails();
        break;
    }
  }

  void _showPaymentInstructions(String method) {
    final l10n = AppLocalizations.of(context)!;
    final methods = _getMethods(context);
    final methodName = methods.firstWhere((m) => m.id == method).name;
    final ImagePicker picker = ImagePicker();

    showDialog(
      context: context,
      builder: (context) => Consumer(
        builder: (context, ref, child) {
          final paymentState = ref.watch(paymentControllerProvider);
          return AlertDialog(
            title: Text(l10n.paymentInstructionsTitle(methodName)),
            content: paymentState.isLoading
                ? const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(width: 16),
                      Text("Uploading..."),
                    ],
                  )
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.paymentInstructions,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(l10n.paymentInstructionStep1(methodName)),
                      const SizedBox(height: 4),
                      Text(l10n.paymentInstructionStep2),
                      const SizedBox(height: 4),
                      Text(l10n.paymentInstructionStep3),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            final XFile? image = await picker.pickImage(
                              source: ImageSource.gallery,
                            );
                            if (image != null) {
                              await ref
                                  .read(paymentControllerProvider.notifier)
                                  .uploadProof(
                                    file: image,
                                    amount: widget.amount,
                                    method: method,
                                  );

                              // ignore: use_build_context_synchronously
                              if (!context.mounted) return;

                              final state = ref.read(paymentControllerProvider);
                              if (state.hasError) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Error: ${state.error}'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              } else {
                                Navigator.of(context).pop(); // Close Dialog
                                Navigator.of(
                                  context,
                                ).pop(); // Close Payment Screen? Or show success?
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(l10n.paymentProofSuccess),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                              }
                            }
                          },
                          icon: const Icon(Icons.upload_file),
                          label: Text(l10n.paymentUploadProof),
                        ),
                      ),
                    ],
                  ),
            actions: [
              if (!paymentState.isLoading)
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(l10n.dashboardCancel),
                ),
            ],
          );
        },
      ),
    );
  }

  void _showCashConfirmation() {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.paymentCashTitle),
        content: Text(l10n.paymentCashContent),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              // Cash requires no upload usually? Or maybe simple request?
              // For now just confirmation.
            },
            child: Text(l10n.paymentUnderstood),
          ),
        ],
      ),
    );
  }

  void _showBankTransferDetails() {
    // Reuse logic or create similar upload flow
    // For bank transfer, upload is also needed.
    // So let's redirect to _showPaymentInstructions logic but with Bank Transfer title?
    // The current UI separates them.
    // Let's modify logic to also support upload here.

    final l10n = AppLocalizations.of(context)!;
    final ImagePicker picker = ImagePicker();

    showDialog(
      context: context,
      builder: (context) => Consumer(
        builder: (context, ref, child) {
          final paymentState = ref.watch(paymentControllerProvider);
          return AlertDialog(
            title: Text(l10n.paymentTransferTitle),
            content: paymentState.isLoading
                ? const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(width: 16),
                      Text("Uploading..."),
                    ],
                  )
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(l10n.paymentTransferTo),
                      const SizedBox(height: 16),
                      _buildBankDetail(
                        l10n.paymentTransferBank,
                        'Algérie Poste',
                      ),
                      _buildBankDetail(
                        l10n.paymentTransferRib,
                        '1234567890123456789012',
                      ),
                      _buildBankDetail(
                        l10n.paymentTransferAmount,
                        '${widget.amount.toStringAsFixed(0)} DZD',
                      ),
                      const SizedBox(height: 16),
                      Text(
                        l10n.paymentTransferUploadHint,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            final XFile? image = await picker.pickImage(
                              source: ImageSource.gallery,
                            );
                            if (image != null) {
                              await ref
                                  .read(paymentControllerProvider.notifier)
                                  .uploadProof(
                                    file: image,
                                    amount: widget.amount,
                                    method: 'bank_transfer',
                                  );

                              // ignore: use_build_context_synchronously
                              if (!context.mounted) return;

                              final state = ref.read(paymentControllerProvider);
                              if (state.hasError) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Error: ${state.error}'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              } else {
                                Navigator.of(context).pop();
                                Navigator.of(context).pop();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(l10n.paymentProofSuccess),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                              }
                            }
                          },
                          icon: const Icon(Icons.upload_file),
                          label: Text(l10n.paymentUploadProof),
                        ),
                      ),
                    ],
                  ),
            actions: [
              if (!paymentState.isLoading)
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(l10n.paymentClose),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildBankDetail(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(value),
        ],
      ),
    );
  }
}

class PaymentMethod {
  final String id;
  final String name;
  final String description;
  final String? iconPath;
  final IconData? icon;
  final Color color;

  PaymentMethod({
    required this.id,
    required this.name,
    required this.description,
    this.iconPath,
    this.icon,
    required this.color,
  });
}
