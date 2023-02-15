import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:online_shop/Comment.dart';
import 'package:online_shop/ProfilePage.dart';
import 'package:online_shop/home-page.dart';
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
  Future<void> getExpertComments() async {
    final Uri url = Uri.parse("${MyApp.url}/get-comment-expert");
    final headers = {'Content-Type': 'application/json'};
    final response = await http.post(
      url,
      headers: headers,
      body: json.encode({"productid": product.ID}),
    );
    List<dynamic> decoded = json.decode(response.body);
    comments = [];
    setState(() {
      for (int x = 0; x < decoded.length; x++) {
        Comment comment = Comment.expert(
          decoded[x]['commentid'],
          decoded[x]['textcomment'],
          decoded[x]['commentdate'],
          decoded[x]['customerfullname'],
        );
        comments.add(comment);
      }
    });
  }

  Future<void> getUserComments() async {
    final Uri url = Uri.parse("${MyApp.url}/get-comment");
    final headers = {'Content-Type': 'application/json'};
    final response = await http.post(
      url,
      headers: headers,
      body: json.encode({"productid": product.ID}),
    );
    List<dynamic> decoded = json.decode(response.body);
    comments = [];
    setState(() {
      for (int x = 0; x < decoded.length; x++) {
        Comment comment = Comment.user(
          decoded[x]['commentid'],
          decoded[x]['textcomment'],
          decoded[x]['commentdate'],
          decoded[x]['customerfullname'],
          decoded[x]['confirmation'],
          decoded[x]['rejection'],
        );
        comments.add(comment);
      }
    });
  }

  @override
  void initState() {
    if (ProfilePage.isAdmin) {
      getExpertComments();
    } else {
      getUserComments();
    }
    _ProductPageState(product);
    //setNotif();
  }

  Future<void> setNotif() async {
    final Uri url = Uri.parse("${MyApp.url}/get-stock-notice");
    final headers = {'Content-Type': 'application/json'};
    final response = await http.post(url,
        headers: headers,
        body: jsonEncode({
          "productID": product.ID,
          "customerID": ProfilePage.user.id,
        }));
    var decoded = json.decode(response.body);
    notif = decoded['isReadyStockNotice'];
  }

  bool isHover = false;
  bool notif = false;

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
  final snackBarError2 = const SnackBar(
      content: Text('can not add this item'),
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
  List<Comment> comments = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(product.name),
      ),
      body: SafeArea(
        child: Column(
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
                              ),
                              Positioned(
                                left: 50,
                                top: 0,
                                child: ImageIcon(
                                  AssetImage(
                                    homePage
                                        .categories[product.categoryCode - 1]
                                        .imageURL,
                                  ),
                                  color: Colors.grey[500],
                                  size: 300,
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 20, horizontal: 20),
                                    child: Text(
                                      'Product Name :  ${product.name}',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 20),
                                    child: Text(
                                      'Release : ${product.gameReleaseDate.substring(0, 4)}',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 0, horizontal: 20),
                                    child: Text(
                                      'from : ${product.publisher}',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
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
                              ),
                              Positioned(
                                left: 10,
                                top: 200,
                                child: ImageIcon(
                                  AssetImage(
                                    homePage
                                        .categories[product.categoryCode - 1]
                                        .imageURL,
                                  ),
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Discription :',
                                  style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  product.discription,
                                  style: TextStyle(
                                    fontSize: 20,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SliverToBoxAdapter(
                    child: Center(
                      child: Text(
                        'Comments',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 24),
                      ),
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildListDelegate(
                      List.generate(
                        comments.length,
                        (index) {
                          return Padding(
                            padding: EdgeInsets.all(10),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(15)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      ' ${comments[index].date.substring(0, 10)}',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          ' ${comments[index].userName} :',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20),
                                        ),
                                        ProfilePage.isAdmin
                                            ? Container()
                                            : Row(
                                                children: [
                                                  Text(
                                                      '${comments[index].likes}'),
                                                  Icon(
                                                    Icons.favorite_outlined,
                                                    color: Colors.red,
                                                  ),
                                                ],
                                              )
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      width: 400,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          border: Border.all(
                                              color: Colors.white70, width: 1)),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child:
                                            Text(comments[index].textComment),
                                      ),
                                    ),
                                  ),
                                  ProfilePage.isAdmin
                                      ? Row(
                                          children: [
                                            Expanded(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: ElevatedButton(
                                                  onPressed: () async {
                                                    final Uri url = Uri.parse(
                                                        "${MyApp.url}/confirmation-admin-comment");
                                                    final headers = {
                                                      'Content-Type':
                                                          'application/json'
                                                    };
                                                    final response =
                                                        await http.post(url,
                                                            headers: headers,
                                                            body: jsonEncode({
                                                              "commentid":
                                                                  comments[
                                                                          index]
                                                                      .commentID,
                                                            }));
                                                    var decoded = json
                                                        .decode(response.body);
                                                    getExpertComments();
                                                  },
                                                  child: Text('confirm'),
                                                ),
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
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.grey[200],
        ),
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
                            onPressed: product.stock == 0
                                ? null
                                : () async {
                                    if (ProfilePage.logedIn) {
                                      final headers = {
                                        'Content-Type': 'application/json'
                                      };
                                      Uri urlGetProduct = Uri.parse(
                                          "${MyApp.url}/add-product-basket");
                                      final response = await http.post(
                                          urlGetProduct,
                                          headers: headers,
                                          body: json.encode({
                                            'productID': product.ID,
                                            'customerID': ProfilePage.user.id
                                          }));
                                      var decoded = json.decode(response.body);
                                      print(decoded);
                                      if (decoded['isaddProductBasket']) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(snackBarSuccess);
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(snackBarError2);
                                      }
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(snackBarError);
                                    }
                                  },
                          ),
                  ),
                  ProfilePage.isAdmin
                      ? Container()
                      : ProfilePage.logedIn && product.stock == 0
                          ? Expanded(
                              child: IconButton(
                                onPressed: notif
                                    ? () async {
                                        final Uri url = Uri.parse(
                                            "${MyApp.url}/delete-stock-notices");
                                        final headers = {
                                          'Content-Type': 'application/json'
                                        };
                                        final response = await http.post(url,
                                            headers: headers,
                                            body: jsonEncode({
                                              "productID": product.ID,
                                              "customerID": ProfilePage.user.id,
                                            }));
                                        var decoded =
                                            json.decode(response.body);
                                        setState(() {
                                          notif = !notif;
                                        });
                                      }
                                    : () async {
                                        final Uri url = Uri.parse(
                                            "${MyApp.url}/add-stock-notices");
                                        final headers = {
                                          'Content-Type': 'application/json'
                                        };
                                        final response = await http.post(url,
                                            headers: headers,
                                            body: jsonEncode({
                                              "productID": product.ID,
                                              "customerID": ProfilePage.user.id,
                                            }));
                                        var decoded =
                                            json.decode(response.body);
                                        setState(() {
                                          notif = !notif;
                                        });
                                      },
                                icon: notif
                                    ? Icon(Icons.notifications_active)
                                    : Icon(Icons.notifications_none),
                              ),
                            )
                          : Container(),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0, bottom: 10),
                child: Row(
                  children: [
                    RichText(
                      text: TextSpan(
                        text: 'price :',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: '\$${product.sellPrice.toDouble()}',
                            style: const TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                          TextSpan(
                            text: ' ${product.discountedPrice}% ',
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                            ),
                          ),
                          TextSpan(
                            text:
                                ' \$${(product.sellPrice.toDouble() - (product.sellPrice.toDouble() * product.discountedPrice.toDouble() / 100)).toStringAsFixed(2)} ',
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
            ),
          ],
        ),
      ),
    );
  }
}
