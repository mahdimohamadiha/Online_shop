import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:online_shop/Categories.dart';
import 'package:online_shop/home-page.dart';
import 'package:online_shop/product.dart';
import 'package:online_shop/user.dart';

import 'main.dart';

enum category { action, strategic, survival, sport, shooter }

class NewProductPage extends StatefulWidget {
  const NewProductPage(
      {Key? key,
      required this.product,
      required this.isEdit,
      required this.function})
      : super(key: key);
  final Product product;
  final bool isEdit;
  final Function function;
  @override
  // ignore: no_logic_in_create_state
  State<NewProductPage> createState() => isEdit
      ? _NewProductPageState.edit(product, function)
      : _NewProductPageState.addNew();
}

class _NewProductPageState extends State<NewProductPage> {
  late String _title = 'new product';
  bool isEdit = false;
  TextEditingController nameCon = TextEditingController();
  TextEditingController publisherCon = TextEditingController();
  TextEditingController buyPriceCon = TextEditingController();
  TextEditingController sellPriceCon = TextEditingController();
  TextEditingController discountCon = TextEditingController();
  TextEditingController descriptionCon = TextEditingController();
  TextEditingController imageUrlCon = TextEditingController();
  TextEditingController gameReleaseDateCon = TextEditingController();
  TextEditingController stockCon = TextEditingController();
  TextEditingController categoryCon = TextEditingController();

  _NewProductPageState.addNew() {
    homePage.categories.forEach((element) {
      cats.add(element.name);
    });
    _categorie = Categories.full('name', '', 0);
  }
  _NewProductPageState.edit(Product p, this._function) {
    isEdit = true;
    product = p;
    nameCon = TextEditingController(text: product.name);
    publisherCon = TextEditingController(text: product.publisher);
    buyPriceCon = TextEditingController(text: product.buyPrice.toString());
    sellPriceCon = TextEditingController(text: product.sellPrice.toString());
    discountCon =
        TextEditingController(text: product.discountedPrice.toString());
    descriptionCon = TextEditingController(text: product.discription);
    imageUrlCon = TextEditingController(text: product.imageURL);
    gameReleaseDateCon = TextEditingController(text: product.gameReleaseDate);
    stockCon = TextEditingController(text: product.stock.toString());
    categoryCon = TextEditingController(
        text: homePage.categories[product.categoryCode - 1].name);
    homePage.categories.forEach((element) {
      cats.add(element.name);
      if (element.name == categoryCon.text) {
        _categorie = element;
      }
    });
  }
  late Function _function;

  late Categories _categorie;

  late Product product;
  List<String> cats = [];

  bool isEmpty = true;

  void empty() {
    if (nameCon.text.isNotEmpty &&
        publisherCon.text.isNotEmpty &&
        buyPriceCon.text.isNotEmpty &&
        sellPriceCon.text.isNotEmpty &&
        discountCon.text.isNotEmpty &&
        descriptionCon.text.isNotEmpty &&
        imageUrlCon.text.isNotEmpty &&
        categoryCon.text.isNotEmpty &&
        stockCon.text.isNotEmpty &&
        gameReleaseDateCon.text.isNotEmpty) {
      isEmpty = false;
    } else {
      isEmpty = true;
    }
  }

