
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/category_model.dart';
import '../providers/product_provider.dart';

class CategoryPage extends StatelessWidget {
  static const routeName = "category-page";
  const CategoryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Category"),
      ),
      body: Consumer<ProductProvider>(
          builder: (context, provider, _) => provider.categoryList.isEmpty
              ? Center(
                  child: Text("No category found"),
                )
              : ListView.builder(
                  itemCount: provider.categoryList.length,
                  itemBuilder: (context, index) {
                    final category = provider.categoryList[index];
                    return ListTile(
                      title: Text(
                          "${category.catName} (${category.categoryCount})"),
                    );
                  })),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showCategoryBottomSgeet(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showCategoryBottomSgeet(BuildContext context) {
    final nameController = TextEditingController();
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Center(child: Text("Add Category")),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: nameController,
                      style: const TextStyle(
                          color: Colors.black, fontWeight: FontWeight.w500),
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: const Color(0xffe6e6e6),
                          contentPadding: const EdgeInsets.only(left: 10),
                          focusColor: Colors.white,
                          prefixIcon: const Icon(
                            Icons.category,
                          ),
                          hintText: "Enter category name",
                          hintStyle: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.normal),
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
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                        color: Theme.of(context).primaryColor
                      )
                    ),
                      onPressed: () {
                        context
                            .read<ProductProvider>()
                            .addCategory(CategoryModel(
                              catName: nameController.text,
                            ))
                            .then((value) {
                          nameController.clear();
                        });
                      },
                      child: Text("Add")),
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text("Close")),
                ],
              ),
            ));
  }
}
