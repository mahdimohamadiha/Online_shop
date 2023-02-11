import 'package:flutter/material.dart';
import 'package:online_shop/user.dart';
import 'package:online_shop/home-page.dart';
import 'package:online_shop/product.dart';
import 'package:online_shop/search_bar.dart';
import 'package:online_shop/shoppingCardPage.dart';

import 'ProfilePage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static String url = 'http://10.0.2.2:8000';

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '',
      theme: ThemeData(useMaterial3: true, primarySwatch: Colors.grey),
      home: const MyHomePage(title: ''),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;
  static int selectedIndex = 1;
  @override
  State<MyHomePage> createState() => _MyHomePageState(selectedIndex);
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex;
  static final List<Widget> _widgetOptions = <Widget>[
    ShoppingCartPage(goToLoginPage: () {}),
    homePage(),
    ProfilePage(),
  ];
  _MyHomePageState(this._selectedIndex);
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: BottomNavigationBar(
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                  label: 'shopping cart',
                  icon: Icon(Icons.shopping_cart),
                  backgroundColor: Colors.grey[450]),
              BottomNavigationBarItem(
                  label: 'home',
                  icon: Icon(Icons.home),
                  backgroundColor: Colors.grey[400]),
              BottomNavigationBarItem(
                label: 'profile',
                icon: Icon(Icons.person),
                backgroundColor: Colors.grey[450],
              ),
            ],
            type: BottomNavigationBarType.fixed,
            showUnselectedLabels: false,
            currentIndex: _selectedIndex,
            showSelectedLabels: true,
            selectedItemColor: Colors.black,
            backgroundColor: Colors.grey[400],
            iconSize: 30,
            onTap: _onItemTapped,
            elevation: 5),
        appBar: AppBar(
          title: const Text(
            "Online shop",
          ),
          actions: [
            IconButton(
              onPressed: () {
                // method to show the search bar
                showSearch(
                    context: context,
                    // delegate to customize the search bar
                    delegate: CustomSearchDelegate());
              },
              icon: const Icon(Icons.search),
            )
          ],
        ),
        body: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: SizedBox(
                    height: 550,
                    child: Center(
                      child: _selectedIndex == 0
                          ? ShoppingCartPage(goToLoginPage: () {
                              _onItemTapped(2);
                            })
                          : _widgetOptions.elementAt(_selectedIndex),
                    )),
              ),
            ],
          ),
        )
        // This trailing comma makes auto-formatting nicer for build methods.
        );
  }
}
//commit
