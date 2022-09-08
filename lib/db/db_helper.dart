import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/category_model.dart';
import '../models/order_constants_model.dart';
import '../models/product_model.dart';
import '../models/purchase_model.dart';

class DBHelper {
  static String adminCollection = "Admins";
  static String collectionCategory = "Category";
  static String collectionProducts = "Products";
  static String collectionPurchase = "Purchase";
  static String collectionUsers = "User";
  static String collectionOrder = "Order";
  static String collectionOrderDetails = "OrderDetails";
  static String collectionOrderSettings = "Setting";
  static String documentOrderConstant = "OrderConstant";
  static final FirebaseFirestore _db = FirebaseFirestore.instance;
  static Future<bool> isAdmin(String uid) async {
    final snapshot = await _db.collection(adminCollection).doc(uid).get();
    return snapshot.exists;
  }
  static Future<void> addNewCategory(CategoryModel categoryModel) {
    final doc = _db.collection(collectionCategory).doc();
    categoryModel.catId = doc.id;
    return doc.set(categoryModel.toMap());
  }
  static Future<void> addOrderConstants(OrderConstantsModel orderConstantsModel)=>
    _db.collection(collectionOrderSettings).doc(documentOrderConstant).set(orderConstantsModel.toMap());
  static Future<void> rePurchase(PurchaseModel purchaseModel, CategoryModel catModel){
    final wb = _db.batch();
    final doc = _db.collection(collectionPurchase).doc();
    purchaseModel.id = doc.id;
    wb.set(doc, purchaseModel.toMap());
    final catDoc = _db.collection(collectionCategory).doc(catModel.catId);
    wb.update(catDoc, {categoryProductCount : catModel.categoryCount});
    return wb.commit();
  }
  static Future<void> addProduct(
    ProductModel productModel,
    PurchaseModel purchaseModel,
    String catId,
    num count,
  ) {
    final wb = _db.batch();
    final proDoc = _db.collection(collectionProducts).doc();
    final purDoc = _db.collection(collectionPurchase).doc();
    final catDoc = _db.collection(collectionCategory).doc(catId);
    productModel.id = proDoc.id;
    purchaseModel.id = purDoc.id;
    purchaseModel.productID = proDoc.id;

    wb.set(proDoc, productModel.toMap());
    wb.set(purDoc, purchaseModel.toMap());
    wb.update(catDoc, {categoryProductCount: count});

    return wb.commit();
  }
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllCategories() =>
      _db.collection(collectionCategory).snapshots();

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllProducts() =>
      _db.collection(collectionProducts).snapshots();

  static Future<DocumentSnapshot<Map<String, dynamic>>> getAllOrderConstants() =>
      _db.collection(collectionOrderSettings).doc(documentOrderConstant).get();

  static Stream<DocumentSnapshot<Map<String, dynamic>>> getProductById(
          String id) =>
      _db.collection(collectionProducts).doc(id).snapshots();

  static Stream<QuerySnapshot<Map<String, dynamic>>> getPurchaseByProductId(
          String id) =>
      _db
          .collection(collectionPurchase)
          .where(purchaseProductId, isEqualTo: id)
          .snapshots();
  static Future<void> updateProduct(String id, Map<String, dynamic> map) {
    return _db.collection(collectionProducts).doc(id).update(map);
  }
}
