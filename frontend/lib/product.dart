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
  Product.productAsOrder(
      this.ID,
      this.name,
      this.publisher,
      this.sellPrice,
      this.buyPrice,
      this.discription,
      this.imageURL,
      this.gameReleaseDate,
      this.orderID,
      this.status);

  Product.homePage(
    this.name,
    this.imageURL,
    this.sellPrice,
    this.discountedPrice,
    this.ID,
    this.categoryCode,
    this.gameReleaseDate,
  );
  Product.searchList(
    this.name,
    this.ID,
  );
}
