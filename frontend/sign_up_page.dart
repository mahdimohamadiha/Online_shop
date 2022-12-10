import 'package:flutter/material.dart';

class sign_up_page extends StatefulWidget {
  const sign_up_page({Key? key}) : super(key: key);

  @override
  State<sign_up_page> createState() => _sign_up_pageState();
}

class _sign_up_pageState extends State<sign_up_page> {
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
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'username',
                hintText: 'Enter Your username',
                contentPadding: EdgeInsets.all(20),
              ),
            ),
            SizedBox(height: 10),
            TextField(
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
              obscureText: true,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Password again',
                hintText: 'Enter Password again',
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
              onPressed: () {},
              child: Text('SIGN UP'),
            )
          ],
        ),
      ),
    );
  }
}
