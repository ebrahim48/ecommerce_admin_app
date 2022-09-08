import 'package:flutter/material.dart';

class ReportPage extends StatelessWidget {
  static const routeName ="report-page";
  const ReportPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Report"),
      ),
    );
  }
}
