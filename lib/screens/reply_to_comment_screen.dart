import 'package:flutter/material.dart';

// Widgets
import 'package:hello_group_qmart_mobile/common/widgets/custom_button.dart';
import 'package:hello_group_qmart_mobile/common/widgets/custom_text.dart';
import 'package:hello_group_qmart_mobile/common/widgets/custom_textfield.dart';
import 'package:hello_group_qmart_mobile/common/widgets/snack_bar.dart';

// Services
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
        CustomSnackBar.show(
          context,
          'Reply added',
          backgroundColor: Colors.green,
        );
        _fanNameController.clear();
        _replyController.clear();
        setState(() {
          _repliesFuture = _apiService.fetchReplies(widget.commentId);
        });
      }).catchError(
        (error) {
          CustomSnackBar.show(
            context,
            'Failed to add reply',
            backgroundColor: Colors.red,
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const CustomText(
          text: 'Reply to Comment',
          fontSize: 20.0,
        ),
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
                    child: CustomText(
                      text: 'Failed to load comment',
                      textAlign: TextAlign.center,
                    ),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: CustomText(
                      text: 'No comment found',
                      textAlign: TextAlign.center,
                    ),
                  );
                } else {
                  final comment = snapshot.data![0];
                  return ListTile(
                    title: CustomText(
                      text: comment['comment'] ?? 'Unknown Comment',
                      textAlign: TextAlign.center,
                    ),
                    subtitle: CustomText(
                      text: 'By: ${comment['name']}',
                      textAlign: TextAlign.center,
                      fontWeight: FontWeight.bold,
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
                    CustomTextField(
                      hintText: 'Your Name',
                      controller: _fanNameController,
                      validator: (value) =>
                          value?.isEmpty ?? true ? 'Name is required' : null,
                    ),
                    const SizedBox(height: 8.0),
                    CustomTextField(
                      hintText: 'Reply',
                      controller: _replyController,
                      validator: (value) =>
                          value?.isEmpty ?? true ? 'Reply is required' : null,
                    ),
                    const SizedBox(height: 8.0),
                    CustomButton(
                      onPressed: _submitReply,
                      text: 'Submit',
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
                      child: CustomText(
                        text: 'Failed to load replies',
                        textAlign: TextAlign.center,
                      ),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                      child: CustomText(
                        text: 'No replies',
                        textAlign: TextAlign.center,
                      ),
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
                                children: replies.map<Widget>(
                                  (reply) {
                                    return ListTile(
                                      title: CustomText(
                                        text: reply['fan_reply'] ??
                                            'Unknown Reply',
                                      ),
                                      subtitle: CustomText(
                                        text: 'By: ${reply['fan_name']}',
                                        fontWeight: FontWeight.bold,
                                      ),
                                    );
                                  },
                                ).toList(),
                              ),
                            if (replies == null || replies.isEmpty)
                              const Center(
                                child: CustomText(
                                  text: 'Failed to load replies',
                                  textAlign: TextAlign.center,
                                ),
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
