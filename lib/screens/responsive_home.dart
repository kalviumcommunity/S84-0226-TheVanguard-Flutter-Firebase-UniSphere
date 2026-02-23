import 'package:flutter/material.dart';

class ResponsiveHome extends StatefulWidget {
  const ResponsiveHome({super.key});

  @override
  State<ResponsiveHome> createState() => _ResponsiveHomeState();
}

class _ResponsiveHomeState extends State<ResponsiveHome> {
  final List<_FeatureItem> _features = const [
    _FeatureItem(icon: Icons.dashboard, title: 'Dashboard', description: 'View your activity overview'),
    _FeatureItem(icon: Icons.event, title: 'Events', description: 'Browse and register for events'),
    _FeatureItem(icon: Icons.group, title: 'Communities', description: 'Connect with student clubs'),
    _FeatureItem(icon: Icons.notifications_active, title: 'Announcements', description: 'Stay updated in real time'),
  ];

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    bool isTablet = screenWidth > 600;

    return Scaffold(
      appBar: buildHeader(),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: buildMainContent(
                screenWidth: screenWidth,
                screenHeight: screenHeight,
                isTablet: isTablet,
              ),
            ),
            buildFooter(isTablet: isTablet, screenWidth: screenWidth),
          ],
        ),
      ),
    );
  }

  AppBar buildHeader() {
    return AppBar(
      title: const Text('Responsive Home'),
      centerTitle: true,
    );
  }

  Widget buildMainContent({
    required double screenWidth,
    required double screenHeight,
    required bool isTablet,
  }) {
    double padding = isTablet ? 24.0 : 12.0;
    double titleFontSize = isTablet ? 22.0 : 16.0;

    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          padding: EdgeInsets.all(padding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(
                  'Explore Features',
                  style: TextStyle(
                    fontSize: titleFontSize + 6,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: padding),
              Wrap(
                spacing: padding,
                runSpacing: padding,
                children: List.generate(_features.length, (index) {
                  double cardWidth = isTablet
                      ? (constraints.maxWidth - padding * 3) / 2
                      : constraints.maxWidth - padding * 2;

                  return SizedBox(
                    width: cardWidth,
                    child: _buildFeatureCard(
                      feature: _features[index],
                      isTablet: isTablet,
                      titleFontSize: titleFontSize,
                    ),
                  );
                }),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFeatureCard({
    required _FeatureItem feature,
    required bool isTablet,
    required double titleFontSize,
  }) {
    return AspectRatio(
      aspectRatio: isTablet ? 2.5 : 3.0,
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: EdgeInsets.all(isTablet ? 16.0 : 12.0),
          child: Row(
            children: [
              Flexible(
                flex: 1,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Icon(
                    feature.icon,
                    size: 40,
                    color: Colors.blueAccent,
                  ),
                ),
              ),
              SizedBox(width: isTablet ? 16.0 : 10.0),
              Expanded(
                flex: 3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        feature.title,
                        style: TextStyle(
                          fontSize: titleFontSize,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Flexible(
                      child: Text(
                        feature.description,
                        style: TextStyle(
                          fontSize: titleFontSize - 2,
                          color: Colors.grey[600],
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildFooter({required bool isTablet, required double screenWidth}) {
    double horizontalPadding = isTablet ? 32.0 : 16.0;
    double fontSize = isTablet ? 20.0 : 16.0;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        horizontalPadding,
        12,
        horizontalPadding,
        MediaQuery.of(context).padding.bottom + 16,
      ),
      child: SizedBox(
        width: double.infinity,
        height: isTablet ? 56 : 48,
        child: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              'Get Started',
              style: TextStyle(fontSize: fontSize),
            ),
          ),
        ),
      ),
    );
  }
}

class _FeatureItem {
  final IconData icon;
  final String title;
  final String description;

  const _FeatureItem({
    required this.icon,
    required this.title,
    required this.description,
  });
}
