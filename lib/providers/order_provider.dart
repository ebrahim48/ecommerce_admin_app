
import 'package:flutter/cupertino.dart';

import '../db/db_helper.dart';
import '../models/order_constants_model.dart';

class OrderProvider extends ChangeNotifier {
  OrderConstantsModel orderConstantsModel = OrderConstantsModel();

  Future<void> addOrderConstants(OrderConstantsModel orderConstantsModel) =>
      DBHelper.addOrderConstants(orderConstantsModel);

  Future<void> getOrderConstants() async{
   final snapshot = await DBHelper.getAllOrderConstants();
   orderConstantsModel = OrderConstantsModel.fromMap(snapshot.data()!);
   notifyListeners();
  }
}
