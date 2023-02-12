import 'dart:convert';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:flutter/material.dart';
import 'package:online_shop/Categories.dart';
import 'package:online_shop/main.dart';
import 'package:online_shop/product-page.dart';
import 'package:online_shop/product.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';

class homePage extends StatefulWidget {
  homePage({Key? key}) : super(key: key);
  // final Categories action =
  //     Categories.full('Action', 'asset/image/CategoriesImage/action.png');
  // final Categories strategic =
  //     Categories.full('strategic', 'asset/image/CategoriesImage/strategic.png');
  // final Categories survival =
  //     Categories.full('survival', 'asset/image/CategoriesImage/survival.png');
  // final Categories sport =
  //     Categories.full('sport', 'asset/image/CategoriesImage/sport.png');
  // final Categories shooter =
  //     Categories.full('shooter', 'asset/image/CategoriesImage/shooter.png');
  static List<Categories> categories = [
    Categories.full('Action', 'asset/image/CategoriesImage/action.png', 1),
    Categories.full(
        'strategic', 'asset/image/CategoriesImage/strategic.png', 2),
    Categories.full('survival', 'asset/image/CategoriesImage/survival.png', 3),
    Categories.full('sport', 'asset/image/CategoriesImage/sport.png', 4),
    Categories.full('shooter', 'asset/image/CategoriesImage/shooter.png', 5)
  ];

  static int catCode = 0;
  @override
  State<homePage> createState() => _homePageState();
}

class _homePageState extends State<homePage> {
  List<Product> products = [];
  List<Product> catProducts = [];

  Future<void> productsetdata() async {
    products = [];
    final Uri url = Uri.parse("${MyApp.url}/get-sort-product-release");
    final headers = {'Content-Type': 'application/json'};
    final response = await http.get(url, headers: headers);
    List<dynamic> decoded = json.decode(response.body);
    setState(() {
      for (int x = 0; x < decoded.length; x++) {
        Product product = Product.full(
            decoded[x]['productName'],
            decoded[x]['image'],
            decoded[x]['salePrice'],
            decoded[x]['productID'],
            decoded[x]['category'],
            decoded[x]['gameReleaseDate']);
        products.add(product);
      }
      catProducts = [];
      products.forEach((element) {
        catProducts.add(element);
      });
    });
  }

  Future<void> catProductSetData() async {
    final Uri url = Uri.parse("${MyApp.url}/product-categories");
    final headers = {'Content-Type': 'application/json'};
    final response = await http.post(
      url,
      headers: headers,
      body: json.encode({"category": homePage.catCode}),
    );
    List<dynamic> decoded = json.decode(response.body);
    catProducts = [];
    setState(() {
      for (int x = 0; x < decoded.length; x++) {
        Product product = Product.full(
            decoded[x]['productName'],
            decoded[x]['image'],
            decoded[x]['salePrice'],
            decoded[x]['productID'],
            homePage.catCode,
            decoded[x]['gameReleaseDate']);
        catProducts.add(product);
      }
    });
  }