  final snackBarError = const SnackBar(
      content: Text('error'),
      backgroundColor: Colors.redAccent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(10), topLeft: Radius.circular(10)),
        side: BorderSide(
          color: Colors.red,
        ),
      ));
  final snackBarSuccess = const SnackBar(
      content: Text('sign up success'),
      backgroundColor: Colors.greenAccent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(10), topLeft: Radius.circular(10)),
        side: BorderSide(
          color: Colors.green,
        ),
      ));

  bool firstTime = true;

  String? errorHandeler(String text) {
    if (text.isEmpty) {
      return 'required';
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('new product'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              TextField(
                controller: nameCon,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  errorText: firstTime ? null : errorHandeler(nameCon.text),
                  labelText: 'Product Name',
                  hintText: 'Name',
                  contentPadding: EdgeInsets.all(20),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                controller: publisherCon,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  errorText:
                      firstTime ? null : errorHandeler(publisherCon.text),
                  labelText: 'Product publisher',
                  hintText: 'publisher',
                  contentPadding: EdgeInsets.all(20),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: buyPriceCon,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: ' Buy ',
                        suffixIcon: Icon(Icons.attach_money_outlined),
                        errorText:
                            firstTime ? null : errorHandeler(buyPriceCon.text),
                        hintText: 'buy',
                        contentPadding: EdgeInsets.all(20),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: TextField(
                      controller: sellPriceCon,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'sell',
                        suffixIcon: Icon(Icons.attach_money_outlined),
                        errorText:
                            firstTime ? null : errorHandeler(sellPriceCon.text),
                        hintText: 'sell',
                        contentPadding: EdgeInsets.all(20),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: TextField(
                      controller: discountCon,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'discount',
                        suffixIcon: Icon(Icons.discount),
                        errorText:
                            firstTime ? null : errorHandeler(discountCon.text),
                        hintText: 'discount',
                        contentPadding: EdgeInsets.all(20),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                minLines: 2,
                maxLines: 5,
                keyboardType: TextInputType.multiline,
                controller: descriptionCon,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Product Description',
                  hintText: 'Description',
                  errorText:
                      firstTime ? null : errorHandeler(descriptionCon.text),
                  contentPadding: EdgeInsets.all(20),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                onChanged: (text) {
                  setState(() {});
                },
                controller: imageUrlCon,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Product Image URL',
                  errorText: firstTime ? null : errorHandeler(imageUrlCon.text),
                  hintText: 'URL',
                  contentPadding: EdgeInsets.all(20),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                width: 200,
                height: 200,
                child: Image.network(
                  imageUrlCon.text,
                  errorBuilder: (context, exception, stackTrace) {
                    print('can not load image');
                    return Center(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          'can not load this url',
                          style: TextStyle(),
                        ),
                        Icon(
                          Icons.error,
                          color: Colors.red,
                        )
                      ],
                    ));
                  },
                  loadingBuilder: (BuildContext context, Widget child,
                      ImageChunkEvent? loadingProgress) {
                    if (loadingProgress == null) {
                      return child;
                    }
                    return Center(
                        child: loadingProgress.expectedTotalBytes != null
                            ? Text('error')
                            : null);
                  },
                ),
                decoration: const BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.all(Radius.circular(10))),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      flex: 7,
                      child: TextField(
                        controller: categoryCon,
                        focusNode: AlwaysDisabledFocusNode(),
                        decoration: InputDecoration(
                          errorText: firstTime
                              ? null
                              : errorHandeler(categoryCon.text),
                          border: OutlineInputBorder(),
                          icon: _categorie.imageURL.isEmpty
                              ? null
                              : ImageIcon(
                                  AssetImage(
                                    _categorie.imageURL,
                                  ),
                                  color: Colors.black,
                                ),
                          labelText: 'category',
                          contentPadding: EdgeInsets.all(20),
                        ),
                      ),
                    ),
                    PopupMenuButton<String>(
                      icon: const Icon(Icons.arrow_drop_down),
                      onSelected: (String value) {
                        categoryCon.text = value;
                        setState(() {
                          homePage.categories.forEach((element) {
                            if (value == element.name) {
                              _categorie = element;
                            }
                          });
                        });
                      },
                      itemBuilder: (BuildContext context) {
                        return cats.map<PopupMenuItem<String>>((String value) {
                          return PopupMenuItem(
                              child: Text(value), value: value);
                        }).toList();
                      },
                    ),
                    Expanded(
                      flex: 4,
                      child: TextField(
                        onChanged: (text) {
                          setState(() {});
                        },
                        controller: stockCon,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'stock',
                          errorText:
                              firstTime ? null : errorHandeler(stockCon.text),
                          hintText: 'stock',
                          contentPadding: EdgeInsets.all(20),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: Column(
                        children: [
                          TextButton.icon(
                              onPressed: () {
                                setState(() {
                                  int temp = int.parse(stockCon.text) + 1;
                                  stockCon.text = temp.toString();
                                });
                              },
                              icon: Icon(Icons.keyboard_arrow_up_rounded),
                              style: TextButton.styleFrom(
                                minimumSize: Size(5, 5),
                              ),
                              label: Text('')),
                          TextButton.icon(
                              onPressed: () {
                                setState(() {
                                  int temp = int.parse(stockCon.text) - 1;
                                  stockCon.text = temp.toString();
                                });
                              },
                              style: TextButton.styleFrom(
                                minimumSize: Size(5, 5),
                              ),
                              icon: Icon(Icons.keyboard_arrow_down_rounded),
                              label: Text(''))
                        ],
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                focusNode: AlwaysDisabledFocusNode(),
                controller: gameReleaseDateCon,
                decoration: InputDecoration(
                  errorText:
                      firstTime ? null : errorHandeler(gameReleaseDateCon.text),
                  icon: Icon(Icons.date_range),
                  border: OutlineInputBorder(),
                  labelText: 'Product release Date',
                  contentPadding: EdgeInsets.all(20),
                ),
                onTap: () async {
                  DateTime? date = await showDatePicker(
                      context: context,
                      initialDate: DateTime(2000),
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now());
                  if (date != null) {
                    setState(() {
                      gameReleaseDateCon.text =
                          DateFormat('yyyy-MM-dd').format(date);
                    });
                  }
                },
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Expanded(
                    child: isEdit
                        ? ElevatedButton(
                            onPressed: () async {
                              empty();
                              setState(() {
                                firstTime = false;
                              });

                              if (!isEmpty) {
                                final Uri url = Uri.parse(
                                    "${MyApp.url}/edit-product-information");
                                final headers = {
                                  'Content-Type': 'application/json'
                                };
                                final response = await http.post(url,
                                    headers: headers,
                                    body: json.encode({
                                      "productID": product.ID,
                                      "productName": nameCon.text,
                                      "productPublisher": publisherCon.text,
                                      "buyPrice": int.parse(buyPriceCon.text),
                                      "salePrice": int.parse(sellPriceCon.text),
                                      "discountedPrice":
                                          int.parse(discountCon.text),
                                      "textDescription": descriptionCon.text,
                                      "image": imageUrlCon.text,
                                      "gameReleaseDate":
                                          gameReleaseDateCon.text,
                                      "stock": int.parse(stockCon.text),
                                      "categoryID": _categorie.code,
                                    }));
                                var decoded = json.decode(response.body);

                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBarSuccess);
                                Navigator.pop(context);
                                _function();
                              } else if (!isEmpty) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBarError);
                              }
                            },
                            child: const Text('submit edit'),
                          )
                        : ElevatedButton(
                            onPressed: () async {
                              empty();
                              setState(() {
                                firstTime = false;
                              });

                              if (!isEmpty) {
                                final Uri url = Uri.parse(
                                    "${MyApp.url}/register-product-information");
                                final headers = {
                                  'Content-Type': 'application/json'
                                };
                                final response = await http.post(url,
                                    headers: headers,
                                    body: json.encode({
                                      "productName": nameCon.text,
                                      "productPublisher": publisherCon.text,
                                      "buyPrice": int.parse(buyPriceCon.text),
                                      "salePrice": int.parse(sellPriceCon.text),
                                      "discountedPrice":
                                          int.parse(discountCon.text),
                                      "textDescription": descriptionCon.text,
                                      "image": imageUrlCon.text,
                                      "gameReleaseDate":
                                          gameReleaseDateCon.text,
                                      "stock": int.parse(stockCon.text),
                                      "category": _categorie.code,
                                    }));
                                var decoded = json.decode(response.body);

                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBarSuccess);
                                Navigator.pop(context);
                                _function();
                              } else if (isEmpty) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBarError);
                              }
                            },
                            child: const Text('add'),
                          ),
                  ),
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        nameCon.text = '';
                        publisherCon.text = '';
                        sellPriceCon.text = '';
                        buyPriceCon.text = '';
                        descriptionCon.text = '';
                        imageUrlCon.text = '';
                        gameReleaseDateCon.text = '';
                        categoryCon.text = '';
                        setState(() {
                          _categorie = Categories.full('', '', 0);
                        });
                      },
                      child: Text(
                        'clear',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}
