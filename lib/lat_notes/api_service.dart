import 'dart:convert';
import 'package:http/http.dart' as http;

import 'ModelNotes.dart';

class ApiService {
  static const String baseUrl = 'http://your_api_url/notes_api';

  Future<List<Datum>> fetchNotes() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      final modelNotes = modelNotesFromJson(response.body);
      if (modelNotes.isSuccess) {
        return modelNotes.data;
      } else {
        throw Exception('Failed to load notes: ${modelNotes.message}');
      }
    } else {
      throw Exception('Failed to load notes');
    }
  }

  Future<Datum> createNote(String judul, String isi) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'judul': judul, 'isi': isi}),
    );
    if (response.statusCode == 200) {
      final modelNotes = modelNotesFromJson(response.body);
      if (modelNotes.isSuccess) {
        return modelNotes.data.first;
      } else {
        throw Exception('Failed to create note: ${modelNotes.message}');
      }
    } else {
      throw Exception('Failed to create note');
    }
  }

  Future<void> updateNote(String id, String judul, String isi) async {
    final response = await http.put(
      Uri.parse('$baseUrl/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'judul': judul, 'isi': isi}),
    );
    if (response.statusCode == 200) {
      final modelNotes = modelNotesFromJson(response.body);
      if (!modelNotes.isSuccess) {
        throw Exception('Failed to update note: ${modelNotes.message}');
      }
    } else {
      throw Exception('Failed to update note');
    }
  }

  Future<void> deleteNote(String id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));
    if (response.statusCode == 200) {
      final modelNotes = modelNotesFromJson(response.body);
      if (!modelNotes.isSuccess) {
        throw Exception('Failed to delete note: ${modelNotes.message}');
      }
    } else {
      throw Exception('Failed to delete note');
    }
  }
}
