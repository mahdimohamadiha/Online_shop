import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:online_shop/ProfilePage.dart';
import 'package:online_shop/product.dart';
import 'package:http/http.dart' as http;

import 'NewProductPage.dart';
import 'main.dart';

class ProductPage extends StatefulWidget {
  final Product product;
  const ProductPage({Key? key, required this.product}) : super(key: key);

  @override
  State<ProductPage> createState() => _ProductPageState(product);
}

class _ProductPageState extends State<ProductPage> {
  Product product;

  _ProductPageState(this.product);

  @override
  void initState() {
    _ProductPageState(product);
  }

  bool isHover = false;

  final snackBarError = const SnackBar(
      content: Text('you have to login first'),
      backgroundColor: Colors.redAccent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(10), topLeft: Radius.circular(10)),
        side: BorderSide(
          color: Colors.red,
        ),
      ));
  final snackBarSuccess = const SnackBar(
      content: Text('this product successfully added'),
      backgroundColor: Colors.greenAccent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(10), topLeft: Radius.circular(10)),
        side: BorderSide(
          color: Colors.green,
        ),
      ));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(product.name),
      ),
      body: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height - 180,
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: SizedBox(
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            Container(
                              color: Colors.white,
                              height: 450,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(25),
                                    bottomRight: Radius.circular(25)),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 5,
                                    blurRadius: 7,
                                    offset: Offset(
                                        0, 3), // changes position of shadow
                                  ),
                                ],
                                color: Colors.grey[300],
                              ),
                              height: 300,
                              width: double.infinity,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 30, horizontal: 20),
                                    child: Text(
                                      'Product Name :  ${product.name}',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 0, horizontal: 20),
                                    child: Text(
                                      'Price : ${product.price.toString()}',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Positioned(
                              top: 150,
                              right: 10,
                              left: 100,
                              child: Container(
                                child: Image.network(
                                  product.imageURL,
                                  height: 300,
                                  width: 200,
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.grey[200],
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 5,
                          child: ProfilePage.isAdmin
                              ? ElevatedButton(
                                  child: Text("edit"),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) {
                                          return NewProductPage(
                                            product: product,
                                            isEdit: true,
                                            function: () {
                                              setState(() {
                                                Navigator.pop(context);
                                              });
                                            },
                                          );
                                        },
                                      ),
                                    );
                                  },
                                )
                              : ElevatedButton(
                                  child: Text("add to shopping card"),
                                  onPressed: () async {
                                    if (ProfilePage.logedIn) {
                                      final headers = {
                                        'Content-Type': 'application/json'
                                      };
                                      Uri urlGetProduct = Uri.parse(
                                          "${MyApp.url}/registration-products-order");
                                      final response = await http.post(
                                          urlGetProduct,
                                          headers: headers,
                                          body: json.encode({
                                            'productID': product.ID,
                                            'customerID': ProfilePage.user.id
                                          }));
                                      var decoded = json.decode(response.body);
                                      print(decoded);
                                      print(product.ID);
                                      print(ProfilePage.user.id);

                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(snackBarSuccess);
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(snackBarError);
                                    }
                                  },
                                ),
                        ),
                        Expanded(
                          child: IconButton(
                            onPressed: () {},
                            icon: Icon(Icons.doorbell),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(
                      'price : ${product.price} \$',
                      style: TextStyle(fontSize: 20),
                    ),
                  ))
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