  @override
  void initState() {
    productsetdata();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () {
        return Future.delayed(const Duration(seconds: 1), () {
          productsetdata();
        });
      },
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: SizedBox(
              height: 250,
              child: ListView(
                physics: NeverScrollableScrollPhysics(),
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'new product',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                      TextButton.icon(
                          onPressed: () {
                            setState(() {
                              catProducts = [];
                              products.forEach((element) {
                                catProducts.add(element);
                                print('more');
                              });
                              homePage.catCode = 0;
                            });
                          },
                          icon: Icon(Icons.arrow_right),
                          label: Text('more'))
                    ],
                  ),
                  SizedBox(
                    // Horizontal ListView
                    height: 200,
                    child: products.isEmpty
                        ? Center(
                            child: LoadingAnimationWidget.twistingDots(
                              leftDotColor: Colors.black,
                              rightDotColor: Colors.grey,
                              size: 50,
                            ),
                          )
                        : ListView.builder(
                            physics: const AlwaysScrollableScrollPhysics(),
                            itemCount: 4,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              var result = products[index];
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  width: 150,
                                  alignment: Alignment.center,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        minimumSize: Size(150, 1)),
                                    onPressed: () async {
                                      print(result.name);
                                      final headers = {
                                        'Content-Type': 'application/json'
                                      };
                                      Uri urlGetProduct =
                                          Uri.parse("${MyApp.url}/get-product");
                                      final response = await http.post(
                                          urlGetProduct,
                                          headers: headers,
                                          body: json.encode(
                                              {'productID': result.ID}));
                                      var decoded = json.decode(response.body);
                                      print(decoded);
                                      Product _product = Product.product(
                                        result.ID,
                                        decoded['productName'],
                                        decoded['productPublisher'],
                                        decoded['salePrice'],
                                        decoded['buyPrice'],
                                        decoded['discountedPrice'],
                                        decoded['textDescription'],
                                        decoded['image'],
                                        decoded['gameReleaseDate'],
                                        decoded['stock'],
                                        decoded['categoryID'],
                                      );

                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) {
                                            return ProductPage(
                                              product: _product,
                                            );
                                          },
                                        ),
                                      );
                                    },
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        // CachedNetworkImage(
                                        //     imageUrl: result.imageURL,
                                        //     width: 100,
                                        //     height: 100,
                                        //     fit: BoxFit.contain),
                                        Image.network(result.imageURL,
                                            width: 100,
                                            height: 100,
                                            fit: BoxFit.contain),
                                        Text(result.name,
                                            overflow: TextOverflow.fade,
                                            maxLines: 1,
                                            softWrap: false,
                                            style: TextStyle(fontSize: 20)),
                                        Text(result.sellPrice.toString()),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 100,
              child: ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: homePage.categories.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  var cat = homePage.categories[index];
                  return Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          boxShadow: homePage.catCode == cat.code
                              ? [
                                  BoxShadow(
                                    color: Colors.grey,
                                    blurRadius: 20.0, // soften the shadow
                                    spreadRadius: 1, //extend the shadow
                                  )
                                ]
                              : null,
                        ),
                        child: CategoriesContainer(
                          changeCat: () {
                            setState(() {
                              catProductSetData();
                            });
                          },
                          category: cat,
                        ),
                      ));
                },
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              List.generate(
                catProducts.length,
                (index) {
                  return Padding(
                    padding: const EdgeInsets.all(10),
                    child: Container(
                      child: ElevatedButton(
                        onPressed: () async {
                          print(catProducts[index].name);
                          final headers = {'Content-Type': 'application/json'};
                          Uri urlGetProduct =
                              Uri.parse("${MyApp.url}/get-product");
                          final response = await http.post(urlGetProduct,
                              headers: headers,
                              body: json.encode(
                                  {'productID': catProducts[index].ID}));
                          var decoded = json.decode(response.body);
                          Product _product = Product.product(
                            catProducts[index].ID,
                            decoded['productName'],
                            decoded['productPublisher'],
                            decoded['salePrice'],
                            decoded['buyPrice'],
                            decoded['discountedPrice'],
                            decoded['textDescription'],
                            decoded['image'],
                            decoded['gameReleaseDate'],
                            decoded['stock'],
                            decoded['categoryID'],
                          );

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return ProductPage(
                                  product: _product,
                                );
                              },
                            ),
                          );
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.network(
                                catProducts[index].imageURL,
                                width: 100,
                                height: 100,
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    catProducts[index].name,
                                    overflow: TextOverflow.fade,
                                    maxLines: 1,
                                    softWrap: false,
                                    style: TextStyle(fontSize: 20),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    'price : ${catProducts[index].sellPrice.toString()} \$',
                                    style: TextStyle(fontSize: 15),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
