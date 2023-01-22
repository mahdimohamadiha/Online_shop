import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:online_shop/product.dart';

class slm extends StatefulWidget {
  const slm({Key? key}) : super(key: key);

  @override
  State<slm> createState() => _slmState();
}

class _slmState extends State<slm> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(product.name),
      ),
      body: Center(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: SizedBox(
                height: 800,
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Container(
                          height: 500,
                          color: Colors.white,
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
                                offset:
                                    Offset(0, 3), // changes position of shadow
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
                            child: Image.network(product.imageURL),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
