import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:studapp/signUp.dart';
import 'package:studapp/userhome.dart';

import 'login.dart';
import 'main.dart';

void main() {
  runApp(const MyLogin());
}

class MyLogin extends StatelessWidget {
  const MyLogin({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const ChangePasswordPage(title: 'Login'),
    );
  }
}

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key, required this.title});

  final String title;

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  TextEditingController oldPasswordController = new TextEditingController();
  TextEditingController newPasswordController = new TextEditingController();
  TextEditingController confirmNewPasswordController =
      new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8),
                child: TextField(
                  controller: oldPasswordController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      label: Text("old password")),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: TextField(
                  controller: newPasswordController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      label: Text("New password")),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: TextField(
                  controller: confirmNewPasswordController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      label: Text("confirm new Password")),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  _send_data();
                },
                child: Text("change password"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _send_data() async {
    String oldPassword = oldPasswordController.text;
    String newPassword = newPasswordController.text;
    String confirmnewPassword = confirmNewPasswordController.text;

    SharedPreferences sh = await SharedPreferences.getInstance();
    String url = sh.getString('url').toString();
    String lid = sh.getString('lid').toString();

    final urls = Uri.parse('$url/and_changePassword/');
    try {
      final response = await http.post(urls, body: {
        'oldPassword': oldPassword,
        'newPassword': newPassword,
        'confirmPassword': confirmnewPassword,
        'lid': lid
      });
      if (response.statusCode == 200) {
        String status = jsonDecode(response.body)['status'];
        if (status == 'ok') {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MyLoginPage(
                  title: "login",
                ),
              ));
        } else {
          Fluttertoast.showToast(msg: 'Not Found');
        }
      } else {
        Fluttertoast.showToast(msg: 'Network Error');
      }
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }
}
