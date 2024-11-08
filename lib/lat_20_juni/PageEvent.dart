import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_4/lat_20_juni/PageDetailEvent.dart';
import 'EventService.dart';
import 'ModelEvent.dart';

class PageListEvent extends StatefulWidget {
  @override
  _PageListEventState createState() => _PageListEventState();
}

class _PageListEventState extends State<PageListEvent> {
  late Future<List<Event>> futureEvents;
  final UserService userService = UserService();

  @override
  void initState() {
    super.initState();
    futureEvents = userService.fetchEvents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Laga Sepak Bola Eropa 2024-2025', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: FutureBuilder<List<Event>>(
        future: futureEvents,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            print('Snapshot error: ${snapshot.error}');
            return Center(child: Text('Failed to load events'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No events found'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final event = snapshot.data![index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  child: ListTile(
                    leading: event.strPoster.isNotEmpty
                        ? Image.network(event.strPoster, width: 50, height: 50, fit: BoxFit.cover)
                        : Container(width: 50, height: 50, color: Colors.grey),
                    title: Text(event.strEvent),
                    subtitle: Text(event.dateEvent),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EventDetailPage(event: event),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}