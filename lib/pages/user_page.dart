import 'package:flutter/material.dart';

class UserPage extends StatelessWidget {
  static const routeName ="user-page";
  const UserPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("User"),
      ),
    );
  }
}
