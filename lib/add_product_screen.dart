import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final TextEditingController _nameTEController = TextEditingController();
  final TextEditingController _codeTEController = TextEditingController();
  final TextEditingController _unitPriceTEController = TextEditingController();
  final TextEditingController _quantityTEController = TextEditingController();
  final TextEditingController _totalPriceTEController = TextEditingController();
  final TextEditingController _imageTEController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _addNewProductInProgress = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add New Product"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                    controller: _nameTEController,
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                        hintText: "Product Name", labelText: "Product Name"),
                    validator: (String? value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Write your Product Name';
                      }
                      return null;
                    }),
                const SizedBox(height: 16),
                TextFormField(
                    controller: _codeTEController,
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                        hintText: "Product Code", labelText: "Product Code"),
                    validator: (String? value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Write your Product Name';
                      }
                      return null;
                    }),
                const SizedBox(height: 16),
                TextFormField(
                    controller: _unitPriceTEController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                        hintText: "Unit price", labelText: "Unit price"),
                    validator: (String? value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Write your Product Name';
                      }
                      return null;
                    }),
                const SizedBox(height: 16),
                TextFormField(
                    controller: _quantityTEController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                        hintText: "Quantity", labelText: "Quantity"),
                    validator: (String? value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Write your Product Name';
                      }
                      return null;
                    }),
                const SizedBox(height: 16),
                TextFormField(
                    controller: _totalPriceTEController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                        hintText: "Total Price", labelText: "Total Price"),
                    validator: (String? value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Write your Product Name';
                      }
                      return null;
                    }),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _imageTEController,
                  decoration: const InputDecoration(
                      hintText: "Image", labelText: "Image"),
                ),
                const SizedBox(height: 16),
                Visibility(
                  visible: _addNewProductInProgress == false,
                  replacement: const Center(
                    child: CircularProgressIndicator(),
                  ),
                  child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _addProduct();
                        }
                      },
                      child: const Text(
                        "Add",
                      )),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _addProduct() async {
    _addNewProductInProgress = true;
    setState(() {});

    const String addProductUrl =
        'https://crud.teamrabbil.com/api/v1/CreateProduct';
    Map<String, dynamic> inputData = {
      "ProductName": _nameTEController.text,
      "ProductCode": _codeTEController.text,
      "Img": _imageTEController.text.trim(),
      "UnitPrice": _unitPriceTEController.text,
      "Qty": _quantityTEController.text,
      "TotalPrice": _totalPriceTEController.text,
    };

    Uri uri = Uri.parse(addProductUrl);
    Response response = await post(uri,
        body: jsonEncode(inputData),
        headers: {'content-type': 'application/json'});

    _addNewProductInProgress = false;
    setState(() {});
    if (response.statusCode == 200) {
      _nameTEController.clear();
      _codeTEController.clear();
      _unitPriceTEController.clear();
      _quantityTEController.clear();
      _totalPriceTEController.clear();
      _imageTEController.clear();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('New Product Added'),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Failed to Add New Product!...'),
      ));
    }
  }

  @override
  void dispose() {
    _nameTEController.dispose();
    _codeTEController.dispose();
    _unitPriceTEController.dispose();
    _quantityTEController.dispose();
    _totalPriceTEController.dispose();
    _imageTEController.dispose();
    super.dispose();
  }
}
