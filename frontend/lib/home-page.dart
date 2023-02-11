import 'dart:convert';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:flutter/material.dart';
import 'package:online_shop/Categories.dart';
import 'package:online_shop/main.dart';
import 'package:online_shop/product-page.dart';
import 'package:online_shop/product.dart';
import 'package:http/http.dart' as http;

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

  @override
  State<homePage> createState() => _homePageState();
}

class _homePageState extends State<homePage> {
  // Product product1 =
  //     Product.full('Cod', 'discription', 'asset/image/download.jpg', '150', 0);
  // Product product2 = Product.full('Clash of clans', 'discription',
  //     'asset/image/1-2-clash-of-clans-wizard-png.png', '150', 1);
  // Product product3 =
  //     Product.full('Cod', 'discription', 'asset/image/download.jpg', '150', 2);

  List<Product> products = [];
  Future<void> productsetdata() async {
    products = [];
    final Uri url = Uri.parse("${MyApp.url}/sort-product-release");
    final headers = {'Content-Type': 'application/json'};
    final response = await http.get(url, headers: headers);
    List<dynamic> decoded = json.decode(response.body);

    setState(() {
      for (int x = 0; x < decoded.length; x++) {
        Product product = Product.full(
            decoded[x]['productName'],
            '',
            decoded[x]['image'],
            decoded[x]['salePrice'],
            decoded[x]['productID']);
        products.add(product);
        print(product.name);
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
                            print("more");
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
                            itemCount: 3,
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
                                    onPressed: () {
                                      print(result.name);

                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) {
                                            return ProductPage(
                                              product:
                                                  products.elementAt(index),
                                            );
                                          },
                                        ),
                                      );
                                    },
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Image.network(result.imageURL,
                                            width: 100,
                                            height: 100,
                                            fit: BoxFit.contain),
                                        Text(result.name,
                                            overflow: TextOverflow.fade,
                                            maxLines: 1,
                                            softWrap: false,
                                            style: TextStyle(fontSize: 20)),
                                        Text(result.price.toString()),
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
          // SliverPadding(
          //   padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
          //   sliver: SliverGrid(
          //     delegate: SliverChildBuilderDelegate((context, index) {
          //       var cat = categories[index];
          //       return CategoriesContainer(category: cat);
          //     }, childCount: categories.length),
          //     gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          //         crossAxisCount: 4, mainAxisSpacing: 30, crossAxisSpacing: 30),
          //   ),
          // ),
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
                      padding: const EdgeInsets.all(8.0),
                      child: CategoriesContainer(
                        category: cat,
                      ));
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
