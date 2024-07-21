import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shop/routes/productView.dart';

class Product {
  final int id;
  final String name;
  final String description;
  final int category_id;
  final String image;
  final double price;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.category_id,
    required this.image,
    required this.price,
  });
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
        id: json['id'],
        name: json['name'],
        description: json['description'],
        category_id: json['category_id'],
        image: json['image'],
        price: double.parse(json['price']));
  }
}

class ProductPage extends StatefulWidget {
  final int categoryId;
  const ProductPage({super.key, required this.categoryId});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  Future<List<Product>> _fetchProducts() async {
    final response = await http
        .get(Uri.parse("https://ali-izadi.ir/Shop/public/api/products"));
    if (response.statusCode == 200) {
      return List<Product>.from(
        json.decode(response.body).map((x) => Product.fromJson(x))
        .where((product) => product.category_id == widget.categoryId)
        .toList(),
      );
    } else {
      throw Exception("Faild to load products");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: _fetchProducts(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Product> Products = snapshot.data!;
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: Products.length,
              itemBuilder: (context, index) {
                final product = Products[index];
                return InkWell(
                  onTap: () {
                    Get.to(ProductViewPage(productId: product.id));
                  },
                  child: Card(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                          child: Image.network(
                              "https://ali-izadi.ir/Shop/storage/app/${product.image}")),
                      SizedBox(
                        height: 10,
                      ),
                      Text(product.name),
                      Text('${product.price} \$'),
                    ],
                  )),
                );
              },
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}