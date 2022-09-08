
import 'package:ecommerce_admin_project/pages/products_page.dart';
import 'package:ecommerce_admin_project/pages/report_page.dart';
import 'package:ecommerce_admin_project/pages/setting_page.dart';
import 'package:ecommerce_admin_project/pages/user_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/dashboard_item_model.dart';
import '../providers/product_provider.dart';
import '../widgets/dashboard_item_view.dart';
import '../widgets/main_drawer.dart';
import 'category_page.dart';
import 'order_page.dart';

class DashboardPage extends StatelessWidget {
  static const routeName = "dash-board-page";
  const DashboardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Provider.of<ProductProvider>(context,listen: false).getAllCategories();
    Provider.of<ProductProvider>(context,listen: false).getAllProducts();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard"),
     
      ),
      drawer: const MainDrawer(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, crossAxisSpacing: 5, mainAxisSpacing: 5),
            itemCount: dashboardItems.length,
            itemBuilder: (context, index) => DashBoardItemView(
                dashboardIteam: dashboardItems[index], onPressed: (value) {

                String route =   navigator(value);
                Navigator.pushNamed(context, route);



            })),
      ),

    );
    
  }

  String navigator(String value) {
    String route ="";
    switch(value){
      case DashboardItemModel.user:
        route = UserPage.routeName;
        break;
      case DashboardItemModel.settings:
        route = SettingPage.routeName;
        break;
      case DashboardItemModel.category:
        route = CategoryPage.routeName;
        break;
      case DashboardItemModel.order:
        route = OrderPage.routeName;
        break;
      case DashboardItemModel.report:
        route = ReportPage.routeName;
        break;
      case DashboardItemModel.product:
        route = ProductPage.routeName;
        break;

    }
    return route;


  }
}
