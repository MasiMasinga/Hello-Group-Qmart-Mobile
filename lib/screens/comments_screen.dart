import 'package:flutter/material.dart';
import 'package:hello_group_qmart_mobile/services/api_service.dart';
import 'reply_to_comment_screen.dart';

class CommentsScreen extends StatefulWidget {
  const CommentsScreen({super.key});

  @override
  _CommentsScreenState createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  final ApiService _apiService = ApiService();
  late Future<List<dynamic>> _commentsFuture;

  @override
  void initState() {
    super.initState();
    _commentsFuture = _apiService.fetchComments();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Comments')),
      body: FutureBuilder<List<dynamic>>(
        future: _commentsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Failed to load comments'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No comments'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final comment = snapshot.data![index];
                return ListTile(
                  title: Text(comment['name']),
                  subtitle: Text(comment['comment']),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ReplyToCommentScreen(commentId: comment['id']),
                      ),
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
