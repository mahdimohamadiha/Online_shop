import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String _userName = '';
  String _Password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Text(
            'Login',
            style: TextStyle(fontSize: 50),
          ),
          SizedBox(height: 10),
          Form(
            child: Column(
              children: [
                TextField(
                  controller: usernameController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'username',
                    hintText: 'Enter Your username',
                    contentPadding: EdgeInsets.all(20),
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                    hintText: 'Enter Password',
                    contentPadding: EdgeInsets.all(20),
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () async {
              _userName = usernameController.text;
              _Password = passwordController.text;
              print('username : $_userName \n password : $_Password');
              // _futureAlbum =
              //     createAlbum(usernameController.text) as Future<Album>?;
              final Uri url = Uri.parse("http://192.168.135.63:8000/login");
              final headers = {'Content-Type': 'application/json'};
              final response = await http.post(url,
                  headers: headers,
                  body: json.encode(
                      {"customerEmail": _userName, "password": _Password}));
              var decoded = json.decode(response.body);
              print(decoded['isLogin']);
            },
            child: Text('LOGIN'),
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
            child: Text('SIGN UP'),
          )
        ],
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
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('LOGIN'),
            ),
            TextButton(
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
              child: Text('SIGN UP'),
            )
          ],
        ),
      ),
    );
  }
}
