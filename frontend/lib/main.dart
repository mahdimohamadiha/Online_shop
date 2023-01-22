import 'package:flutter/material.dart';
import 'package:online_shop/Profile.dart';
import 'package:online_shop/home-page.dart';
import 'package:online_shop/product.dart';
import 'package:online_shop/search_bar.dart';

import 'ProfilePage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static const List<Widget> _widgetOptions = <Widget>[
    Text('Search Page',
        style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold)),
    homePage(),
    ProfilePage(),
  ];

  int _selectedIndex = 1;
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
                  label: 'search',
                  icon: Icon(Icons.search),
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
            backgroundColor: Colors.grey,
            iconSize: 40,
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
                  height: 500,
                  child: Center(
                    child: _widgetOptions.elementAt(_selectedIndex),
                  ),
                ),
              ),
            ],
          ),
        )
        // This trailing comma makes auto-formatting nicer for build methods.
        );
  }
}
