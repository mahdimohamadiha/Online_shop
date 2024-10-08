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

import 'Comment.dart';
import 'main.dart';

class Order {
  late int orderId;
  late int statusID;
  late int userId;
  late String userFullName;
  late String userEmail;
  late String? confirmationDate;
  late String requiredDate;
  late String? shippedDate;
  late List<Product> products = [];
  double sumOfPrices = 0;
  double sumOfDiscountPrices = 0;

  Order.expert(
    this.orderId,
    this.statusID,
    this.userId,
    this.userFullName,
    this.userEmail,
    this.confirmationDate,
    this.requiredDate,
  );

  Order.user(
    this.orderId,
    this.statusID,
    this.userId,
    this.confirmationDate,
    this.requiredDate,
    this.shippedDate,
  );
}

class UserOrderPage extends StatefulWidget {
  const UserOrderPage({Key? key}) : super(key: key);

  @override
  State<UserOrderPage> createState() => _UserOrderPageState();
}

class _UserOrderPageState extends State<UserOrderPage> {
  List<Order> orders = [];
  @override
  void initState() {
    getOrders();
    // TODO: implement initState
    super.initState();
  }

  Future<void> getOrders() async {
    final Uri url = Uri.parse("${MyApp.url}/get-order");
    final headers = {'Content-Type': 'application/json'};
    final response = await http.post(url,
        headers: headers,
        body: jsonEncode({"customerID": ProfilePage.user.id}));
    List<dynamic> decoded = json.decode(response.body);
    orders = [];
    for (int x = 0; x < decoded.length; x++) {
      Order order = Order.user(
        decoded[x]['orderID'],
        decoded[x]['statusID'],
        ProfilePage.user.id,
        decoded[x]['confirmationDate'],
        decoded[x]['requiredDate'],
        decoded[x]['shippedDate'],
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

  TextEditingController _textFieldController = TextEditingController();

  _displayDialog(
    BuildContext context,
    int productId,
    int customerID,
  ) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Comment '),
            content: Column(
              children: [
                TextField(
                  maxLines: 2,
                  controller: _textFieldController,
                  decoration: InputDecoration(
                    hintText: "Enter Text",
                  ),
                ),
              ],
            ),
            actions: [
              ElevatedButton(
                child: Text('SUBMIT'),
                onPressed: () async {
                  DateTime now = DateTime.now();
                  String formattedDate = DateFormat('yyyy-MM-dd').format(now);
                  print(formattedDate);
                  final Uri url = Uri.parse("${MyApp.url}/add-comment");
                  final headers = {'Content-Type': 'application/json'};
                  final response = await http.post(url,
                      headers: headers,
                      body: jsonEncode({
                        "productID": productId,
                        "customerID": customerID,
                        "textComment": _textFieldController.text,
                        "commentDate": formattedDate,
                      }));
                  var decoded = json.decode(response.body);
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("orders")),
      body: orders.isEmpty
          ? Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.black12, width: 2)),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  'You have no order',
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
              ),
            )
          : ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, orderIndex) {
                return Padding(
                  padding: EdgeInsets.all(10),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.grey,
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
                              child: Text(
                                'Products:',
                                style: TextStyle(fontSize: 20),
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 170,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 20.0, right: 20, bottom: 20, top: 5),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(20)),
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
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            flex: 6,
                                            child: Column(
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 8.0),
                                                  child: Text(
                                                      '${productIndex + 1}'),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.all(
                                                      20.0),
                                                  child:
                                                      Text(p.name.toString()),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          bottom: 10),
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
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 15,
                                                            color: Colors.black,
                                                            decoration:
                                                                TextDecoration
                                                                    .lineThrough,
                                                          ),
                                                        ),
                                                        TextSpan(
                                                          text:
                                                              ' ${p.discountedPrice}% ',
                                                          style:
                                                              const TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 10,
                                                          ),
                                                        ),
                                                        TextSpan(
                                                          text:
                                                              '\$${(p.sellPrice.toDouble() - (p.sellPrice.toDouble() * p.discountedPrice.toDouble() / 100)).toStringAsFixed(2)} ',
                                                          style:
                                                              const TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 10,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                orders[orderIndex].statusID == 3
                                                    ? Row(
                                                        children: [
                                                          ElevatedButton(
                                                              style: ElevatedButton
                                                                  .styleFrom(
                                                                      primary: Colors
                                                                              .grey[
                                                                          300]),
                                                              onPressed: () {
                                                                _displayDialog(
                                                                    context,
                                                                    p.ID,
                                                                    orders[orderIndex]
                                                                        .userId);
                                                              },
                                                              child: Text(
                                                                  'add comment')),
                                                          ElevatedButton(
                                                              style: ElevatedButton
                                                                  .styleFrom(
                                                                      primary: Colors
                                                                              .grey[
                                                                          300]),
                                                              onPressed: () {
                                                                Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                    builder:
                                                                        (context) {
                                                                      return userComment(
                                                                          id: p
                                                                              .ID);
                                                                    },
                                                                  ),
                                                                );
                                                              },
                                                              child: Text(
                                                                  'comments')),
                                                        ],
                                                      )
                                                    : Container()
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
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Column(
                                                      children: [
                                                        SizedBox(
                                                          height: 5,
                                                        ),
                                                        CircleAvatar(
                                                          backgroundColor:
                                                              Colors.blueGrey,
                                                          child: IconButton(
                                                              onPressed: () {
                                                                if (p.score <
                                                                    5) {
                                                                  setState(() {
                                                                    p.score++;
                                                                  });
                                                                }
                                                              },
                                                              icon: Icon(Icons
                                                                  .keyboard_arrow_up)),
                                                        ),
                                                        CircleAvatar(
                                                          backgroundColor:
                                                              Colors.blueGrey,
                                                          child: IconButton(
                                                              onPressed: orders[
                                                                              orderIndex]
                                                                          .statusID ==
                                                                      3
                                                                  ? () async {
                                                                      final Uri
                                                                          url =
                                                                          Uri.parse(
                                                                              "${MyApp.url}/registration-satisfaction");
                                                                      final headers =
                                                                          {
                                                                        'Content-Type':
                                                                            'application/json'
                                                                      };
                                                                      final response = await http.post(
                                                                          url,
                                                                          headers:
                                                                              headers,
                                                                          body:
                                                                              jsonEncode({
                                                                            "productID":
                                                                                p.ID,
                                                                            "customerID":
                                                                                ProfilePage.user.id,
                                                                            "orderid":
                                                                                orders[orderIndex].orderId,
                                                                            "satisfactionRate":
                                                                                p.score
                                                                          }));
                                                                      var decoded =
                                                                          json.decode(
                                                                              response.body);
                                                                      print(
                                                                          decoded);
                                                                    }
                                                                  : null,
                                                              icon: Icon(
                                                                  Icons.check)),
                                                        ),
                                                        CircleAvatar(
                                                          backgroundColor:
                                                              Colors.blueGrey,
                                                          child: IconButton(
                                                              onPressed: () {
                                                                if (p.score >
                                                                    1) {
                                                                  setState(() {
                                                                    p.score--;
                                                                  });
                                                                }
                                                              },
                                                              icon: Icon(Icons
                                                                  .keyboard_arrow_down)),
                                                        ),
                                                        SizedBox(
                                                          height: 5,
                                                        )
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
                                      text:
                                          '\$${orders[orderIndex].sumOfPrices}',
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
                                          ' ${orders[orderIndex].sumOfDiscountPrices.toStringAsFixed(2)} ',
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
                                    ? 'waiting for expert to confirm'
                                    : orders[orderIndex].statusID == 2
                                        ? 'now you can pay'
                                        : orders[orderIndex].statusID == 3
                                            ? 'success'
                                            : orders[orderIndex].statusID == 4
                                                ? 'waiting for expert to cancel'
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
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      primary: Colors.grey[200]),
                                  onPressed: orders[orderIndex].statusID == 2
                                      ? () async {
                                          final Uri url = Uri.parse(
                                              "${MyApp.url}/finalizing-order");
                                          final headers = {
                                            'Content-Type': 'application/json'
                                          };
                                          final response = await http.post(url,
                                              headers: headers,
                                              body: jsonEncode({
                                                "orderID":
                                                    orders[orderIndex].orderId
                                              }));
                                          var decoded =
                                              json.decode(response.body);
                                          print(decoded);
                                          getOrders();
                                        }
                                      : null,
                                  child: Text('pay \$'),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      primary: Colors.redAccent),
                                  onPressed: orders[orderIndex].statusID <= 2
                                      ? () async {
                                          if (orders[orderIndex].statusID ==
                                              1) {
                                            final Uri url = Uri.parse(
                                                "${MyApp.url}/delete-order");
                                            final headers = {
                                              'Content-Type': 'application/json'
                                            };
                                            final response = await http.post(
                                                url,
                                                headers: headers,
                                                body: jsonEncode({
                                                  "orderID":
                                                      orders[orderIndex].orderId
                                                }));
                                            var decoded =
                                                json.decode(response.body);
                                            print(decoded);
                                            getOrders();
                                          } else if (orders[orderIndex]
                                                  .statusID ==
                                              2) {
                                            final Uri url = Uri.parse(
                                                "${MyApp.url}/cancel-order");
                                            final headers = {
                                              'Content-Type': 'application/json'
                                            };
                                            final response = await http.post(
                                                url,
                                                headers: headers,
                                                body: jsonEncode({
                                                  "orderID":
                                                      orders[orderIndex].orderId
                                                }));
                                            var decoded =
                                                json.decode(response.body);
                                            print(decoded);
                                            getOrders();
                                          }
                                        }
                                      : null,
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
                                          '   ${orders[orderIndex].confirmationDate?.substring(5, 10)}     ${orders[orderIndex].confirmationDate?.substring(11, 16)}',
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

