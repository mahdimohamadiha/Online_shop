import 'package:online_shop/product.dart';

class User {
  String email;
  String fullName;
  String city;
  String phone;
  String password;
  String address;
  List<Product> orders = [];

  User(this.email, this.fullName, this.city, this.phone, this.password,
      this.address);
}
