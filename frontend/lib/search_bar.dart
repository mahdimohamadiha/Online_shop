import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:online_shop/product-page.dart';
import 'package:online_shop/product.dart';
import 'package:http/http.dart' as http;

class CustomSearchDelegate extends SearchDelegate {
  Uri urlProductList = Uri.parse("http://10.0.2.2:8000/product-search");
  Uri urlGetProduct = Uri.parse("http://10.0.2.2:8000/getProduct");

  CustomSearchDelegate() {
    productsetdata();
  }

  Future<void> productsetdata() async {
    final headers = {'Content-Type': 'application/json'};
    final response = await http.get(urlProductList, headers: headers);
    List<dynamic> decoded = json.decode(response.body);
    print(decoded);
    for (int x = 0; x < decoded.length; x++) {
      Product product = Product.searchList(
        decoded[x]['productName'],
        decoded[x]['productID'],
      );
      searchTerms.add(product);
      print(product.name);
    }
  }

  late Product product;
  Future<void> getProduct(int id) async {
    final headers = {'Content-Type': 'application/json'};
    final response = await http.post(urlGetProduct,
        headers: headers, body: json.encode({'productID': id}));
    var decoded = json.decode(response.body);
    print(id);
    product = Product.product(
        id,
        decoded['productName'],
        decoded['productVendor'],
        decoded['salePrice'],
        decoded['buyPrice'],
        decoded['textDescription'],
        decoded['image'],
        decoded['gameReleaseDate']);
  }

  List<Product> searchTerms = [];

  // first overwrite to
  // clear the search text
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: Icon(Icons.clear),
      ),
    ];
  }

  // second overwrite to pop out of search menu
  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: Icon(Icons.arrow_back),
    );
  }

  // third overwrite to show query result
  @override
  Widget buildResults(BuildContext context) {
    List<Product> matchQuery = [];
    for (var product in searchTerms) {
      if (product.name.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(product);
      }
    }
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return ListTile(
          title: Text(result.name),
          onTap: () async {
            getProduct(result.ID);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return ProductPage(product: product);
                },
              ),
            );
          },
        );
      },
    );
  }

  // last overwrite to show the
  // querying process at the runtime
  @override
  Widget buildSuggestions(BuildContext context) {
    List<Product> matchQuery = [];
    for (Product product in searchTerms) {
      if (product.name.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(product);
      }
    }
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return ListTile(
          title: Text(result.name),
          onTap: () async {
            await getProduct(result.ID);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return ProductPage(product: product);
                },
              ),
            );
          },
        );
      },
    );
  }
}
