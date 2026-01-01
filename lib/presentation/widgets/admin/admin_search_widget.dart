import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../providers/global_search_provider.dart';
import '../../../core/theme/app_colors.dart';
import 'add_member_dialog.dart';
import 'add_coach_dialog.dart';
import 'add_program_dialog.dart';

class AdminSearchWidget extends ConsumerStatefulWidget {
  final bool isDark;

  const AdminSearchWidget({super.key, required this.isDark});

  @override
  ConsumerState<AdminSearchWidget> createState() => _AdminSearchWidgetState();
}

class _AdminSearchWidgetState extends ConsumerState<AdminSearchWidget> {
  final _searchController = TextEditingController();
  final _focusNode = FocusNode();
  final _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        _showOverlay();
      } else {
        // Delay hiding to allow tap events on the overlay
        Future.delayed(const Duration(milliseconds: 200), _hideOverlay);
      }
    });

    _searchController.addListener(() {
      if (_searchController.text.isNotEmpty) {
        _showOverlay();
      } else {
        _hideOverlay();
      }
    });
  }

  @override
  void dispose() {
    _hideOverlay();
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _showOverlay() {
    if (_overlayEntry != null) {
      _overlayEntry!.markNeedsBuild();
      return;
    }

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        width: 300, // Match search bar width
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: const Offset(0, 50),
          child: Material(
            elevation: 8,
            color: widget.isDark ? const Color(0xFF1E1E1E) : Colors.white,
            borderRadius: BorderRadius.circular(12),
            child: _SearchResultsList(
              controller: _searchController,
              isDark: widget.isDark,
              onClose: _hideOverlay,
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void _hideOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: Container(
        width: 300,
        height: 44,
        decoration: BoxDecoration(
          color: widget.isDark
              ? Colors.white.withValues(alpha: 0.05)
              : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: widget.isDark
                ? Colors.white.withValues(alpha: 0.1)
                : Colors.grey.shade300,
          ),
        ),
        child: Row(
          children: [
            const SizedBox(width: 14),
            Icon(Icons.search, size: 20, color: Colors.grey.shade500),
            const SizedBox(width: 10),
            Expanded(
              child: TextField(
                controller: _searchController,
                focusNode: _focusNode,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: widget.isDark ? Colors.white : Colors.black87,
                ),
                decoration: InputDecoration(
                  hintText: 'Search members, coaches...',
                  hintStyle: GoogleFonts.inter(
                    fontSize: 14,
                    color: Colors.grey.shade500,
                  ),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ),
            if (_searchController.text.isNotEmpty)
              IconButton(
                icon: const Icon(Icons.close, size: 16, color: Colors.grey),
                onPressed: () {
                  _searchController.clear();
                  _hideOverlay();
                },
              ),
            const SizedBox(width: 8),
          ],
        ),
      ),
    );
  }
}

class _SearchResultsList extends ConsumerWidget {
  final TextEditingController controller;
  final bool isDark;
  final VoidCallback onClose;

  const _SearchResultsList({
    required this.controller,
    required this.isDark,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final query = controller.text;
    if (query.isEmpty) return const SizedBox();

    final resultsAsync = ref.watch(globalSearchProvider(query));

    return resultsAsync.when(
      data: (results) {
        if (results.isEmpty) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'No results found',
              style: TextStyle(color: isDark ? Colors.grey : Colors.black54),
            ),
          );
        }

        return Container(
          constraints: const BoxConstraints(maxHeight: 400),
          child: ListView(
            padding: const EdgeInsets.symmetric(vertical: 8),
            shrinkWrap: true,
            children: [
              if (results.members.isNotEmpty) ...[
                _buildHeader('Members'),
                ...results.members.map((m) => _buildMemberItem(context, m)),
              ],
              if (results.coaches.isNotEmpty) ...[
                _buildHeader('Coaches'),
                ...results.coaches.map((c) => _buildCoachItem(context, c)),
              ],
              if (results.programs.isNotEmpty) ...[
                _buildHeader('Programs'),
                ...results.programs.map((p) => _buildProgramItem(context, p)),
              ],
            ],
          ),
        );
      },
      loading: () => const Padding(
        padding: EdgeInsets.all(16),
        child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
      ),
      error: (err, stack) => Padding(
        padding: const EdgeInsets.all(16),
        child: Text('Error: $err'),
      ),
    );
  }

  Widget _buildHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Text(
        title.toUpperCase(),
        style: GoogleFonts.oswald(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: AppColors.brandOrange,
          letterSpacing: 1,
        ),
      ),
    );
  }

  Widget _buildMemberItem(BuildContext context, dynamic member) {
    return ListTile(
      leading: const CircleAvatar(
        radius: 14,
        backgroundColor: Colors.blue,
        child: FaIcon(FontAwesomeIcons.user, size: 12, color: Colors.white),
      ),
      title: Text(
        '${member['first_name']} ${member['last_name']}',
        style: TextStyle(
          color: isDark ? Colors.white : Colors.black,
          fontSize: 14,
        ),
      ),
      subtitle: Text(
        member['email'] ?? '',
        style: TextStyle(
          color: isDark ? Colors.grey : Colors.black54,
          fontSize: 12,
        ),
        overflow: TextOverflow.ellipsis,
      ),
      onTap: () {
        onClose();
        showDialog(
          context: context,
          builder: (context) => AddMemberDialog(member: member),
        );
      },
    );
  }

  Widget _buildCoachItem(BuildContext context, dynamic coach) {
    return ListTile(
      leading: const CircleAvatar(
        radius: 14,
        backgroundColor: Colors.purple,
        child: FaIcon(FontAwesomeIcons.userTie, size: 12, color: Colors.white),
      ),
      title: Text(
        coach['name'] ?? 'Coach',
        style: TextStyle(
          color: isDark ? Colors.white : Colors.black,
          fontSize: 14,
        ),
      ),
      subtitle: Text(
        coach['specialty'] ?? '',
        style: TextStyle(
          color: isDark ? Colors.grey : Colors.black54,
          fontSize: 12,
        ),
      ),
      onTap: () {
        onClose();
        showDialog(
          context: context,
          builder: (context) => AddCoachDialog(coach: coach),
        );
      },
    );
  }

  Widget _buildProgramItem(BuildContext context, dynamic program) {
    return ListTile(
      leading: const CircleAvatar(
        radius: 14,
        backgroundColor: Colors.orange,
        child: FaIcon(FontAwesomeIcons.dumbbell, size: 12, color: Colors.white),
      ),
      title: Text(
        program['title'] ?? 'Program',
        style: TextStyle(
          color: isDark ? Colors.white : Colors.black,
          fontSize: 14,
        ),
      ),
      onTap: () {
        onClose();
        showDialog(
          context: context,
          builder: (context) => AddProgramDialog(program: program),
        );
      },
    );
  }
}
