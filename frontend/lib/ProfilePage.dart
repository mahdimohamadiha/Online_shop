import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:online_shop/NewProductPage.dart';
import 'package:online_shop/main.dart';
import 'package:online_shop/user.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);
  @override
  State<ProfilePage> createState() => _ProfilePageState();
  static bool logedIn = false;
  static bool isAdmin = false;
  static User user =
      User('email', 'fullName', 'city', 'phone', 'password', 'address');
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    if (ProfilePage.logedIn && !ProfilePage.isAdmin) {
      return Userprofile(
        onLogedIn: () {
          setState(() {});
        },
      );
    } else if (ProfilePage.logedIn && ProfilePage.isAdmin) {
      return AdminProfile(
        onLogedIn: () {
          setState(() {});
        },
      );
    } else {
      return LoginPage(
        onLogedIn: () {
          setState(() {});
        },
      );
    }
  }
}

class AdminProfile extends StatefulWidget {
  const AdminProfile({Key? key, required this.onLogedIn}) : super(key: key);
  final Function onLogedIn;
  @override
  State<AdminProfile> createState() => _AdminProfileState(this.onLogedIn);
}

class _AdminProfileState extends State<AdminProfile> {
  Function _function;
  _AdminProfileState(this._function);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 60, vertical: 20),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(120),
                child: Image.asset(
                  'asset/image/profile.png',
                  width: 120,
                  height: 120,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  ProfilePage.isAdmin = false;
                  ProfilePage.logedIn = false;
                  _function();
                },
                child: const Text('logout'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return NewProductPage();
                      },
                    ),
                  );
                },
                child: const Text('add new product'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Userprofile extends StatefulWidget {
  const Userprofile({Key? key, required this.onLogedIn}) : super(key: key);
  final Function onLogedIn;
  @override
  State<Userprofile> createState() => _UserprofileState(this.onLogedIn);
}

class _UserprofileState extends State<Userprofile> {
  TextStyle _textStyle = TextStyle(fontSize: 20);
  Function _function;
  _UserprofileState(this._function);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 60, vertical: 20),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(120),
                child: Image.asset(
                  'asset/image/profile.png',
                  width: 120,
                  height: 120,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'full name :',
                        style: _textStyle,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        'Email : ',
                        style: _textStyle,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        'address : ',
                        style: _textStyle,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        'city :',
                        style: _textStyle,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        'phone number :  ',
                        style: _textStyle,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ProfilePage.user.fullName,
                        style: _textStyle,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        ProfilePage.user.email,
                        style: _textStyle,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        ProfilePage.user.address,
                        style: _textStyle,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        ProfilePage.user.city,
                        style: _textStyle,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        ProfilePage.user.phone,
                        style: _textStyle,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  )
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {
                _function();
                ProfilePage.logedIn = false;
              },
              child: const Text('logout'),
            )
          ],
          crossAxisAlignment: CrossAxisAlignment.start,
        ),
      ),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key, required this.onLogedIn}) : super(key: key);
  final Function onLogedIn;

  @override
  State<LoginPage> createState() => _LoginPageState(onLogedIn);
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool firstTime = true;
  bool isAdmin = false;

  Function _function;

  _LoginPageState(this._function);

  String? errorHandeler(String text) {
    if (text.isEmpty) {
      return 'required';
    } else {
      return null;
    }
  }

  bool isEmpty = true;
  void empty() {
    if (emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
      isEmpty = false;
    } else {
      isEmpty = true;
    }
  }

  final snackBarError = const SnackBar(
      content: Text('password or Email was wrong'),
      backgroundColor: Colors.redAccent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(10), topLeft: Radius.circular(10)),
        side: BorderSide(
          color: Colors.red,
        ),
      ));
  final snackBarSuccess = const SnackBar(
      content: Text('login success'),
      backgroundColor: Colors.greenAccent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(10), topLeft: Radius.circular(10)),
        side: BorderSide(
          color: Colors.green,
        ),
      ));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
        child: Column(
          children: <Widget>[
            const Text(
              'Login',
              style: TextStyle(fontSize: 50),
            ),
            SizedBox(height: 10),
            Form(
              child: Column(
                children: [
                  TextField(
                    onChanged: (text) {
                      setState(() {});
                    },
                    controller: emailController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.person),
                      border: OutlineInputBorder(),
                      errorText: firstTime
                          ? null
                          : errorHandeler(emailController.text),
                      labelText: 'Email',
                      hintText: 'Enter Your Email',
                      contentPadding: EdgeInsets.all(20),
                    ),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    onChanged: (text) {
                      setState(() {});
                    },
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.lock_outline),
                      border: OutlineInputBorder(),
                      errorText: firstTime
                          ? null
                          : errorHandeler(passwordController.text),
                      labelText: 'Password',
                      hintText: 'Enter Password',
                      contentPadding: EdgeInsets.all(20),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Admin',
                        style: TextStyle(fontSize: 18),
                      ),
                      Checkbox(
                          value: isAdmin,
                          onChanged: (value) {
                            setState(() {
                              isAdmin = value!;
                            });
                          }),
                    ],
                  )
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                final Uri url = Uri.parse("${MyApp.url}/login");
                final headers = {'Content-Type': 'application/json'};
                final response = await http.post(url,
                    headers: headers,
                    body: json.encode({
                      "customerEmail": emailController.text,
                      "password": passwordController.text
                    }));
                var decoded = json.decode(response.body);
                print(decoded['isLogin']);
                empty();
                setState(() {
                  firstTime = false;
                  if (decoded['isLogin'] && !isEmpty) {
                    _function();
                    ProfilePage.logedIn = true;
                    ScaffoldMessenger.of(context).showSnackBar(snackBarSuccess);
                  } else if (emailController.text == 'amir' &&
                      passwordController.text == '12' &&
                      isAdmin) {
                    ProfilePage.isAdmin = true;
                    _function();
                    ProfilePage.logedIn = true;
                    ScaffoldMessenger.of(context).showSnackBar(snackBarSuccess);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(snackBarError);
                  }
                });
                ProfilePage.user = User(
                    'amirjavani@outlook.com',
                    'amir mahdi javani',
                    'tehran',
                    '09108511227',
                    '123',
                    'address');

                print(ProfilePage.logedIn);
              },
              child: const Text(
                "login",
                style: TextStyle(fontSize: 18),
              ),
              style: ButtonStyle(
                minimumSize: MaterialStateProperty.all(Size(130, 40)),
                elevation: MaterialStateProperty.all(0),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return SignUp(
                        changeLogedIn: _function,
                      );
                    },
                  ),
                );
              },
              child: Text(
                'SIGN UP',
                style: TextStyle(color: Colors.black),
              ),
            )
          ],
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class MainButton extends StatelessWidget {
  const MainButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(15),
      decoration: BoxDecoration(
          color: Color(0xFF1D1E33), borderRadius: BorderRadius.circular(10)),
    );
  }
}

