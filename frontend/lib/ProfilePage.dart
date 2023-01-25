import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:online_shop/user.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);
  @override
  State<ProfilePage> createState() => _ProfilePageState();
  static bool logedIn = false;
  static User user =
      User('email', 'fullName', 'city', 'phone', 'password', 'address');
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    if (ProfilePage.logedIn) {
      return Userprofile(onLogedIn: () {
        setState(() {});
      });
    } else {
      return LoginPage(
        onLogedIn: () {
          setState(() {});
        },
      );
    }
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
              onPressed: () {
                // final Uri url = Uri.parse("http://192.168.135.63:8000/login");
                // final headers = {'Content-Type': 'application/json'};
                // final response = await http.post(url,
                //     headers: headers,
                //     body: json.encode({
                //       "customerEmail": emailController.text,
                //       "password": passwordController.text
                //     }));
                // var decoded = json.decode(response.body);
                // print(decoded['isLogin']);
                setState(() {
                  firstTime = false;
                  if (emailController.text == 'amir' &&
                      passwordController.text == '123') {
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
                      return SignUp();
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

class SignUp extends StatelessWidget {
  SignUp({Key? key}) : super(key: key);
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController fullNameController = TextEditingController();
  TextEditingController cityController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up Page'),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
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
                border: OutlineInputBorder(),
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
                border: OutlineInputBorder(),
                labelText: 'Password ',
                hintText: 'Enter Password',
                contentPadding: EdgeInsets.all(20),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: addressController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'ADRRESS',
                hintText: 'ADRRESS',
                contentPadding: EdgeInsets.all(20),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: fullNameController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'FULLNAME',
                hintText: 'FULLNAME',
                contentPadding: EdgeInsets.all(20),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: phoneController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'PHONE',
                hintText: 'PHONE',
                contentPadding: EdgeInsets.all(20),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: cityController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'CITY',
                hintText: 'City',
                contentPadding: EdgeInsets.all(20),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                // _futureAlbum =
                //     createAlbum(usernameController.text) as Future<Album>?;
                // final Uri url = Uri.parse("http://10.0.2.2:8000/signup");
                final Uri url = Uri.parse("http://192.168.135.63:8000/signup");
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
                print(decoded['isExistEmail']);
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
    );
  }
}
