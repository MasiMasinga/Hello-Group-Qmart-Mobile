import 'package:flutter/material.dart';

// Widgets
import 'package:hello_group_qmart_mobile/common/widgets/custom_button.dart';
import 'package:hello_group_qmart_mobile/common/widgets/custom_text.dart';
import 'package:hello_group_qmart_mobile/common/widgets/custom_textfield.dart';
import 'package:hello_group_qmart_mobile/common/widgets/snack_bar.dart';

// Services
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
        CustomSnackBar.show(
          context,
          'Comment added',
          backgroundColor: Colors.green,
        );
        Navigator.pop(context);
      }).catchError((error) {
        CustomSnackBar.show(
          context,
          'Failed to add comment',
          backgroundColor: Colors.red,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const CustomText(
          text: 'Add Comment',
          fontSize: 20.0,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              CustomTextField(
                hintText: 'Name',
                controller: _nameController,
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Name is required' : null,
              ),
              const SizedBox(height: 16.0),
              CustomTextField(
                hintText: 'Comment',
                controller: _commentController,
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Comment is required' : null,
              ),
              const SizedBox(height: 16.0),
              CustomButton(
                onPressed: _submitComment,
                text: 'Submit',
              )
            ],
          ),
        ),
      ),
    );
  }
}
