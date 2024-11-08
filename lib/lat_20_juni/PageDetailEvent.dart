// event_detail_page.dart

import 'package:flutter/material.dart';

import 'ModelEvent.dart';

class EventDetailPage extends StatelessWidget {
  final Event event;

  EventDetailPage({required this.event});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(event.strEvent),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            event.strPoster.isNotEmpty
                ? Image.network(
              event.strPoster,
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
            )
                : Container(
              width: double.infinity,
              height: 200,
              color: Colors.grey,
              child: Icon(Icons.image_not_supported, size: 50, color: Colors.white),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Icon(Icons.sports_soccer, size: 24, color: Colors.blue.shade900),
                SizedBox(width: 8),
                Text(
                  'League: ${event.strLeague}',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue.shade900),
                ),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.emoji_events, size: 24),
                SizedBox(width: 8),
                Text(
                  'Season: ${event.strSeason}',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.calendar_today, size: 24),
                SizedBox(width: 8),
                Text(
                  'Date: ${event.dateEvent}',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.access_time, size: 24),
                SizedBox(width: 8),
                Text(
                  'Time: ${event.strTime}',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}