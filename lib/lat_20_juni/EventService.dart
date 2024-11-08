// user_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;

import 'ModelEvent.dart';

class UserService {
  Future<List<Event>> fetchEvents() async {
    try {
      final response = await http.get(
        Uri.parse('https://www.thesportsdb.com/api/v1/json/3/searchevents.php?e=Arsenal_vs_Chelsea'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> json = jsonDecode(response.body);
        if (json['event'] != null) {
          final List events = json['event'];
          return events.map((event) => Event.fromJson(event)).toList();
        } else {
          print('No events found in response');
          throw Exception('No events found');
        }
      } else {
        print('Failed to load events: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception('Failed to load events');
      }
    } catch (e) {
      print('Error fetching events: $e');
      throw Exception('Failed to load events');
    }
  }
}