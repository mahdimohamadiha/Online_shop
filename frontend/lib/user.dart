import 'package:online_shop/product.dart';

class User {
  late int id;
  late String email;
  late String fullName;
  late String city;
  late String phone;
  late String password;
  late String address;
  late String employeeName;
  late String? jobTitle;
  List<Product> orders = [];

  User(this.id, this.email, this.fullName, this.city, this.phone, this.password,
      this.address);

  User.Expert(this.email, this.fullName, this.password, this.employeeName,
      this.jobTitle);
}
