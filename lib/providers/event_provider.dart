import 'package:flutter/foundation.dart';

import 'package:unisphere/models/event_model.dart';
import 'package:unisphere/repositories/event_repository.dart';

/// Provides centralized event state for all screens.
///
/// Holds the event list, loading/error states, search/filter logic,
/// and CRUD operations delegated to an [EventRepository].
///
/// Any screen that watches this provider automatically rebuilds
/// when events are added, updated, or filtered.
class EventProvider extends ChangeNotifier {
  final EventRepository _repository;

  EventProvider(this._repository);

  // ── State ────────────────────────────────────────────────────

  List<EventModel> _events = [];
  bool _isLoading = false;
  String? _error;
  String _searchQuery = '';

  // ── Getters ──────────────────────────────────────────────────

  List<EventModel> get events => _searchQuery.isEmpty
      ? List.unmodifiable(_events)
      : List.unmodifiable(_filteredEvents);

  List<EventModel> get allEvents => List.unmodifiable(_events);
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get searchQuery => _searchQuery;

  List<EventModel> get _filteredEvents {
    final q = _searchQuery.toLowerCase();
    return _events
        .where((e) =>
            e.name.toLowerCase().contains(q) ||
            e.club.toLowerCase().contains(q))
        .toList();
  }

  // ── Actions ──────────────────────────────────────────────────

  /// Loads all events from the repository.
  Future<void> loadEvents({String? clubId, EventStatus? status}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _events = await _repository.getEvents(clubId: clubId, status: status);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to load events: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Updates the search query and triggers a rebuild.
  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  /// Clears the search query.
  void clearSearch() {
    _searchQuery = '';
    notifyListeners();
  }

  /// Creates a new event (admin action).
  Future<EventModel?> createEvent(EventModel event) async {
    try {
      final created = await _repository.createEvent(event);
      _events.add(created);
      notifyListeners();
      return created;
    } catch (e) {
      _error = 'Failed to create event: $e';
      notifyListeners();
      return null;
    }
  }

  /// Updates an existing event (admin action).
  Future<bool> updateEvent(EventModel event) async {
    try {
      await _repository.updateEvent(event);
      final index = _events.indexWhere((e) => e.id == event.id);
      if (index != -1) {
        _events[index] = event;
        notifyListeners();
      }
      return true;
    } catch (e) {
      _error = 'Failed to update event: $e';
      notifyListeners();
      return false;
    }
  }

  /// Deletes an event (admin action).
  Future<bool> deleteEvent(String id) async {
    try {
      await _repository.deleteEvent(id);
      _events.removeWhere((e) => e.id == id);
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'Failed to delete event: $e';
      notifyListeners();
      return false;
    }
  }

  /// Gets a single event by ID from the loaded list.
  EventModel? getEventById(String id) {
    try {
      return _events.firstWhere((e) => e.id == id);
    } catch (_) {
      return null;
    }
  }

  /// Clears any pending error.
  void clearError() {
    _error = null;
    notifyListeners();
  }
}
