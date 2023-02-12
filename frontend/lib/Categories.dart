import 'package:flutter/material.dart';
import 'package:online_shop/home-page.dart';

class Categories {
  String name;
  String imageURL;
  int code;
  Categories.full(this.name, this.imageURL, this.code);
}

class CategoriesContainer extends StatelessWidget {
  const CategoriesContainer(
      {Key? key, required this.category, required this.changeCat})
      : super(key: key);

  final Function changeCat;
  final Categories category;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 4,
          child: Container(
            width: 80,
            height: 100,
            decoration: const BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.all(Radius.circular(15))),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
              ),
              child: Image.asset(category.imageURL),
              onPressed: () {
                homePage.catCode = category.code;
                changeCat();
              },
            ),
          ),
        ),
        Expanded(
            flex: 1,
            child: Text(
              category.name,
              style: TextStyle(fontSize: 15),
            ))
      ],
    );
  }
}

class CategoriesPage extends StatelessWidget {
  final Categories category;
  const CategoriesPage({Key? key, required this.category}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Text(category.name),
      ),
    );
  }
}
