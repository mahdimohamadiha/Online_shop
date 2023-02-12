import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:online_shop/ProfilePage.dart';
import 'package:online_shop/home-page.dart';
import 'package:online_shop/main.dart';
import 'package:online_shop/product-page.dart';
import 'package:online_shop/product.dart';
import 'package:http/http.dart' as http;

class ShoppingCartPage extends StatefulWidget {
  const ShoppingCartPage({Key? key, required this.goToLoginPage})
      : super(key: key);
  final Function goToLoginPage;

  @override
  State<ShoppingCartPage> createState() =>
      _ShoppingCartPageState(this.goToLoginPage);
}

class _ShoppingCartPageState extends State<ShoppingCartPage> {
  Function _functiongoToLoginPage;

  _ShoppingCartPageState(this._functiongoToLoginPage);

  Future<void> getOrdersAPI() async {
    final Uri url = Uri.parse("${MyApp.url}/get-product-order");
    final headers = {'Content-Type': 'application/json'};
    final response = await http.post(url,
        headers: headers,
        body: json.encode({
          "customerID": ProfilePage.user.id,
        }));
    List<dynamic> decoded = json.decode(response.body);
    print(decoded);
    setState(() {
      if (decoded.isNotEmpty) {
        for (int i = 0; i < decoded.length; i++) {
          Product product = Product.productAsOrder(
            decoded[i]['productID'],
            decoded[i]['productName'],
            decoded[i]['productVendor'],
            decoded[i]['salePrice'],
            decoded[i]['buyPrice'],
            decoded[i]['textDescription'],
            decoded[i]['image'],
            decoded[i]['gameReleaseDate'],
            decoded[i]['orderID'],
            decoded[i]['status'],
          );
          orders.add(product);
          print(orders);
        }
      }
    });
  }

  List<Product> orders = [];

