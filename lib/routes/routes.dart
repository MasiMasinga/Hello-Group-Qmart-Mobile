import 'package:flutter/material.dart';

// Screens
import 'package:hello_group_qmart_mobile/screens/add_comment_screen.dart';
import 'package:hello_group_qmart_mobile/screens/comments_screen.dart';
import 'package:hello_group_qmart_mobile/screens/reply_to_comment_screen.dart';

class AppRoutes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) =>  CommentsScreen());
      case '/add-comment':
        return MaterialPageRoute(builder: (_) => const AddCommentScreen());
      case '/reply-to-comment':
        return MaterialPageRoute(
          builder: (_) => ReplyToCommentScreen(commentId: settings.arguments as int),
        );
      default:
        throw ('This route name does not exit');
    }
  }
}