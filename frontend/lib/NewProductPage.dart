import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:online_shop/Categories.dart';
import 'package:online_shop/home-page.dart';
import 'package:online_shop/product.dart';
import 'package:online_shop/user.dart';

enum category { action, strategic, survival, sport, shooter }

class NewProductPage extends StatefulWidget {
  const NewProductPage({Key? key}) : super(key: key);

  @override
  State<NewProductPage> createState() => _NewProductPageState.addNew();
}

class EditProductPage extends StatefulWidget {
  const EditProductPage({Key? key, required this.product}) : super(key: key);
  final Product product;
  @override
  State<NewProductPage> createState() => _NewProductPageState.edit(product);
}

class _NewProductPageState extends State<NewProductPage> {
  late String _title = 'new product';
  bool isEdit = false;
  TextEditingController nameCon = TextEditingController();
  TextEditingController vendorCon = TextEditingController();
  TextEditingController buyPriceCon = TextEditingController();
  TextEditingController sellPriceCon = TextEditingController();
  TextEditingController descriptionCon = TextEditingController();
  TextEditingController imageUrlCon = TextEditingController();
  TextEditingController gameReleaseDateCon = TextEditingController();
  TextEditingController categoryCon = TextEditingController();

  _NewProductPageState.addNew() {
    homePage.categories.forEach((element) {
      cats.add(element.name);
    });
    _categorie = Categories.full('name', '', 0);
  }
  _NewProductPageState.edit(Product p) {
    isEdit = true;
    product = p;
    nameCon = TextEditingController(text: product.name);
    vendorCon = TextEditingController(text: product.vendor);
    buyPriceCon = TextEditingController(text: product.buyPrice.toString());
    sellPriceCon = TextEditingController(text: product.price.toString());
    descriptionCon = TextEditingController(text: product.discription);
    imageUrlCon = TextEditingController(text: product.imageURL);
    gameReleaseDateCon = TextEditingController(text: product.gameReleaseDate);
    categoryCon = TextEditingController(
        text: homePage.categories[product.categoryCode - 1].name);
    homePage.categories.forEach((element) {
      cats.add(element.name);
      if (element.name == categoryCon.text) {
        _categorie = element;
      }
    });
  }

  late Categories _categorie;

  late Product product;
  List<String> cats = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('new product'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              TextField(
                controller: nameCon,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Product Name',
                  hintText: 'Name',
                  contentPadding: EdgeInsets.all(20),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                controller: vendorCon,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Product Vendor',
                  hintText: 'Vendor',
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
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Product Buy Price',
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
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Product sell Price',
                        hintText: 'sell',
                        contentPadding: EdgeInsets.all(20),
                      ),
                    ),
                  )
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
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Product Description',
                  hintText: 'Description',
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
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Product Image URL',
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
                padding: const EdgeInsets.all(24.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        controller: categoryCon,
                        focusNode: AlwaysDisabledFocusNode(),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          icon: _categorie.imageURL.isEmpty
                              ? null
                              : ImageIcon(
                                  AssetImage(
                                    _categorie.imageURL,
                                  ),
                                  color: Colors.black,
                                ),
                          labelText: 'Product category',
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
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                focusNode: AlwaysDisabledFocusNode(),
                controller: gameReleaseDateCon,
                decoration: const InputDecoration(
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
                            onPressed: () {},
                            child: const Text('submit edit'),
                          )
                        : ElevatedButton(
                            onPressed: () {},
                            child: const Text('add'),
                          ),
                  ),
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        nameCon.text = '';
                        vendorCon.text = '';
                        sellPriceCon.text = '';
                        buyPriceCon.text = '';
                        descriptionCon.text = '';
                        imageUrlCon.text = '';
                        gameReleaseDateCon.text = '';
                        categoryCon.text = '';
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
