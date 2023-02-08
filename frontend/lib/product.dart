import 'package:flutter/cupertino.dart';

class Product {
  late int ID;
  late String name;
  late String vendor = '';
  late int price;
  late String discription;
  late String imageURL;

  Product.full(this.name, this.discription, this.imageURL, this.price, this.ID);
  Product.searchList(this.name, this.ID);
}
