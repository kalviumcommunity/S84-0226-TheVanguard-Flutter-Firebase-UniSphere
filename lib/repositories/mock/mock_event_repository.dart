import 'package:unisphere/models/event_model.dart';
import 'package:unisphere/repositories/event_repository.dart';

/// Mock implementation of [EventRepository] using in-memory data.
///
/// Keeps the app fully functional without a backend.
/// Replace with `FirebaseEventRepository` when backend is connected.
class MockEventRepository implements EventRepository {
  final List<EventModel> _events = List.from(_seedEvents);

  @override
  Future<List<EventModel>> getEvents({
    String? clubId,
    EventStatus? status,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));
    var results = List<EventModel>.from(_events);
    if (clubId != null) {
      results = results.where((e) => e.clubId == clubId).toList();
    }
    if (status != null) {
      results = results.where((e) => e.status == status).toList();
    }
    return results;
  }

  @override
  Future<EventModel?> getEventById(String id) async {
    await Future.delayed(const Duration(milliseconds: 100));
    try {
      return _events.firstWhere((e) => e.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<EventModel> createEvent(EventModel event) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final newEvent = event.copyWith(id: 'evt_${_events.length}');
    _events.add(newEvent);
    return newEvent;
  }

  @override
  Future<void> updateEvent(EventModel event) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final index = _events.indexWhere((e) => e.id == event.id);
    if (index != -1) {
      _events[index] = event;
    }
  }

  @override
  Future<void> deleteEvent(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    _events.removeWhere((e) => e.id == id);
  }

  @override
  Future<List<EventModel>> searchEvents(String query) async {
    await Future.delayed(const Duration(milliseconds: 150));
    final lowerQuery = query.toLowerCase();
    return _events
        .where((e) =>
            e.name.toLowerCase().contains(lowerQuery) ||
            e.club.toLowerCase().contains(lowerQuery))
        .toList();
  }
}

/// Seed data — mirrors the original dummyEvents from dashboard_screen.dart.
const List<EventModel> _seedEvents = [
  EventModel(
    id: '0',
    name: 'Flutter Workshop',
    club: 'Google DSC',
    clubId: 'club_dsc',
    date: 'Mar 5, 2026',
    time: '10:00 AM – 1:00 PM',
    venue: 'Seminar Hall A',
    capacity: 60,
    registeredCount: 42,
    description:
        'A hands-on workshop covering Flutter basics, widget trees, '
        'state management, and building a complete app from scratch.',
  ),
  EventModel(
    id: '1',
    name: 'AI Hackathon',
    club: 'AI Club',
    clubId: 'club_ai',
    date: 'Mar 12, 2026',
    time: '9:00 AM – 6:00 PM',
    venue: 'Innovation Lab',
    capacity: 100,
    registeredCount: 78,
    description:
        'A full-day hackathon where teams build AI-powered prototypes. '
        'Prizes for the top three teams. Bring your laptop!',
  ),
  EventModel(
    id: '2',
    name: 'Photography Walk',
    club: 'Lens Club',
    clubId: 'club_lens',
    date: 'Mar 18, 2026',
    time: '4:00 PM – 6:30 PM',
    venue: 'Campus Gardens',
    capacity: 30,
    registeredCount: 18,
    description:
        'An outdoor photography session exploring composition, lighting, '
        'and mobile photography tips with the Lens Club mentors.',
  ),
  EventModel(
    id: '3',
    name: 'Debate Championship',
    club: 'Literary Society',
    clubId: 'club_lit',
    date: 'Mar 25, 2026',
    time: '2:00 PM – 5:00 PM',
    venue: 'Auditorium',
    capacity: 200,
    registeredCount: 95,
    description:
        'Inter-department debate competition on current affairs. '
        'Open to all years. Register as individual or pair.',
  ),
  EventModel(
    id: '4',
    name: 'Cybersecurity Bootcamp',
    club: 'InfoSec Club',
    clubId: 'club_infosec',
    date: 'Apr 2, 2026',
    time: '11:00 AM – 3:00 PM',
    venue: 'Computer Lab 3',
    capacity: 40,
    registeredCount: 32,
    description:
        'Learn ethical hacking fundamentals, network scanning, and '
        'vulnerability assessment in this beginner-friendly bootcamp.',
  ),
];
