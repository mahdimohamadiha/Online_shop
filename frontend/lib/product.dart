import 'package:flutter/cupertino.dart';

class Product {
  late int ID;
  late String name;
  late String vendor;
  late int price;
  late int buyPrice;
  late String discription;
  late String imageURL;
  late String gameReleaseDate;
  late int orderID;
  late int categoryCode;

  Product.product(
    this.ID,
    this.name,
    this.vendor,
    this.price,
    this.buyPrice,
    this.discription,
    this.imageURL,
    this.gameReleaseDate,
    this.categoryCode,
  );
  Product.productAsOrder(
      this.ID,
      this.name,
      this.vendor,
      this.price,
      this.buyPrice,
      this.discription,
      this.imageURL,
      this.gameReleaseDate,
      this.orderID);

  Product.full(
    this.name,
    this.imageURL,
    this.price,
    this.ID,
    this.categoryCode,
    this.gameReleaseDate,
  );
  Product.searchList(
    this.name,
    this.ID,
  );
}
