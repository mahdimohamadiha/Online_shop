import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:online_shop/Categories.dart';
import 'package:online_shop/ProfilePage.dart';
import 'package:online_shop/home-page.dart';
import 'package:online_shop/product.dart';
import 'package:online_shop/user.dart';

import 'OrdersPage.dart';
import 'main.dart';

class ExpertOrderPage extends StatefulWidget {
  const ExpertOrderPage({Key? key}) : super(key: key);

  @override
  State<ExpertOrderPage> createState() => _ExpertOrderPageState();
}

class _ExpertOrderPageState extends State<ExpertOrderPage> {
  List<Order> orders = [];
  @override
  void initState() {
    getOrders();
    // TODO: implement initState
    super.initState();
  }

  Future<void> getOrders() async {
    final Uri url = Uri.parse("${MyApp.url}/get-order-expert");
    final headers = {'Content-Type': 'application/json'};
    final response = await http.get(url, headers: headers);
    List<dynamic> decoded = json.decode(response.body);
    orders = [];
    for (int x = 0; x < decoded.length; x++) {
      Order order = Order.expert(
        decoded[x]['orderID'],
        decoded[x]['statusID'],
        decoded[x]['customerid'],
        decoded[x]['customerfullname'],
        decoded[x]['customeremail'],
        decoded[x]['confirmationDate'],
        decoded[x]['requiredDate'],
      );
      getProductsOrder(order);

      setState(() {
        orders.add(order);
      });
    }
  }

