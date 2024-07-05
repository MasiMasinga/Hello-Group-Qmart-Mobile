import 'package:flutter/material.dart';
import 'package:hello_group_qmart_mobile/services/api_service.dart';

class ReplyToCommentScreen extends StatefulWidget {
  final int commentId;

  const ReplyToCommentScreen({super.key, required this.commentId});

  @override
  _ReplyToCommentScreenState createState() => _ReplyToCommentScreenState();
}

class _ReplyToCommentScreenState extends State<ReplyToCommentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _replyController = TextEditingController();

  final ApiService _apiService = ApiService();
  
  late Future<List<dynamic>> _repliesFuture;

  @override
  void initState() {
    super.initState();
    _repliesFuture = _apiService.fetchReplies(widget.commentId);
  }

  void _submitReply() {
    if (_formKey.currentState?.validate() ?? false) {
      _apiService.addReply(widget.commentId, _replyController.text).then((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Reply added'),
          ),
        );
        _replyController.clear();
        setState(() {
          _repliesFuture = _apiService.fetchReplies(widget.commentId);
        });
      }).catchError(
        (error) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to add reply'),
            ),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reply to Comment'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _replyController,
                    decoration: const InputDecoration(labelText: 'Reply'),
                    validator: (value) =>
                        value?.isEmpty ?? true ? 'Reply is required' : null,
                  ),
                  const SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: _submitReply,
                    child: const Text('Submit'),
                  ),
                ],
              ),
            ),
            Expanded(
              child: FutureBuilder<List<dynamic>>(
                future: _repliesFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    return const Center(
                      child: Text('Failed to load replies'),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text('No replies'),
                    );
                  } else {
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        final reply = snapshot.data![index];
                        return ListTile(
                          title: Text(reply['reply']),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
