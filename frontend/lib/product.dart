import 'package:flutter/cupertino.dart';

class Product {
  late int ID;
  late String name;
  late String publisher;
  late int sellPrice;
  late int buyPrice;
  late int discountedPrice;
  late String discription;
  late String imageURL;
  late String gameReleaseDate;
  late int orderID;
  late int stock;
  late int status;
  late int categoryCode;
  int score = 0;

  Product.product(
    this.ID,
    this.name,
    this.publisher,
    this.sellPrice,
    this.buyPrice,
    this.discountedPrice,
    this.discription,
    this.imageURL,
    this.gameReleaseDate,
    this.stock,
    this.categoryCode,
  );
  Product.order(
    this.ID,
    this.name,
    this.sellPrice,
    this.discountedPrice,
  );

  Product.homePage(
    this.name,
    this.imageURL,
    this.sellPrice,
    this.discountedPrice,
    this.ID,
    this.categoryCode,
    this.gameReleaseDate,
  );
  Product.shoppingCart(
    this.ID,
    this.name,
    this.imageURL,
    this.sellPrice,
    this.discountedPrice,
  );
  Product.searchList(
    this.name,
    this.ID,
  );
}
