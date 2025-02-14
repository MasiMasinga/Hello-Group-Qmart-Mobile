import 'package:flutter/material.dart';

// Widgets
import 'package:hello_group_qmart_mobile/common/widgets/custom_text.dart';
import 'package:hello_group_qmart_mobile/services/api_service.dart';

// Screens
import 'add_comment_screen.dart';
import 'reply_to_comment_screen.dart';

class CommentsScreen extends StatefulWidget {
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

  Future<void> _refreshComments() async {
    setState(() {
      _commentsFuture = _apiService.fetchComments();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const CustomText(
          text: 'Comments',
          fontSize: 20.0,
        ),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _commentsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: CustomText(
                text: 'Failed to load comments',
                textAlign: TextAlign.center,
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: CustomText(
                text: 'No comments',
                textAlign: TextAlign.center,
              ),
            );
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final comment = snapshot.data![index];
                final name = comment['name'] ?? 'Unknown';
                final commentText = comment['comment'] ?? 'No comment';
                return ListTile(
                  title: Text(
                    name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: CustomText(text: commentText),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ReplyToCommentScreen(
                          commentId: comment['id'],
                        ),
                      ),
                    );
                  },
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddCommentScreen(),
            ),
          );
          await _refreshComments();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
