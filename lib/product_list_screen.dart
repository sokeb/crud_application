import 'dart:convert';

import 'package:crud_application/add_product_screen.dart';
import 'package:crud_application/product_model.dart';
import 'package:crud_application/update_product_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  bool _getProductListInProgress = false;
  List<ProductModel> productList = [];

  @override
  void initState() {
    super.initState();
    _getProductList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product List'),
      ),
      body: RefreshIndicator(
        // onRefresh: () async {
        //   _getProductList();
        // },
        onRefresh: _getProductList,
        child: Visibility(
          visible: _getProductListInProgress == false,
          replacement: const Center(
            child: CircularProgressIndicator(),
          ),
          child: ListView.separated(
            itemCount: productList.length,
            itemBuilder: (context, index) {
              return _buildProductItem(productList[index]); // n(1)
            },
            separatorBuilder: (_, __) => const Divider(),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddProductScreen()),
          );
        },
        child: const Icon(
          Icons.add,
          size: 35,
        ),
      ),
    );
  }

  Widget _buildProductItem(ProductModel product) {
    return ListTile(
      leading: Image.network(
        product.image ?? '',
        height: 60,
        width: 60,
      ),
      title: Text(product.productName ?? 'Unknown',
          style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Wrap(
        spacing: 16,
        children: [
          Text("UNIT PRICE: ${product.unitPrice}"),
          Text("QTY: ${product.quantity}"),
          Text("TOTAL PRICE: ${product.totalPrice}"),
        ],
      ),
      trailing: Wrap(
        children: [
          IconButton(
              onPressed: () async {
                final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            UpdateProductScreen(product: product)));
                if (result == true) {
                  _getProductList();
                }
              },
              icon: const Icon(
                Icons.edit,
                color: Colors.green,
              )),
          IconButton(
              onPressed: () {
                _showDeleteConfirmationDialog(product.id!);
              },
              icon: const Icon(
                Icons.delete,
                color: Colors.redAccent,
              )),
        ],
      ),
    );
  }

  Future<void> _getProductList() async {
    _getProductListInProgress = true;
    setState(() {});
    productList.clear();
    const String productListUrl =
        'https://crud.teamrabbil.com/api/v1/ReadProduct';
    Uri uri = Uri.parse(productListUrl);
    Response response = await get(uri);

    if (response.statusCode == 200) {
      final decodedData = jsonDecode(response.body);
      final jsonProductList = decodedData['data'];
      for (Map<String, dynamic> json in jsonProductList) {
        ProductModel productModel = ProductModel.fromJson(json);
        productList.add(productModel);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Get product list failed! Try again.')),
      );
    }

    _getProductListInProgress = false;
    setState(() {});
  }

  void _showDeleteConfirmationDialog(String productId) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text(
              'Delete',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
            ),
            content: const Text(" Are you sure "),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child:
                      const Text('NO', style: TextStyle(color: Colors.blue))),
              TextButton(
                  onPressed: () {
                    _deleteProduct(productId);
                    Navigator.pop(context);
                  },
                  child:
                      const Text('yes', style: TextStyle(color: Colors.red))),
            ],
          );
        });
  }

  Future<void> _deleteProduct(String productId) async {
    _getProductListInProgress = true;
    setState(() {});
    String deletedUlr =
        'https://crud.teamrabbil.com/api/v1/DeleteProduct/$productId';
    Uri uri = Uri.parse(deletedUlr);
    Response response = await get(uri);
    if (response.statusCode == 200) {
      _getProductList();
    } else {
      _getProductListInProgress == false;
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Deleted product failed! Try again.')),
      );
    }
  }
}
