import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl =
      'https://qmobile.qmart.co.za/chiefs-assessment-api/api';

  Future<List<dynamic>> fetchComments() async {
    final response = await http.get(Uri.parse('$baseUrl/comments'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load comments');
    }
  }

  Future<List<dynamic>> fetchReplies(int commentId) async {
    final response =
        await http.get(Uri.parse('$baseUrl/comments/$commentId/replies'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load replies');
    }
  }

  Future<void> addComment(String name, String comment) async {
    final response = await http.post(
      Uri.parse('$baseUrl/comments'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'name': name, 'comment': comment}),
    );
    if (response.statusCode != 201) {
      throw Exception('Failed to add comment');
    }
  }

  Future<void> addReply(int commentId, String reply) async {
    final response = await http.post(
      Uri.parse('$baseUrl/comments/$commentId/replies'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'reply': reply}),
    );
    if (response.statusCode != 201) {
      throw Exception('Failed to add reply');
    }
  }
}
