import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import '../widgets/product_item.dart';
import 'new_product_page.dart';

class ProductPage extends StatelessWidget {
  static const routeName = "product-page";
  const ProductPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Product"),
      ),


      body: Consumer<ProductProvider>(
          builder: (context, provider, _) => provider.productList.isEmpty
              ? const Center(
            child:Text("No product found"),
          )
              : GridView.builder(
            padding:const EdgeInsets.only(left: 5,right: 5,top: 5),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, crossAxisSpacing: 5, mainAxisSpacing: 5),
              itemCount: provider.productList.length,
              itemBuilder: (context, index) => ProductItem(product: provider.productList[index])),),



      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, NewProductPage.routeName);
          },
          child: const Icon(Icons.add)),
    );
  }
}
