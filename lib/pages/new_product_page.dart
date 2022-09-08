// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../models/date_model.dart';
import '../models/product_model.dart';
import '../models/purchase_model.dart';
import '../providers/product_provider.dart';
import '../utils/helper_function.dart';
import '../widgets/show_loading.dart';

class NewProductPage extends StatefulWidget {
  static const routeName = "new-product-page";
  const NewProductPage({Key? key}) : super(key: key);

  @override
  State<NewProductPage> createState() => _NewProductPageState();
}

class _NewProductPageState extends State<NewProductPage> {
  final formKey = GlobalKey<FormState>();
  final productNameController = TextEditingController();
  final productDescriptionController = TextEditingController();
  final productSalePriceController = TextEditingController();
  final productPurchasePriceController = TextEditingController();
  final productQuantityController = TextEditingController();

  @override
  void dispose() {
    productNameController.dispose();
    productDescriptionController.dispose();
    productSalePriceController.dispose();
    productPurchasePriceController.dispose();
    productQuantityController.dispose();

    super.dispose();
  }

  DateTime? _purchaseDate;

  String? _productCategory;
  bool _isUploadding=false;
  String? _imageUrl;

  ImageSource source = ImageSource.camera;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("New Product"),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Stack(
                  // alignment: Alignment.bottomRight,
                  children: [
                    Center(
                      child: _imageUrl == null
                          ? Image.asset(
                              "assets/images/photos.png",
                              height: 100,
                              width: 100,
                              alignment: Alignment.center,
                              fit: BoxFit.cover,
                            )
                          : Image.network(
                              _imageUrl!,
                              height: 100,
                              width: 100,
                              alignment: Alignment.center,
                              fit: BoxFit.cover,
                            ),
                    ),
                    Positioned(
                        bottom: -5,
                        right: MediaQuery.of(context).size.width / 2 - 80,
                        child: IconButton(
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      AlertDialog(
                                        elevation: 10,
                                        actions: [
                                          ListTile(
                                            onTap: () {
                                              source = ImageSource.camera;
                                              _getImage();
                                              Navigator.of(context).pop();
                                            },
                                            title: Icon(
                                              Icons.camera_alt_outlined,
                                              color: Colors.deepOrange,
                                            ),
                                            subtitle: Text(
                                              "Image from camera",
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                          Divider(),
                                          ListTile(
                                            onTap: () {
                                              source = ImageSource.gallery;
                                              _getImage();
                                              Navigator.of(context).pop();
                                            },
                                            title: Icon(
                                              Icons.photo_library_outlined,
                                              color: Colors.deepOrange,
                                            ),
                                            subtitle: Text(
                                              "Image from Gallery",
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ],
                                      ));
                            },
                            icon: Icon(
                              Icons.add_a_photo,
                              color: Colors.black87,
                              size: 35,
                            )))
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),

              // todo Product Name Textfield section
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: productNameController,
                  style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w500),
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color(0xffe6e6e6),
                      contentPadding: const EdgeInsets.only(left: 10),
                      focusColor: Colors.white,
                      prefixIcon: const Icon(
                        Icons.card_giftcard,
                      ),
                      hintText: "Enter the product name",
                      hintStyle: TextStyle(
                          color: Colors.grey, fontWeight: FontWeight.normal),
                      border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(20))),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'This field must not be empty';
                    } else {
                      return null;
                    }
                  },
                ),
              ),

              // todo Product Sale Price Textfield section

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: productSalePriceController,
                  style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w500),
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color(0xffe6e6e6),
                      contentPadding: const EdgeInsets.only(left: 10),
                      focusColor: Colors.white,
                      prefixIcon: const Icon(
                        Icons.monetization_on_outlined,
                      ),
                      hintText: "Enter the product sale price",
                      hintStyle: TextStyle(
                          color: Colors.grey, fontWeight: FontWeight.normal),
                      border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(20))),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'This field must not be empty';
                    } else {
                      return null;
                    }
                  },
                ),
              ),

              // todo Product Purchase Price Textfield section

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: productPurchasePriceController,
                  style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w500),
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color(0xffe6e6e6),
                      contentPadding: const EdgeInsets.only(left: 10),
                      focusColor: Colors.white,
                      prefixIcon: const Icon(
                        Icons.monetization_on,
                      ),
                      hintText: "Enter the product purchase price",
                      hintStyle: TextStyle(
                          color: Colors.grey, fontWeight: FontWeight.normal),
                      border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(20))),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'This field must not be empty';
                    } else {
                      return null;
                    }
                  },
                ),
              ),
              // todo Product Quantity Textfield section

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: productQuantityController,
                  style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w500),
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color(0xffe6e6e6),
                      contentPadding: const EdgeInsets.only(left: 10),
                      focusColor: Colors.white,
                      prefixIcon: const Icon(
                        Icons.clean_hands_outlined,
                      ),
                      hintText: "Enter the product quantity",
                      hintStyle: TextStyle(
                          color: Colors.grey, fontWeight: FontWeight.normal),
                      border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(20))),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'This field must not be empty';
                    } else {
                      return null;
                    }
                  },
                ),
              ),
              //todo Product Description Textfield section

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: productDescriptionController,
                  style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w500),
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color(0xffe6e6e6),
                      contentPadding: const EdgeInsets.only(left: 10),
                      focusColor: Colors.white,
                      prefixIcon: const Icon(
                        Icons.description,
                      ),
                      hintText: "Enter the product description",
                      hintStyle: TextStyle(
                          color: Colors.grey, fontWeight: FontWeight.normal),
                      border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(20))),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'This field must not be empty';
                    } else {
                      return null;
                    }
                  },
                ),
              ),

              //todo Purchase Date Section
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  tileColor: Color(0xffe6e6e6),
                  leading: Text(
                    "Purchase Date:",
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  title: Center(
                    child: Text(
                      _purchaseDate == null
                          ? "No date choisen!"
                          : getFormatedDateTime(_purchaseDate!, "dd/MM/yyyy"),
                      style: TextStyle(
                          color: _purchaseDate == null
                              ? Colors.grey
                              : Theme.of(context).primaryColor),
                    ),
                  ),
                  trailing: IconButton(
                      onPressed: _showPurchaseDatePicker,
                      icon: Icon(
                        Icons.add,
                        color: Colors.red,
                      )),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Consumer<ProductProvider>(
                  builder: (context, provider, _) => ListTile(
                    tileColor: Color(0xffe6e6e6),
                    leading: Text(
                      "Select category:",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 16),
                    ),
                    trailing: DropdownButton(
                      hint: Text(
                        "No category selected",
                        style: TextStyle(color: Colors.grey),
                      ),
                      underline: Container(),
                      borderRadius: BorderRadius.circular(20),
                      // validator: (value){
                      //     if(value == null || value.toString().isEmpty){
                      //       return "Please select a category!";
                      //     }
                      //     return null;
                      // },
                      dropdownColor: Colors.white,
                      value: _productCategory,
                      icon: Padding(
                        padding: const EdgeInsets.all(12),
                        child: const Icon(
                          Icons.keyboard_arrow_down,
                          color: Colors.red,
                        ),
                      ),
                      style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.w500),
                      items: provider.categoryList.map((items) {
                        return DropdownMenuItem(
                          value: items.catName,
                          child: Center(child: Text(items.catName.toString())),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          _productCategory = newValue.toString();
                        });
                      },
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),

         _isUploadding? ShowLoading():     ElevatedButton(
                  onPressed: _addProduct,
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)))),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Add Product",
                      style: TextStyle(fontSize: 16),
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }

  void _getImage() async {
    final pickedImage = await ImagePicker().pickImage(source: source);
    if (pickedImage != null) {
      setState((){

        _isUploadding = true;
      });
      try {
        final url =
            await context.read<ProductProvider>().updateImage(pickedImage);

        setState(() {
          _imageUrl = url;
          _isUploadding = false;
        });
      } catch (e) {}
    }
  }

  void _showPurchaseDatePicker() async {
    DateTime? selectedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2020),
        lastDate: DateTime.now());

    if (selectedDate != null) {
      setState(() {
        _purchaseDate = selectedDate;
      });
    }
  }

  void _addProduct() {
    if (formKey.currentState!.validate()) {
      final productModel = ProductModel(
        name: productNameController.text,
        category: _productCategory,
        description: productDescriptionController.text,
        imageUrl: _imageUrl,
        salePrice: num.parse(productSalePriceController.text),
      );

      final purchaseModel = PurchaseModel(
        dateModel: DateModel(
          timestamp: Timestamp.fromDate(_purchaseDate!),
          day: _purchaseDate!.day,
          month: _purchaseDate!.month,
          year: _purchaseDate!.year,
        ),
        purchaseprice: num.parse(productPurchasePriceController.text),
        quantity: num.parse(productQuantityController.text),
      );

      final catModel = context.read<ProductProvider>().getCategoryModelByCatName(_productCategory!);
      context.read<ProductProvider>().addNewProduct(productModel, purchaseModel, catModel).then((value) {
        _resetFields();
      }).catchError((onError){
        showMsg(context, onError);

      });

    }
  }
  void _resetFields(){
    setState((){
      productNameController.clear();
      productDescriptionController.clear();
      productQuantityController.clear();
      productPurchasePriceController.clear();
      productSalePriceController.clear();
      _imageUrl = null;
      _productCategory = null;
      _purchaseDate = null;

    });
  }
}
