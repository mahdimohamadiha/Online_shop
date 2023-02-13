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

  final snackBarSuccess = const SnackBar(
      content: Text('order successfully submitted'),
      backgroundColor: Colors.greenAccent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(10), topLeft: Radius.circular(10)),
        side: BorderSide(
          color: Colors.green,
        ),
      ));

  Future<void> getOrdersAPI() async {
    final Uri url = Uri.parse("${MyApp.url}/get-prodect-basket");
    final headers = {'Content-Type': 'application/json'};
    final response = await http.post(url,
        headers: headers,
        body: json.encode({
          "customerID": ProfilePage.user.id,
        }));
    List<dynamic> decoded = json.decode(response.body);
    orders = [];
    print(decoded);
    setState(() {
      if (decoded.isNotEmpty) {
        for (int i = 0; i < decoded.length; i++) {
          Product product = Product.shoppingCart(
            decoded[i]['productID'],
            decoded[i]['productName'],
            decoded[i]['image'],
            decoded[i]['salePrice'],
            decoded[i]['discountedPrice'],
          );
          orders.add(product);
          print(orders);
        }
      }
      orders.forEach((element) {
        sumOfPrices += element.sellPrice;
      });
      orders.forEach((element) {
        sumOfDiscountPrices += element.sellPrice.toDouble() -
            (element.sellPrice.toDouble() *
                element.discountedPrice.toDouble() /
                100);
      });
    });
  }

  List<Product> orders = [];
  double sumOfPrices = 0;
  double sumOfDiscountPrices = 0;
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
            : Scaffold(
                body: SafeArea(
                  child: CustomScrollView(
                    slivers: [
                      SliverList(
                        delegate: SliverChildListDelegate(
                          List.generate(
                            orders.length,
                            (index) {
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
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
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
                                            RichText(
                                              text: TextSpan(
                                                text: 'price :',
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  color: Colors.black,
                                                ),
                                                children: <TextSpan>[
                                                  TextSpan(
                                                    text:
                                                        '\$${orders[index].sellPrice.toDouble()}',
                                                    style: const TextStyle(
                                                      fontSize: 20,
                                                      color: Colors.black,
                                                      decoration: TextDecoration
                                                          .lineThrough,
                                                    ),
                                                  ),
                                                  TextSpan(
                                                    text:
                                                        ' ${orders[index].discountedPrice}% ',
                                                    style: const TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 15,
                                                    ),
                                                  ),
                                                  TextSpan(
                                                    text:
                                                        ' \$${orders[index].sellPrice.toDouble() - (orders[index].sellPrice.toDouble() * orders[index].discountedPrice.toDouble() / 100)} ',
                                                    style: const TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 20,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(6.0),
                                        child: TextButton(
                                          style: TextButton.styleFrom(
                                            backgroundColor: Colors.red,
                                            minimumSize: Size(20, 120),
                                          ),
                                          child: const Icon(
                                            Icons.delete_outline,
                                            color: Colors.black,
                                          ),
                                          onPressed: () async {
                                            final Uri url = Uri.parse(
                                                "${MyApp.url}/delete-peoduct-basket");
                                            final headers = {
                                              'Content-Type': 'application/json'
                                            };
                                            final response =
                                                await http.post(url,
                                                    headers: headers,
                                                    body: json.encode({
                                                      "customerid":
                                                          ProfilePage.user.id,
                                                      "productid":
                                                          orders[index].ID,
                                                    }));
                                            var decoded =
                                                json.decode(response.body);
                                            if (decoded[
                                                'isdeleteProductBasket']) {
                                              setState(() {
                                                print(orders[index].name);
                                                getOrdersAPI();
                                              });
                                            }
                                          },
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                bottomNavigationBar: Container(
                  height: 90,
                  color: Colors.grey[300],
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Expanded(
                          child: RichText(
                            text: TextSpan(
                              text: 'price :',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                              ),
                              children: <TextSpan>[
                                TextSpan(
                                  text: '\$${sumOfPrices}',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    color: Colors.black,
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                ),
                                TextSpan(
                                  text:
                                      ' ${100 - ((sumOfDiscountPrices * 100) / sumOfPrices)} % ',
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                  ),
                                ),
                                TextSpan(
                                  text: ' $sumOfDiscountPrices ',
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                    onPressed: () async {
                                      final Uri url = Uri.parse(
                                          "${MyApp.url}/registration-products-order");
                                      final headers = {
                                        'Content-Type': 'application/json'
                                      };
                                      final response = await http.post(url,
                                          headers: headers,
                                          body: json.encode({
                                            "customerID": ProfilePage.user.id,
                                          }));
                                      var decoded = json.decode(response.body);
                                      if (decoded[
                                          'isRegistrationProductsOrder']) {
                                        print('order added');
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(snackBarSuccess);
                                        getOrdersAPI();
                                      }
                                    },
                                    child: const Text('submit as order')),
                                flex: 5,
                              ),
                              Expanded(
                                flex: 3,
                                child: TextButton.icon(
                                  onPressed: () async {
                                    final Uri url = Uri.parse(
                                        "${MyApp.url}/delete-peoduct-basket");
                                    final headers = {
                                      'Content-Type': 'application/json'
                                    };
                                    for (Product p in orders) {
                                      final response = await http.post(url,
                                          headers: headers,
                                          body: json.encode({
                                            "customerid": ProfilePage.user.id,
                                            "productid": p.ID
                                          }));
                                    }

                                    setState(() {
                                      getOrdersAPI();
                                    });
                                  },
                                  icon: const Icon(Icons.delete_outline,
                                      color: Colors.red),
                                  label: const Text(
                                    'delete all',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
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
            ),
          );
  }
}
