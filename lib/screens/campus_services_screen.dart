import 'package:flutter/material.dart';

import 'package:unisphere/app/theme.dart';
import 'package:unisphere/widgets/theme_toggle_action.dart';

/// Campus services screen with all student utilities and facilities.
class CampusServicesScreen extends StatefulWidget {
  const CampusServicesScreen({super.key});

  @override
  State<CampusServicesScreen> createState() => _CampusServicesScreenState();
}

class _CampusServicesScreenState extends State<CampusServicesScreen> {
  String _selectedCategory = 'All';

  final List<String> _categories = [
    'All',
    'Academic',
    'Dining',
    'Health',
    'Transport',
    'Recreation',
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Campus Services'),
        actions: const [
          ThemeToggleAction(),
          SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Emergency Banner
            _buildEmergencyBanner(theme, isDark),

            // Category Filter
            _buildCategoryFilter(theme, isDark),

            // Services Grid
            _buildServicesGrid(theme, isDark),

            // Contact Info Section
            _buildContactSection(theme, isDark),

            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildEmergencyBanner(ThemeData theme, bool isDark) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            UniSphereTheme.error.withAlpha(200),
            UniSphereTheme.error,
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: UniSphereTheme.error.withAlpha(40),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(30),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.emergency_rounded,
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Emergency?',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Campus Security: 1800-CAMPUS',
                  style: TextStyle(
                    color: Colors.white.withAlpha(220),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              onPressed: () {
                // Call emergency
              },
              icon: const Icon(
                Icons.call_rounded,
                color: UniSphereTheme.error,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryFilter(ThemeData theme, bool isDark) {
    return SizedBox(
      height: 44,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final category = _categories[index];
          final isSelected = _selectedCategory == category;

          return GestureDetector(
            onTap: () => setState(() => _selectedCategory = category),
            child: Container(
              margin: const EdgeInsets.only(right: 10),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                gradient: isSelected
                    ? const LinearGradient(
                        colors: [
                          UniSphereTheme.primaryColor,
                          UniSphereTheme.primaryDark,
                        ],
                      )
                    : null,
                color: isSelected
                    ? null
                    : (isDark
                        ? UniSphereTheme.cardColorDark
                        : UniSphereTheme.cardColorLight),
                borderRadius: BorderRadius.circular(22),
                border: isSelected
                    ? null
                    : Border.all(
                        color: isDark
                            ? Colors.white.withAlpha(20)
                            : Colors.black.withAlpha(10),
                      ),
              ),
              alignment: Alignment.center,
              child: Text(
                category,
                style: TextStyle(
                  color: isSelected
                      ? Colors.white
                      : (isDark ? Colors.white70 : Colors.black87),
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  fontSize: 14,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildServicesGrid(ThemeData theme, bool isDark) {
    final services = _getFilteredServices();

    return Padding(
      padding: const EdgeInsets.all(16),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 0.9,
        ),
        itemCount: services.length,
        itemBuilder: (context, index) {
          final service = services[index];
          return _buildServiceCard(theme, isDark, service);
        },
      ),
    );
  }

  Widget _buildServiceCard(
    ThemeData theme,
    bool isDark,
    _ServiceData service,
  ) {
    return GestureDetector(
      onTap: () => _showServiceDetails(context, service),
      child: Container(
        decoration: BoxDecoration(
          color: isDark
              ? UniSphereTheme.cardColorDark
              : UniSphereTheme.cardColorLight,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: isDark
                  ? Colors.black.withAlpha(30)
                  : service.colors[0].withAlpha(20),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon container
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: service.colors,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: service.colors[0].withAlpha(40),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(
                service.icon,
                color: Colors.white,
                size: 28,
              ),
            ),
            const SizedBox(height: 12),
            Flexible(
              child: Text(
                service.name,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              service.subtitle,
              style: theme.textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  void _showServiceDetails(BuildContext context, _ServiceData service) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: BoxDecoration(
          color: isDark
              ? UniSphereTheme.surfaceDark
              : UniSphereTheme.surfaceLight,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            // Handle
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(top: 12),
              decoration: BoxDecoration(
                color: isDark ? Colors.white30 : Colors.black26,
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: service.colors,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                children: [
                  Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(30),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Icon(
                      service.icon,
                      color: Colors.white,
                      size: 36,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    service.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    service.subtitle,
                    style: TextStyle(
                      color: Colors.white.withAlpha(200),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),

            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDetailRow(
                      theme,
                      Icons.location_on_outlined,
                      'Location',
                      service.location,
                    ),
                    const SizedBox(height: 16),
                    _buildDetailRow(
                      theme,
                      Icons.access_time_rounded,
                      'Hours',
                      service.hours,
                    ),
                    const SizedBox(height: 16),
                    _buildDetailRow(
                      theme,
                      Icons.phone_outlined,
                      'Phone',
                      service.phone,
                    ),
                    const SizedBox(height: 24),

                    Text(
                      'About',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      service.description,
                      style: theme.textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 24),

                    // Action buttons
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              // Call action
                            },
                            icon: const Icon(Icons.call_rounded),
                            label: const Text('Call'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {
                              // Map action
                            },
                            icon: const Icon(Icons.map_rounded),
                            label: const Text('Directions'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(
    ThemeData theme,
    IconData icon,
    String label,
    String value,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 20,
          color: UniSphereTheme.primaryColor,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: theme.textTheme.labelSmall,
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildContactSection(ThemeData theme, bool isDark) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.contact_phone_rounded,
                size: 20,
                color: UniSphereTheme.primaryColor,
              ),
              const SizedBox(width: 8),
              Text(
                'Important Contacts',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildContactCard(
            theme,
            isDark,
            icon: Icons.local_police_rounded,
            name: 'Campus Security',
            phone: '1800-CAMPUS',
            isEmergency: true,
          ),
          _buildContactCard(
            theme,
            isDark,
            icon: Icons.medical_services_rounded,
            name: 'Health Center',
            phone: '(555) 123-4567',
            isEmergency: true,
          ),
          _buildContactCard(
            theme,
            isDark,
            icon: Icons.support_agent_rounded,
            name: 'Student Support',
            phone: '(555) 987-6543',
            isEmergency: false,
          ),
          _buildContactCard(
            theme,
            isDark,
            icon: Icons.computer_rounded,
            name: 'IT Help Desk',
            phone: '(555) 456-7890',
            isEmergency: false,
          ),
        ],
      ),
    );
  }

  Widget _buildContactCard(
    ThemeData theme,
    bool isDark, {
    required IconData icon,
    required String name,
    required String phone,
    required bool isEmergency,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark
            ? UniSphereTheme.cardColorDark
            : UniSphereTheme.cardColorLight,
        borderRadius: BorderRadius.circular(16),
        border: isEmergency
            ? Border.all(
                color: UniSphereTheme.error.withAlpha(50),
                width: 1,
              )
            : null,
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: isEmergency
                  ? UniSphereTheme.error.withAlpha(20)
                  : UniSphereTheme.primaryColor.withAlpha(20),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color:
                  isEmergency ? UniSphereTheme.error : UniSphereTheme.primaryColor,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      name,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (isEmergency)
                      Container(
                        margin: const EdgeInsets.only(left: 8),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: UniSphereTheme.error,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          '24/7',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  phone,
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              // Call action
            },
            icon: Icon(
              Icons.call_rounded,
              color:
                  isEmergency ? UniSphereTheme.error : UniSphereTheme.primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  List<_ServiceData> _getFilteredServices() {
    final allServices = [
      _ServiceData(
        name: 'Library',
        subtitle: 'Books & Study',
        category: 'Academic',
        icon: Icons.local_library_rounded,
        colors: [const Color(0xFF6C63FF), const Color(0xFF4F46E5)],
        location: 'Central Campus, Building A',
        hours: 'Mon-Fri: 7AM-12AM\nWeekends: 9AM-10PM',
        phone: '(555) 123-4567',
        description:
            'The main university library offers over 2 million books, digital resources, study rooms, and computer labs. Reserve study rooms online or use the self-checkout system.',
      ),
      _ServiceData(
        name: 'Cafeteria',
        subtitle: 'Food & Dining',
        category: 'Dining',
        icon: Icons.restaurant_rounded,
        colors: [const Color(0xFFF472B6), const Color(0xFFDB2777)],
        location: 'Student Center, Ground Floor',
        hours: 'Mon-Fri: 7AM-9PM\nWeekends: 8AM-8PM',
        phone: '(555) 234-5678',
        description:
            'Multiple dining options including vegetarian, vegan, and halal choices. Use your meal plan or pay with campus card.',
      ),
      _ServiceData(
        name: 'Health Center',
        subtitle: 'Medical Services',
        category: 'Health',
        icon: Icons.local_hospital_rounded,
        colors: [const Color(0xFFFF6B6B), const Color(0xFFEF4444)],
        location: 'Health Sciences Building',
        hours: 'Mon-Fri: 8AM-6PM\nEmergency: 24/7',
        phone: '(555) 345-6789',
        description:
            'Full medical services including general checkups, vaccinations, mental health counseling, and emergency care. Free for students with valid ID.',
      ),
      _ServiceData(
        name: 'Shuttle Bus',
        subtitle: 'Campus Transport',
        category: 'Transport',
        icon: Icons.directions_bus_rounded,
        colors: [const Color(0xFF34D399), const Color(0xFF059669)],
        location: 'Various Stops',
        hours: 'Mon-Fri: 6AM-11PM\nWeekends: 8AM-10PM',
        phone: '(555) 456-7890',
        description:
            'Free shuttle service connecting all campus buildings, parking lots, and nearby transit stations. Track buses in real-time using the UniSphere app.',
      ),
      _ServiceData(
        name: 'Gym & Fitness',
        subtitle: 'Sports Facility',
        category: 'Recreation',
        icon: Icons.fitness_center_rounded,
        colors: [const Color(0xFFFBBF24), const Color(0xFFD97706)],
        location: 'Recreation Center',
        hours: 'Mon-Fri: 5AM-11PM\nWeekends: 7AM-9PM',
        phone: '(555) 567-8901',
        description:
            'State-of-the-art fitness equipment, swimming pool, basketball courts, and group fitness classes. Free for students with valid ID.',
      ),
      _ServiceData(
        name: 'Bookstore',
        subtitle: 'Textbooks & Supplies',
        category: 'Academic',
        icon: Icons.store_rounded,
        colors: [const Color(0xFF06B6D4), const Color(0xFF0891B2)],
        location: 'Student Center, Level 1',
        hours: 'Mon-Fri: 8AM-7PM\nSat: 10AM-4PM',
        phone: '(555) 678-9012',
        description:
            'Official university textbooks, stationery, merchandise, and electronics. Students get 10% discount on most items.',
      ),
      _ServiceData(
        name: 'Career Center',
        subtitle: 'Jobs & Internships',
        category: 'Academic',
        icon: Icons.work_rounded,
        colors: [const Color(0xFFA78BFA), const Color(0xFF7C3AED)],
        location: 'Administration Building, 3rd Floor',
        hours: 'Mon-Fri: 9AM-5PM',
        phone: '(555) 789-0123',
        description:
            'Resume reviews, mock interviews, job fairs, and internship placements. Schedule appointments online through the student portal.',
      ),
      _ServiceData(
        name: 'Parking',
        subtitle: 'Car & Bike',
        category: 'Transport',
        icon: Icons.local_parking_rounded,
        colors: [const Color(0xFF94A3B8), const Color(0xFF64748B)],
        location: 'Multiple Locations',
        hours: '24/7 Access',
        phone: '(555) 890-1234',
        description:
            'Parking permits available for students. Multiple lots across campus with real-time availability displayed in the app.',
      ),
    ];

    if (_selectedCategory == 'All') {
      return allServices;
    }
    return allServices
        .where((s) => s.category == _selectedCategory)
        .toList();
  }
}

class _ServiceData {
  final String name;
  final String subtitle;
  final String category;
  final IconData icon;
  final List<Color> colors;
  final String location;
  final String hours;
  final String phone;
  final String description;

  _ServiceData({
    required this.name,
    required this.subtitle,
    required this.category,
    required this.icon,
    required this.colors,
    required this.location,
    required this.hours,
    required this.phone,
    required this.description,
  });
}