  @override
  void initState() {
    // TODO: implement initState
    getOrdersAPI();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ProfilePage.logedIn
        ? orders.isEmpty
            ? Text('your shopping cart is empty')
            : CustomScrollView(
                slivers: [
                  SliverList(
                      delegate: SliverChildListDelegate(
                          List.generate(orders.length, (index) {
                    return Padding(
                      padding: const EdgeInsets.all(10),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.network(
                                orders[index].imageURL,
                                width: 100,
                                height: 100,
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    orders[index].name,
                                    overflow: TextOverflow.fade,
                                    maxLines: 1,
                                    softWrap: false,
                                    style: TextStyle(fontSize: 20),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    'price : ${orders[index].sellPrice.toString()} \$',
                                    style: TextStyle(fontSize: 15),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  if (orders[index].status == 1)
                                    Text(
                                      'waiting for expert to confirm',
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.yellow,
                                      ),
                                    )
                                  else if (orders[index].status == 2)
                                    Text(
                                      'you can pay now',
                                      style: TextStyle(
                                          fontSize: 15, color: Colors.green),
                                    ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: TextButton(
                                        style: TextButton.styleFrom(
                                          backgroundColor: Colors.blueGrey,
                                          minimumSize: Size(1, 1),
                                        ),
                                        child: Icon(
                                          orders[index].status == 2
                                              ? Icons.attach_money
                                              : Icons.money_off,
                                          color: Colors.black,
                                        ),
                                        onPressed: orders[index].status == 2
                                            ? () {
                                                setState(() {});
                                              }
                                            : null,
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(right: 8.0),
                                      child: TextButton(
                                        style: TextButton.styleFrom(
                                          backgroundColor: Colors.red,
                                          minimumSize: Size(1, 1),
                                        ),
                                        child: const Icon(
                                          Icons.delete_outline,
                                          color: Colors.black,
                                        ),
                                        onPressed: () {
                                          setState(() {});
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  }))),
                  // Padding(
                  //   padding: const EdgeInsets.only(top: 10.0, left: 10),
                  //   child: SizedBox(
                  //     height: MediaQuery.of(context).size.height - 200,
                  //     child: GridView.builder(
                  //       physics: const AlwaysScrollableScrollPhysics(),
                  //       itemCount: orders.length,
                  //       scrollDirection: Axis.vertical,
                  //       itemBuilder: (context, index) {
                  //         var result = orders[index];
                  //         return Padding(
                  //           padding: const EdgeInsets.all(8.0),
                  //           child: Container(
                  //             width: 150,
                  //             alignment: Alignment.center,
                  //             child: Stack(
                  //               children: [
                  //                 ElevatedButton(
                  //                   style: ElevatedButton.styleFrom(
                  //                       minimumSize: Size(150, 1)),
                  //                   onPressed: () {
                  //                     print(result.name);
                  //
                  //                     Navigator.push(
                  //                       context,
                  //                       MaterialPageRoute(
                  //                         builder: (context) {
                  //                           return ProductPage(
                  //                               product: orders[index]);
                  //                         },
                  //                       ),
                  //                     );
                  //                   },
                  //                   child: Column(
                  //                     mainAxisAlignment:
                  //                         MainAxisAlignment.center,
                  //                     children: [
                  //                       Image.network(result.imageURL,
                  //                           width: 100,
                  //                           height: 100,
                  //                           fit: BoxFit.contain),
                  //                       Text(result.name,
                  //                           overflow: TextOverflow.fade,
                  //                           maxLines: 1,
                  //                           softWrap: false,
                  //                           style: TextStyle(fontSize: 20)),
                  //                       Text(result.price.toString()),
                  //                     ],
                  //                   ),
                  //                 ),
                  //                 Positioned(
                  //                   bottom: 0,
                  //                   right: 0,
                  //                   child: TextButton(
                  //                     style: TextButton.styleFrom(
                  //                       minimumSize: Size(1, 1),
                  //                       backgroundColor: Colors.red,
                  //                     ),
                  //                     child: const Icon(
                  //                       Icons.delete_outline,
                  //                       size: 15,
                  //                       color: Colors.black,
                  //                     ),
                  //                     onPressed: () {
                  //                       setState(() {
                  //                         orders.removeAt(index);
                  //                       });
                  //                     },
                  //                   ),
                  //                 )
                  //               ],
                  //             ),
                  //           ),
                  //         );
                  //       },
                  //       gridDelegate:
                  //           const SliverGridDelegateWithMaxCrossAxisExtent(
                  //               maxCrossAxisExtent: 200,
                  //               childAspectRatio: 1,
                  //               crossAxisSpacing: 20,
                  //               mainAxisSpacing: 20),
                  //     ),
                  //   ),
                  // ),
                  // Expanded(
                  //   child: Padding(
                  //     padding: const EdgeInsets.all(8.0),
                  //     child: Row(
                  //       children: [
                  //         Expanded(
                  //           child: ElevatedButton(
                  //               onPressed: () {
                  //                 print('pardakht');
                  //               },
                  //               child: const Text('pay')),
                  //           flex: 5,
                  //         ),
                  //         Expanded(
                  //           flex: 3,
                  //           child: TextButton.icon(
                  //             onPressed: () {
                  //               setState(() {
                  //                 ProfilePage.user.orders = [];
                  //                 orders = [];
                  //               });
                  //             },
                  //             icon: const Icon(Icons.delete_outline,
                  //                 color: Colors.red),
                  //             label: const Text(
                  //               'delete all',
                  //               style: TextStyle(color: Colors.red),
                  //             ),
                  //           ),
                  //         )
                  //       ],
                  //     ),
                  //   ),
                  // )
                ],
              )
        : Container(
            padding: const EdgeInsets.all(20),
            width: 300,
            height: 300,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.grey[300],
            ),
            child: Column(
              children: [
                const Text(
                  'you have to login or sign up to see your shopping cart ',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                const Icon(
                  Icons.warning_sharp,
                  size: 30,
                ),
                ElevatedButton(
                    onPressed: () {
                      _functiongoToLoginPage();
                    },
                    child: Text('Login'))
              ],
            ));
  }
}
