import "package:flutter/material.dart";
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'dart:convert';
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

class searchResultPage extends StatefulWidget {
  const searchResultPage({super.key});

  @override
  State<searchResultPage> createState() => _searchResultPageState();
}

class _searchResultPageState extends State<searchResultPage> {
  var controller = TextEditingController();
  String get value => controller.text.trim();
  var search;

  Future<List<Product>> _fetchProducts() async {
    if (value == "") {
      search = "vsbgdqwpdz48623-+*/%";
    } else {
      search = value;
    }
    final response = await http.get(
        Uri.parse("https://ali-izadi.ir/Shop/public/api/product?q=${search}"));
    if (response.statusCode == 200) {
      return List<Product>.from(
        json.decode(response.body).map((x) => Product.fromJson(x)).toList(),
      );
    } else {
      throw Exception("Faild to load products");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                onChanged: (value) {
                  setState(() {});
                },
                controller: controller,
                cursorColor: Colors.blueAccent,
                decoration: InputDecoration(
                    hintText: 'Search',
                    border: InputBorder.none,
                    suffixIcon: Icon(Icons.arrow_forward_ios),
                    prefixIcon: Icon(Icons.search),
                    prefixIconColor: MaterialStateColor.resolveWith((states) =>
                        states.contains(MaterialState.focused)
                            ? Colors.blueAccent
                            : Colors.black)),
              ),
            ),
            Container(
              height: 150,
              child: Expanded(
                child: FutureBuilder(
                  future: _fetchProducts(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      List<Product> Products = snapshot.data!;
                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: Products.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          final product = Products[index];
                          return InkWell(
                            onTap: () {
                              Get.to(ProductViewPage(productId: product.id));
                            },
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 15,
                                ),
                                Image.network(
                                  "https://ali-izadi.ir/Shop/storage/app/${product.image}",
                                  width: 50,
                                ),
                                Text(product.name),
                              ],
                            ),
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
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 0, 8),
              child: Row(
                children: [
                  Icon(Icons.more_horiz),
                  SizedBox(width: 10),
                  Text(
                    'All products in your search',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),
            FutureBuilder(
              future: _fetchProducts(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<Product> Products = snapshot.data!;
                  return ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: Products.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      final product = Products[index];
                      return InkWell(
                        onTap: () {
                          Get.to(ProductViewPage(productId: product.id));
                        },
                        child: Column(
                          children: [
                            SizedBox(
                              height: 4,
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  width: 16,
                                ),
                                Icon(
                                  Icons.search,
                                  size: 19,
                                ),
                                SizedBox(
                                  width: 12,
                                ),
                                Text(product.name),
                              ],
                            ),
                          ],
                        ),
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
          ],
        ),
      ),
    );
  }
}
