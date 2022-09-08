import 'package:flutter/material.dart';

import '../models/dashboard_item_model.dart';

class DashBoardItemView extends StatelessWidget {
  final DashboardItemModel dashboardIteam;
  final Function(String) onPressed;
  const DashBoardItemView({
    Key? key,
    required this.dashboardIteam,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onPressed(dashboardIteam.title);
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15)
        ),
          elevation: 5,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                dashboardIteam.icon,
                size: 40,
                color: Theme.of(context).primaryColor,
              ),
              const SizedBox(height: 5,),
              Text(dashboardIteam.title, style:const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),)
            ],
          )),
    );
  }
}
