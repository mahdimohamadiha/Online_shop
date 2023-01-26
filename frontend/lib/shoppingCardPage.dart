import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:online_shop/ProfilePage.dart';
import 'package:online_shop/home-page.dart';
import 'package:online_shop/main.dart';

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

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ProfilePage.logedIn
          ? Text('data')
          : Container(
              padding: const EdgeInsets.all(20),
              width: 300,
              height: 200,
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
              )),
    );
  }
}
