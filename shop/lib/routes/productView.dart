import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shop/routes/store.dart';

class ProductViewPage extends StatefulWidget {
  final int productId;
  const ProductViewPage({super.key, required this.productId});

  @override
  State<ProductViewPage> createState() => _ProductViewPageState();
}

class _ProductViewPageState extends State<ProductViewPage> {
  Future _fetchProducts() async {
    var pID = widget.productId;
    final response = await http
        .get(Uri.parse("https://ali-izadi.ir/Shop/public/api/products/${pID}"));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception("Faild to load products");
    }
  }

  int count = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: _fetchProducts(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView(
              children: [
                Column(
                  children: [
                    SizedBox(
                      height: 40,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        InkWell(
                          onTap: () {
                            Get.to(storePage());
                          },
                          child: Icon(
                            Icons.arrow_back,
                          ),
                        ),
                        Text(
                          'Shop',
                          style: TextStyle(fontSize: 18),
                        ),
                        Icon(Icons.shopping_bag_outlined),
                      ],
                    ),
                    Image.network(
                      'https://ali-izadi.ir/Shop/storage/app/${snapshot.data['image']}',
                      width: MediaQuery.of(context).size.width * 0.6,
                    ),
                    Text(
                      snapshot.data['name'].toString(),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(12, 5, 12, 8),
                      child: Text(
                        '${snapshot.data['price']} \$',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(12, 5, 12, 8),
                      child: Text(
                        '${snapshot.data['description']}',
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      bottomNavigationBar: ButtonBar(
        children: [
          Row(
            children: [
              if (count == 0)
                Container(
                  width: 140,
                  height: 40,
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        count++;
                      });
                    },
                    child: Text(
                      'Add To Cart',
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                    ),
                  ),
                ),
              if (count > 0)
                if (count == 1)
                  Container(
                    width: 140,
                    height: 40,
                    child: ElevatedButton(
                      onPressed: () {},
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () {
                            setState(() {
                              count--;
                            });
                          },
                            child: Icon(Icons.delete_forever,
                                color: Color.fromARGB(255, 122, 36, 30)),
                          ),
                          Text(
                            count.toString(),
                            style: TextStyle(color: Colors.black),
                          ),
                          InkWell(
                            onTap: () {
                            setState(() {
                              count++;
                            });
                          },
                            child: Icon(Icons.add,
                                color: const Color.fromARGB(255, 25, 70, 48)),
                          )
                        ],
                      ),
                      style: TextButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 159, 168, 181),
                      ),
                    ),
                  ),
              if (count > 1)
                Container(
                  width: 140,
                  height: 40,
                  child: ElevatedButton(
                    onPressed: () {},
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () {
                            setState(() {
                              count--;
                            });
                          },
                          child: Icon(
                            Icons.remove,
                            color: Color.fromARGB(255, 122, 36, 30),
                          ),
                        ),
                        Text(
                          count.toString(),
                          style: TextStyle(color: Colors.black),
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              count++;
                            });
                          },
                          child: Icon(Icons.add,
                              color: const Color.fromARGB(255, 25, 70, 48)),
                        ),
                      ],
                    ),
                    style: TextButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 159, 168, 181),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
