import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:unisphere/app/theme.dart';
import 'package:unisphere/models/event_model.dart';
import 'package:unisphere/providers/auth_provider.dart';
import 'package:unisphere/providers/event_provider.dart';

/// Admin screen for creating new events.
///
/// Validates all fields, delegates creation to [EventProvider],
/// and navigates back on success. Only accessible to admin users.
class CreateEventScreen extends StatefulWidget {
  const CreateEventScreen({super.key});

  @override
  State<CreateEventScreen> createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _clubController = TextEditingController();
  final _dateController = TextEditingController();
  final _timeController = TextEditingController();
  final _venueController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _capacityController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _nameController.dispose();
    _clubController.dispose();
    _dateController.dispose();
    _timeController.dispose();
    _venueController.dispose();
    _descriptionController.dispose();
    _capacityController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    final auth = context.read<AuthProvider>();
    final eventProvider = context.read<EventProvider>();

    final event = EventModel(
      id: '', // Will be assigned by repository
      name: _nameController.text.trim(),
      club: _clubController.text.trim(),
      date: _dateController.text.trim(),
      time: _timeController.text.trim(),
      venue: _venueController.text.trim(),
      description: _descriptionController.text.trim(),
      capacity: int.tryParse(_capacityController.text.trim()) ?? 0,
      status: EventStatus.published,
      createdBy: auth.userId,
    );

    final created = await eventProvider.createEvent(event);

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
              Expanded(
                child: Text('Event "${created.name}" created successfully!'),
              ),
            ],
          ),
        ),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to create event. Please try again.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final horizontalPadding = screenWidth > 600 ? 48.0 : 20.0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Event'),
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
                      Icons.event_rounded,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('New Event', style: theme.textTheme.titleLarge),
                        const SizedBox(height: 2),
                        Text(
                          'Fill in the details below',
                          style: theme.textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 28),

              // ── Event Name ──
              TextFormField(
                controller: _nameController,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'Event Name',
                  prefixIcon: Icon(Icons.title_rounded),
                ),
                validator: (value) =>
                    value == null || value.trim().isEmpty
                        ? 'Event name is required'
                        : null,
              ),
              const SizedBox(height: 16),

              // ── Club Name ──
              TextFormField(
                controller: _clubController,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'Club / Organization',
                  prefixIcon: Icon(Icons.groups_rounded),
                ),
                validator: (value) =>
                    value == null || value.trim().isEmpty
                        ? 'Club name is required'
                        : null,
              ),
              const SizedBox(height: 16),

              // ── Date & Time row ──
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _dateController,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        labelText: 'Date',
                        prefixIcon: Icon(Icons.calendar_today_rounded),
                        hintText: 'Mar 5, 2026',
                      ),
                      validator: (value) =>
                          value == null || value.trim().isEmpty
                              ? 'Date is required'
                              : null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _timeController,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        labelText: 'Time',
                        prefixIcon: Icon(Icons.schedule_rounded),
                        hintText: '10:00 AM – 1:00 PM',
                      ),
                      validator: (value) =>
                          value == null || value.trim().isEmpty
                              ? 'Time is required'
                              : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // ── Venue & Capacity row ──
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: TextFormField(
                      controller: _venueController,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        labelText: 'Venue',
                        prefixIcon: Icon(Icons.location_on_rounded),
                      ),
                      validator: (value) =>
                          value == null || value.trim().isEmpty
                              ? 'Venue is required'
                              : null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _capacityController,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Capacity',
                        prefixIcon: Icon(Icons.people_rounded),
                        hintText: '0 = unlimited',
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // ── Description ──
              TextFormField(
                controller: _descriptionController,
                maxLines: 4,
                textInputAction: TextInputAction.done,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  prefixIcon: Padding(
                    padding: EdgeInsets.only(bottom: 56),
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
                    : const Text('Create Event'),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
