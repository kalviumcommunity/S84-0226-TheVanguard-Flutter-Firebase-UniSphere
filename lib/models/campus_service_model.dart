/// Campus service models for student utilities.
import 'package:flutter/material.dart';

/// Represents a campus service/facility.
class CampusService {
  final String id;
  final String name;
  final String description;
  final IconData icon;
  final String? location;
  final String? hours;
  final String? phone;
  final String? email;
  final ServiceCategory category;
  final List<Color> gradientColors;

  const CampusService({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    this.location,
    this.hours,
    this.phone,
    this.email,
    required this.category,
    required this.gradientColors,
  });
}

enum ServiceCategory {
  academic,
  dining,
  health,
  transportation,
  recreation,
  administrative,
  emergency;

  String get displayName {
    switch (this) {
      case ServiceCategory.academic:
        return 'Academic';
      case ServiceCategory.dining:
        return 'Dining';
      case ServiceCategory.health:
        return 'Health & Wellness';
      case ServiceCategory.transportation:
        return 'Transportation';
      case ServiceCategory.recreation:
        return 'Recreation';
      case ServiceCategory.administrative:
        return 'Administrative';
      case ServiceCategory.emergency:
        return 'Emergency';
    }
  }
}

/// Quick action item for the home screen.
class QuickAction {
  final String id;
  final String label;
  final IconData icon;
  final String route;
  final List<Color> gradientColors;

  const QuickAction({
    required this.id,
    required this.label,
    required this.icon,
    required this.route,
    required this.gradientColors,
  });
}

/// Library book model.
class LibraryBook {
  final String id;
  final String title;
  final String author;
  final String isbn;
  final DateTime? borrowedDate;
  final DateTime? dueDate;
  final bool isAvailable;
  final String? coverUrl;

  const LibraryBook({
    required this.id,
    required this.title,
    required this.author,
    required this.isbn,
    this.borrowedDate,
    this.dueDate,
    this.isAvailable = true,
    this.coverUrl,
  });

  bool get isOverdue =>
      dueDate != null && dueDate!.isBefore(DateTime.now());

  int get daysUntilDue =>
      dueDate?.difference(DateTime.now()).inDays ?? 0;
}

/// Cafeteria menu item.
class MenuItem {
  final String id;
  final String name;
  final String description;
  final double price;
  final String category;
  final bool isVegetarian;
  final bool isVegan;
  final String? imageUrl;
  final int calories;

  const MenuItem({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    this.isVegetarian = false,
    this.isVegan = false,
    this.imageUrl,
    required this.calories,
  });
}

/// Campus shuttle/bus schedule.
class ShuttleRoute {
  final String id;
  final String name;
  final List<String> stops;
  final String frequency;
  final String operatingHours;
  final bool isActive;

  const ShuttleRoute({
    required this.id,
    required this.name,
    required this.stops,
    required this.frequency,
    required this.operatingHours,
    this.isActive = true,
  });
}

/// Emergency contact.
class EmergencyContact {
  final String id;
  final String name;
  final String phone;
  final String? description;
  final IconData icon;
  final bool isPrimary;

  const EmergencyContact({
    required this.id,
    required this.name,
    required this.phone,
    this.description,
    required this.icon,
    this.isPrimary = false,
  });
}
