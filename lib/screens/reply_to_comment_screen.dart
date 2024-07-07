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
  final _fanNameController = TextEditingController();
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
      _apiService
          .addReply(
              widget.commentId, _fanNameController.text, _replyController.text)
          .then((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Reply added'),
          ),
        );
        _fanNameController.clear();
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
            FutureBuilder<List<dynamic>>(
              future: _repliesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return const Center(
                    child: Text('Failed to load comment'),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No comment found'));
                } else {
                  final comment = snapshot.data![0];
                  return ListTile(
                    title: Text(
                      comment['comment'] ?? 'Unknown Comment',
                      textAlign: TextAlign.center,
                    ),
                    subtitle: Text(
                      'By: ${comment['name']}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                }
              },
            ),
            const SizedBox(height: 16.0),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _fanNameController,
                      decoration: const InputDecoration(labelText: 'Your Name'),
                      validator: (value) =>
                          value?.isEmpty ?? true ? 'Name is required' : null,
                    ),
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
                        final comment = snapshot.data![index];
                        final replies = comment['replies'] as List<dynamic>?;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (replies != null && replies.isNotEmpty)
                              Column(
                                children: replies.map<Widget>((reply) {
                                  return ListTile(
                                    title: Text(
                                        reply['fan_reply'] ?? 'Unknown Reply'),
                                    subtitle: Text(
                                      'By: ${reply['fan_name']}',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  );
                                }).toList(),
                              ),
                            if (replies == null || replies.isEmpty)
                              const Center(
                                child: Text('No replies'),
                              ),
                          ],
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