class userComment extends StatefulWidget {
  const userComment({Key? key, required this.id}) : super(key: key);
  final int id;
  @override
  State<userComment> createState() => _userCommentState(this.id);
}

class _userCommentState extends State<userComment> {
  final int id;
  int temp = 0;

  List<Comment> comments = [];

  _userCommentState(this.id);
  Future<void> getUserComments() async {
    temp = 0;
    final Uri url = Uri.parse("${MyApp.url}/get-comment");
    final headers = {'Content-Type': 'application/json'};
    final response = await http.post(
      url,
      headers: headers,
      body: json.encode({"productid": id}),
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
    // TODO: implement initState
    getUserComments();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: CustomScrollView(slivers: [
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
                                fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                ' ${comments[index].userName} :',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                              ),
                              Row(
                                children: [
                                  TextButton(
                                    child: Text('-'),
                                    onPressed: () async {
                                      print(temp.toString());

                                      final Uri url = Uri.parse(
                                          "${MyApp.url}/rejection-commit");
                                      final headers = {
                                        'Content-Type': 'application/json'
                                      };
                                      final response = await http.post(
                                        url,
                                        headers: headers,
                                        body: json.encode({
                                          "commentid": id,
                                          "customerid": id,
                                        }),
                                      );
                                      getUserComments();
                                    },
                                  ),
                                  Text(
                                      '${comments[index].likes - comments[index].dislikes}'),
                                  TextButton(
                                    child: Text('+'),
                                    onPressed: () async {
                                      final Uri url = Uri.parse(
                                          "${MyApp.url}/confirmation-commit");
                                      final headers = {
                                        'Content-Type': 'application/json'
                                      };
                                      final response = await http.post(
                                        url,
                                        headers: headers,
                                        body: json.encode({
                                          "commentid": id,
                                          "customerid": id,
                                        }),
                                      );
                                      getUserComments();
                                    },
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
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                    color: Colors.white70, width: 1)),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(comments[index].textComment),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ]),
    );
  }
}
