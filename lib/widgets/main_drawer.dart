// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

import '../auth/auth_service.dart';
import '../pages/launcher_page.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return   Drawer(
      child:  Column(
        children: [
          UserAccountsDrawerHeader(
            currentAccountPictureSize: Size.square(70),
            currentAccountPicture: Image.asset("assets/images/person.png"),
            accountName:  Text("Ebrahim Hossen"),
            accountEmail:  Text("ebrahim.cse.bu@gmail.com")),

            Expanded(child: ListView(
              children: [
                ListTile(
                  onTap: (){

                    AuthService.logout();
                    
                    Navigator.pushReplacementNamed(context, LauncherPage.routeName);
                  },
                  leading: Icon(Icons.logout),
                  title: Text("LogOut"),
                )
              ],
            ))
        ],
      ) 
    );
    
  }
}