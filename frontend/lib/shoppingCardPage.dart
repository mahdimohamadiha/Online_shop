import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:online_shop/ProfilePage.dart';
import 'package:online_shop/home-page.dart';
import 'package:online_shop/main.dart';

class ShoppingCartPage extends StatefulWidget {
  const ShoppingCartPage({Key? key}) : super(key: key);

  @override
  State<ShoppingCartPage> createState() => _ShoppingCartPageState();
}

class _ShoppingCartPageState extends State<ShoppingCartPage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ProfilePage.logedIn
          ? Text('data')
          : Container(
              padding: EdgeInsets.all(20),
              width: 300,
              height: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.grey[300],
              ),
              child: Column(
                children: [
                  Text(
                    'you have to login or sign up to see your shopping cart ',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  Icon(
                    Icons.warning_sharp,
                    size: 30,
                  )
                ],
              )),
    );
  }
}
