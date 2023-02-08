import 'package:flutter/material.dart';

class Categories {
  String name;
  String imageURL;
  Categories.full(this.name, this.imageURL);
}

class CategoriesContainer extends StatelessWidget {
  const CategoriesContainer({Key? key, required this.category})
      : super(key: key);
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
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return CategoriesPage(category: category);
                    },
                  ),
                );
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
