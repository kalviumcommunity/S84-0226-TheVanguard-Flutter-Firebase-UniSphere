import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../app/theme.dart';
import '../../models/announcement_model.dart';
import '../../providers/announcement_provider.dart';
import '../../providers/auth_provider.dart';

/// Admin screen for posting new announcements.
///
/// Supports priority levels and club/campus scope.
/// Delegates creation to [AnnouncementProvider].
class CreateAnnouncementScreen extends StatefulWidget {
  const CreateAnnouncementScreen({super.key});

  @override
  State<CreateAnnouncementScreen> createState() =>
      _CreateAnnouncementScreenState();
}

class _CreateAnnouncementScreenState extends State<CreateAnnouncementScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  AnnouncementPriority _priority = AnnouncementPriority.normal;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    final auth = context.read<AuthProvider>();
    final announcementProvider = context.read<AnnouncementProvider>();

    final now = DateTime.now();
    final dateStr =
        '${_monthName(now.month)} ${now.day}, ${now.year}';

    final announcement = AnnouncementModel(
      id: '',
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      postedBy: auth.currentUser?.name ?? 'Admin',
      date: dateStr,
      priority: _priority,
      scope: AnnouncementScope.campusWide,
    );

    final created =
        await announcementProvider.createAnnouncement(announcement);

    if (!mounted) return;

    setState(() => _isSubmitting = false);

    if (created != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle_rounded,
                  color: Colors.white, size: 20),
              const SizedBox(width: 10),
              const Expanded(
                child: Text('Announcement posted successfully!'),
              ),
            ],
          ),
        ),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to post announcement. Please try again.'),
        ),
      );
    }
  }

  String _monthName(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return months[month - 1];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final horizontalPadding = screenWidth > 600 ? 48.0 : 20.0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('New Announcement'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding,
          vertical: 24,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── Header ──
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          UniSphereTheme.primaryColor,
                          UniSphereTheme.primaryDark,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(
                      Icons.campaign_rounded,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Post Announcement',
                          style: theme.textTheme.titleLarge,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Share updates with the campus',
                          style: theme.textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 28),

              // ── Title ──
              TextFormField(
                controller: _titleController,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  prefixIcon: Icon(Icons.title_rounded),
                ),
                validator: (value) =>
                    value == null || value.trim().isEmpty
                        ? 'Title is required'
                        : null,
              ),
              const SizedBox(height: 16),

              // ── Priority selector ──
              Text('Priority', style: theme.textTheme.titleMedium),
              const SizedBox(height: 8),
              Row(
                children: AnnouncementPriority.values.map((p) {
                  final isSelected = _priority == p;
                  return Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                        right: p != AnnouncementPriority.urgent ? 8 : 0,
                      ),
                      child: ChoiceChip(
                        label: Text(
                          p.name[0].toUpperCase() + p.name.substring(1),
                        ),
                        selected: isSelected,
                        onSelected: (_) {
                          setState(() => _priority = p);
                        },
                        selectedColor:
                            theme.colorScheme.primary.withAlpha(30),
                        labelStyle: TextStyle(
                          fontWeight: isSelected
                              ? FontWeight.w700
                              : FontWeight.w500,
                          color: isSelected
                              ? theme.colorScheme.primary
                              : theme.colorScheme.onSurface,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),

              // ── Description ──
              TextFormField(
                controller: _descriptionController,
                maxLines: 5,
                textInputAction: TextInputAction.done,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  prefixIcon: Padding(
                    padding: EdgeInsets.only(bottom: 80),
                    child: Icon(Icons.description_rounded),
                  ),
                  alignLabelWithHint: true,
                ),
                validator: (value) =>
                    value == null || value.trim().isEmpty
                        ? 'Description is required'
                        : null,
              ),
              const SizedBox(height: 32),

              // ── Submit button ──
              ElevatedButton(
                onPressed: _isSubmitting ? null : _handleSubmit,
                child: _isSubmitting
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          color: Colors.white,
                        ),
                      )
                    : const Text('Post Announcement'),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