class SignUp extends StatefulWidget {
  SignUp({Key? key, required this.changeLogedIn}) : super(key: key);
  final Function changeLogedIn;
  @override
  State<SignUp> createState() => _SignUpState(this.changeLogedIn);
}

class _SignUpState extends State<SignUp> {
  TextEditingController usernameController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  TextEditingController phoneController = TextEditingController();

  TextEditingController addressController = TextEditingController();

  TextEditingController fullNameController = TextEditingController();

  TextEditingController cityController = TextEditingController();

  final Function functionChangeLogedIn;

  _SignUpState(this.functionChangeLogedIn);

  bool firstTime = true;

  String? errorHandeler(String text) {
    if (text.isEmpty) {
      return 'required';
    } else {
      return null;
    }
  }

  bool isEmpty = true;

  void empty() {
    if (usernameController.text.isNotEmpty &&
        passwordController.text.isNotEmpty &&
        phoneController.text.isNotEmpty &&
        addressController.text.isNotEmpty &&
        fullNameController.text.isNotEmpty &&
        cityController.text.isNotEmpty) {
      isEmpty = false;
    } else {
      isEmpty = true;
    }
  }

  final snackBarError = const SnackBar(
      content: Text('can not use this email'),
      backgroundColor: Colors.redAccent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(10), topLeft: Radius.circular(10)),
        side: BorderSide(
          color: Colors.red,
        ),
      ));
  final snackBarSuccess = const SnackBar(
      content: Text('sign up success'),
      backgroundColor: Colors.greenAccent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(10), topLeft: Radius.circular(10)),
        side: BorderSide(
          color: Colors.green,
        ),
      ));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up Page'),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: Column(
            children: <Widget>[
              Text(
                'Sign Up',
                style: TextStyle(fontSize: 50),
              ),
              SizedBox(height: 10),
              TextField(
                controller: usernameController,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(),
                  errorText:
                      firstTime ? null : errorHandeler(usernameController.text),
                  labelText: 'Email',
                  hintText: 'Enter Your Email',
                  contentPadding: EdgeInsets.all(20),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.lock_outline),
                  border: OutlineInputBorder(),
                  errorText:
                      firstTime ? null : errorHandeler(passwordController.text),
                  labelText: 'Password ',
                  hintText: 'Enter Password',
                  contentPadding: EdgeInsets.all(20),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: addressController,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.house),
                  border: OutlineInputBorder(),
                  errorText:
                      firstTime ? null : errorHandeler(addressController.text),
                  labelText: 'ADRRESS',
                  hintText: 'enter your address',
                  contentPadding: EdgeInsets.all(20),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: fullNameController,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                  errorText:
                      firstTime ? null : errorHandeler(fullNameController.text),
                  labelText: 'FULLNAME',
                  hintText: 'enter your full name',
                  contentPadding: EdgeInsets.all(20),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: phoneController,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.phone_android),
                  border: OutlineInputBorder(),
                  errorText:
                      firstTime ? null : errorHandeler(phoneController.text),
                  labelText: 'PHONE',
                  hintText: 'enter your phone number',
                  contentPadding: EdgeInsets.all(20),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                controller: cityController,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.location_city),
                  border: OutlineInputBorder(),
                  errorText:
                      firstTime ? null : errorHandeler(cityController.text),
                  labelText: 'CITY',
                  hintText: 'enter your city',
                  contentPadding: EdgeInsets.all(20),
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  final Uri url = Uri.parse("${MyApp.url}/signup");
                  final headers = {'Content-Type': 'application/json'};
                  final response = await http.post(url,
                      headers: headers,
                      body: json.encode({
                        "customerFullName": fullNameController.text,
                        'phone': phoneController.text,
                        'city': cityController.text,
                        'address': addressController.text,
                        'customerEmail': usernameController.text,
                        "password": passwordController.text
                      }));
                  var decoded = json.decode(response.body);
                  empty();
                  setState(() {
                    firstTime = false;
                    if (!decoded["isExistEmail"] && !isEmpty) {
                      ProfilePage.logedIn = true;
                      functionChangeLogedIn();
                      ScaffoldMessenger.of(context)
                          .showSnackBar(snackBarSuccess);
                      ProfilePage.user = User(
                          usernameController.text,
                          fullNameController.text,
                          cityController.text,
                          phoneController.text,
                          passwordController.text,
                          addressController.text);
                      Navigator.pop(context);
                    } else if (!isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(snackBarError);
                    }
                  });
                },
                child: const Text(
                  "Sign up",
                  style: TextStyle(fontSize: 18),
                ),
                style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all(Size(130, 40)),
                  elevation: MaterialStateProperty.all(0),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('LOGIN'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
