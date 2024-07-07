import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = 'http://13.244.78.89:3000/api';

  Future<List<dynamic>> fetchComments() async {
    final response = await http.get(Uri.parse('$baseUrl/'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load comments');
    }
  }

  Future<List<dynamic>> fetchReplies(int commentId) async {
    String url = 'http://13.244.78.89:3000/api/$commentId';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        dynamic responseData = jsonDecode(response.body);
        if (responseData is List<dynamic>) {
          return responseData;
        } else if (responseData is Map<String, dynamic>) {
          return [responseData];
        } else {
          throw Exception('Unexpected response type');
        }
      } else {
        throw Exception('Failed to fetch replies');
      }
    } catch (e) {
      throw Exception('Failed to fetch replies');
    }
  }

  Future<void> addComment(String name, String comment) async {
    final response = await http.post(
      Uri.parse('$baseUrl/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'name': name, 'comment': comment}),
    );
    if (response.statusCode != 201) {
      throw Exception('Failed to add comment');
    }
  }

  Future<void> addReply(int commentId, String fanName, String fanReply) async {
    final response = await http.post(
      Uri.parse('$baseUrl/$commentId/replies'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'fan_name': fanName, 'fan_reply': fanReply}),
    );
    if (response.statusCode != 201) {
      throw Exception('Failed to add reply');
    }
  }
  
}
