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

  Product.product(
    this.ID,
    this.name,
    this.vendor,
    this.price,
    this.buyPrice,
    this.discription,
    this.imageURL,
    this.gameReleaseDate,
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
    this.discription,
    this.imageURL,
    this.price,
    this.ID,
  );
  Product.searchList(
    this.name,
    this.ID,
  );
}
