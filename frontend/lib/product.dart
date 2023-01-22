import 'package:flutter/cupertino.dart';

class Product {
  int ID;
  String name;
  String vendor = '';
  int price;
  String discription;
  String imageURL;

  Product.full(this.name, this.discription, this.imageURL, this.price, this.ID);
}
