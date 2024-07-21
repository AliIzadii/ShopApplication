import 'dart:convert';
import "package:flutter/material.dart";
import 'package:carousel_slider/carousel_slider.dart';
import 'package:get/get.dart';
import 'package:shop/routes/product.dart';
import 'package:http/http.dart' as http;
import 'package:shop/routes/productView.dart';
import 'package:shop/routes/searchResult.dart';

class Categories {
  final int id;
  final String name;

  Categories({
    required this.id,
    required this.name,
  });
  factory Categories.fromJson(Map<String, dynamic> json) {
    return Categories(
      id: json['id'],
      name: json['name'],
    );
  }
}

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

class storePage extends StatefulWidget {
  const storePage({super.key});

  @override
  State<storePage> createState() => _storePageState();
}

class _storePageState extends State<storePage> {
  Future<List<Categories>> _fetchCategories() async {
    final response = await http
        .get(Uri.parse("https://ali-izadi.ir/Shop/public/api/categories"));
    if (response.statusCode == 200) {
      return List<Categories>.from(json
          .decode(response.body)
          .map((x) => Categories.fromJson(x))
          .toList());
    } else {
      throw Exception("Faild to load Categories");
    }
  }

  Future<List<Product>> _fetchProducts() async {
    final response = await http
        .get(Uri.parse("https://ali-izadi.ir/Shop/public/api/products"));
    if (response.statusCode == 200) {
      return List<Product>.from(
        json.decode(response.body).map((x) => Product.fromJson(x)).toList(),
      );
    } else {
      throw Exception("Faild to load products");
    }
  }

  static const List<String> images = [
    "https://img.freepik.com/psd-premium/banne-horizontal-do-site_451189-110.jpg?w=360",
    "https://img.freepik.com/premium-vector/modern-sale-banner-website-slider-template-design_54925-46.jpg",
    "https://storage.googleapis.com/pickaboo-prod/media/dcastalia_hybridslider/image/app_banner_copy_1_1__1.jpg",
    "https://d1csarkz8obe9u.cloudfront.net/posterpreviews/new-arrival-laptop-banner-design-template-8d07b7c4a51b16d4450580b11d1f2b57_screen.jpg?ts=1698478917",
    "https://storage.googleapis.com/pickaboo-prod/media/dcastalia_hybridslider/image/Best_selling_tv_2_app_banner_copy_1_.jpg",
  ];

  int curr = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.account_circle_rounded),
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.shopping_cart),
                ),
                SizedBox(
                  width: 15,
                ),
                Container(
                  width: 265,
                  height: 45,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: const Color.fromRGBO(206, 212, 223, 1),
                  ),
                  padding: EdgeInsets.only(left: 13),
                  child: TextField(
                    onTap: () {
                      Get.to(searchResultPage());
                    },
                    decoration: InputDecoration(
                      hintText: 'Search',
                      hintStyle:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w200),
                      border: InputBorder.none,
                      suffixIcon: Icon(Icons.search),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            CarouselSlider(
              items: images.map((image) {
                return Container(
                  margin: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      image: DecorationImage(
                          image: NetworkImage(image), fit: BoxFit.cover)),
                );
              }).toList(),
              options: CarouselOptions(
                  autoPlay: true,
                  enlargeCenterPage: true,
                  aspectRatio: 2.0,
                  onPageChanged: (index, reason) {
                    setState(() {
                      curr = index;
                    });
                  }),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: images.map((image) {
                int index = images.indexOf(image);
                return Container(
                  width: 8,
                  height: 8,
                  margin: EdgeInsets.symmetric(horizontal: 2, vertical: 10),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: curr == index
                        ? Color.fromRGBO(0, 0, 1, 0.9)
                        : Color.fromRGBO(0, 0, 0, 0.4),
                  ),
                );
              }).toList(),
            ),
            FutureBuilder(
              future: _fetchCategories(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<Categories> Category = snapshot.data!;
                  return GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      crossAxisSpacing: 5,
                      mainAxisSpacing: 5,
                    ),
                    itemCount: Category.length,
                    shrinkWrap: true,
                    padding: EdgeInsets.only(left: 15, right: 10),
                    itemBuilder: (context, index) {
                      final Categori = Category[index];
                      return InkWell(
                        onTap: () {
                          Get.to(ProductPage(
                            categoryId: Categori.id,
                          ));
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              height: 45,
                              decoration: BoxDecoration(
                                color: Color.fromARGB(255, 124, 22, 197),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Center(
                                child: Text(
                                  Categori.name,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            )
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
            FutureBuilder(
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
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
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
                  return Center();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
