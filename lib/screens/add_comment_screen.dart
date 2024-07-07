import 'package:flutter/material.dart';
import 'package:hello_group_qmart_mobile/services/api_service.dart';

class AddCommentScreen extends StatefulWidget {
  const AddCommentScreen({super.key});

  @override
  _AddCommentScreenState createState() => _AddCommentScreenState();
}

class _AddCommentScreenState extends State<AddCommentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _commentController = TextEditingController();

  final ApiService _apiService = ApiService();

  void _submitComment() {
    if (_formKey.currentState?.validate() ?? false) {
      _apiService
          .addComment(_nameController.text, _commentController.text)
          .then((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Comment added'),
          ),
        );
        Navigator.pop(context);
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to add comment'),
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Comment'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Name is required' : null,
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _commentController,
                decoration: const InputDecoration(labelText: 'Comment'),
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Comment is required' : null,
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _submitComment,
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
