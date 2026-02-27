import 'package:flutter/material.dart';
import '../screens/dashboard_screen.dart';

/// A reusable, polished announcement tile with icon badge,
/// title, metadata, and description preview.
///
/// Used by both the Dashboard (preview) and the full Announcements screen.
class AnnouncementTile extends StatelessWidget {
  final AnnouncementData announcement;
  final bool showFullDescription;

  const AnnouncementTile({
    super.key,
    required this.announcement,
    this.showFullDescription = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Icon badge ──
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    primary.withAlpha(30),
                    primary.withAlpha(15),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(13),
                border: Border.all(color: primary.withAlpha(30)),
              ),
              child: Icon(
                Icons.campaign_rounded,
                color: primary,
                size: 22,
              ),
            ),
            const SizedBox(width: 14),

            // ── Content ──
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    announcement.title,
                    style: theme.textTheme.titleMedium,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.person_outline_rounded,
                        size: 13,
                        color: theme.textTheme.labelSmall?.color,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        announcement.postedBy,
                        style: theme.textTheme.labelSmall,
                      ),
                      const SizedBox(width: 10),
                      Icon(
                        Icons.schedule_rounded,
                        size: 13,
                        color: theme.textTheme.labelSmall?.color,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        announcement.date,
                        style: theme.textTheme.labelSmall,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    announcement.description,
                    maxLines: showFullDescription ? null : 2,
                    overflow: showFullDescription
                        ? TextOverflow.visible
                        : TextOverflow.ellipsis,
                    style: theme.textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
