import 'package:flutter/material.dart';
import 'package:hello_group_qmart_mobile/screens/add_comment_screen.dart';
import 'package:hello_group_qmart_mobile/screens/comments_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const CommentsScreen(),
        '/add-comment': (context) => const AddCommentScreen(),
      },
    );
  }
}