  Future<void> getProductsOrder(Order order) async {
    final Uri url = Uri.parse("${MyApp.url}/get-product-order");
    final headers = {'Content-Type': 'application/json'};
    final response = await http.post(url,
        headers: headers, body: jsonEncode({"orderid": order.orderId}));
    List<dynamic> decoded = json.decode(response.body);
    for (int x = 0; x < decoded.length; x++) {
      Product product = Product.order(
        decoded[x]['productID'],
        decoded[x]['productName'],
        decoded[x]['salePrice'],
        decoded[x]['discountedprice'],
      );
      setState(() {
        order.products.add(product);
        order.products.forEach((element) {
          order.sumOfPrices += element.sellPrice;
        });
        order.products.forEach((element) {
          order.sumOfDiscountPrices += element.sellPrice.toDouble() -
              (element.sellPrice.toDouble() *
                  element.discountedPrice.toDouble() /
                  100);
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("orders")),
      body: ListView.builder(
        itemCount: orders.length,
        itemBuilder: (context, orderIndex) {
          return Padding(
            padding: EdgeInsets.all(10),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.grey[600],
                  borderRadius: BorderRadius.circular(20)),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(
                      ' ${orders[orderIndex].requiredDate.substring(5, 10)}     ${orders[orderIndex].requiredDate.substring(11, 16)}',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Icon(Icons.person_outlined),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              '${orders[orderIndex].userFullName}',
                              style: TextStyle(fontSize: 20),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Icon(Icons.email_outlined),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              '${orders[orderIndex].userEmail}',
                              style: TextStyle(fontSize: 20),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Products:',
                          style: TextStyle(fontSize: 20),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 120,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 20.0, right: 20, bottom: 20, top: 5),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.grey[400],
                            borderRadius: BorderRadius.circular(15)),
                        child: ListView.builder(
                          itemCount: orders[orderIndex].products.length,
                          itemBuilder: (context, productIndex) {
                            Product p =
                                orders[orderIndex].products[productIndex];
                            return Padding(
                              padding: EdgeInsets.all(10),
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.grey,
                                    borderRadius: BorderRadius.circular(20)),
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 6,
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 8.0),
                                            child: Text('${productIndex + 1}'),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(10),
                                            child: Text(p.name.toString()),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 5),
                                            child: RichText(
                                              text: TextSpan(
                                                text: 'price : ',
                                                style: TextStyle(
                                                  fontSize: 15,
                                                  color: Colors.black,
                                                ),
                                                children: <TextSpan>[
                                                  TextSpan(
                                                    text:
                                                        '\$${p.sellPrice.toDouble()}',
                                                    style: const TextStyle(
                                                      fontSize: 15,
                                                      color: Colors.black,
                                                      decoration: TextDecoration
                                                          .lineThrough,
                                                    ),
                                                  ),
                                                  TextSpan(
                                                    text:
                                                        ' ${p.discountedPrice}% ',
                                                    style: const TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 10,
                                                    ),
                                                  ),
                                                  TextSpan(
                                                    text:
                                                        '\$${(p.sellPrice.toDouble() - (p.sellPrice.toDouble() * p.discountedPrice.toDouble() / 100)).toStringAsFixed(2)} ',
                                                    style: const TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 10,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                        flex: 3,
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Row(
                                                children: [
                                                  Icon(Icons.star),
                                                  Text(
                                                    p.score.toString(),
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              width: 10,
                                            )
                                          ],
                                        ))
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: RichText(
                          text: TextSpan(
                            text: 'price : ',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                text: '\$${orders[orderIndex].sumOfPrices}',
                                style: const TextStyle(
                                  fontSize: 20,
                                  color: Colors.black,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                              TextSpan(
                                text:
                                    ' ${(100 - ((orders[orderIndex].sumOfDiscountPrices * 100) / orders[orderIndex].sumOfPrices)).toStringAsFixed(0)} % ',
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                ),
                              ),
                              TextSpan(
                                text:
                                    ' ${orders[orderIndex].sumOfDiscountPrices} ',
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Status :',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: orders[orderIndex].statusID == 1
                                ? Colors.yellow[600]
                                : orders[orderIndex].statusID == 2
                                    ? Colors.grey[200]
                                    : orders[orderIndex].statusID == 3
                                        ? Colors.green[600]
                                        : orders[orderIndex].statusID == 4
                                            ? Colors.orange
                                            : null,
                            borderRadius: BorderRadius.circular(10)),
                        child: Text(
                          orders[orderIndex].statusID == 1
                              ? 'waiting for you to confirm'
                              : orders[orderIndex].statusID == 2
                                  ? 'user can pay'
                                  : orders[orderIndex].statusID == 3
                                      ? 'success'
                                      : orders[orderIndex].statusID == 4
                                          ? 'user want to cancel'
                                          : '',
                          style: TextStyle(fontSize: 20),
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 4,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: Colors.grey[200]),
                            onPressed: orders[orderIndex].statusID == 1
                                ? () async {
                                    final Uri url = Uri.parse(
                                        "${MyApp.url}/customer-order-confirmation");
                                    final headers = {
                                      'Content-Type': 'application/json'
                                    };
                                    final response = await http.post(url,
                                        headers: headers,
                                        body: jsonEncode({
                                          "orderID": orders[orderIndex].orderId
                                        }));
                                    var decoded = json.decode(response.body);
                                    print(decoded);
                                    setState(() {
                                      getOrders();
                                    });
                                  }
                                : null,
                            child: Text(' confirm '),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: Colors.redAccent),
                            onPressed: () async {
                              final Uri url =
                                  Uri.parse("${MyApp.url}/delete-order");
                              final headers = {
                                'Content-Type': 'application/json'
                              };
                              final response = await http.post(url,
                                  headers: headers,
                                  body: jsonEncode(
                                      {"orderID": orders[orderIndex].orderId}));
                              var decoded = json.decode(response.body);
                              print(decoded);
                              getOrders();
                            },
                            child: Icon(Icons.delete_outline),
                          ),
                        ),
                      ),
                    ],
                  ),
                  orders[orderIndex].confirmationDate != null
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Text(
                                    'confirmation date :',
                                    style: TextStyle(fontSize: 20),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    '  ${orders[orderIndex].confirmationDate}',
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )
                      : Container(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
