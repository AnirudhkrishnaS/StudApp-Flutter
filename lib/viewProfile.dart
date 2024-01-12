import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'editProfile.dart';

void main() {
  runApp(const ViewProfile());
}

class ViewProfile extends StatelessWidget {
  const ViewProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'View Profile',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const ViewProfilePage(title: 'View Profile'),
    );
  }
}

class ViewProfilePage extends StatefulWidget {
  const ViewProfilePage({super.key, required this.title});

  final String title;

  @override
  State<ViewProfilePage> createState() => _ViewProfilePageState();
}

class _ViewProfilePageState extends State<ViewProfilePage> {
  _ViewProfilePageState() {
    _get_data();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          leading: BackButton(onPressed: () {

          }),
          backgroundColor: Theme
              .of(context)
              .colorScheme
              .primary,
          title: Text(widget.title),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // CircleAvatar(
              //   radius: 50,
              // ),
              Column(
                children: [
                  Image(
                    image: NetworkImage(photo_),
                    height: 200,
                    width: 200,
                  ),
                  Padding(
                    padding: EdgeInsets.all(5),
                    child: Text(name_),
                  ),
                  Padding(
                    padding: EdgeInsets.all(5),
                    child: Text(dob_),
                  ),
                  Padding(
                    padding: EdgeInsets.all(5),
                    child: Text(gender_),
                  ),
                  Padding(
                    padding: EdgeInsets.all(5),
                    child: Text(email_),
                  ),
                  Padding(
                    padding: EdgeInsets.all(5),
                    child: Text(phone_),
                  ),
                  Padding(
                    padding: EdgeInsets.all(5),
                    child: Text(state_),
                  ),
                  Padding(
                    padding: EdgeInsets.all(5),
                    child: Text(post_),
                  ),
                  Padding(
                    padding: EdgeInsets.all(5),
                    child: Text(city_),
                  ),
                  Padding(
                    padding: EdgeInsets.all(5),
                    child: Text(pincode_),
                  ),
                  Padding(
                    padding: EdgeInsets.all(5),
                    child: Text(CurrentlyCourse_),
                  ),
                  Padding(
                    padding: EdgeInsets.all(5),
                    child: Text(district_),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MyEditPage(title: "Edit Profile"),
                      ));
                },
                child: Text("Edit Profile"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String name_ = "";
  String dob_ = "";
  String gender_ = "";
  String email_ = "";
  String phone_ = "";
  String state_ = "";
  String post_ = "";
  String city_ = "";
  String pincode_ = "";
  String district_ = "";
  String photo_ = "";
  String CurrentlyCourse_ = "";

  void _get_data() async {
    SharedPreferences sh = await SharedPreferences.getInstance();
    String url = sh.getString('url').toString();
    String lid = sh.getString('lid').toString();
    String img_url = sh.getString('img_url').toString();

    final urls = Uri.parse('$url/and_viewProfile/');
    try {
      final response = await http.post(urls, body: {'lid': lid});
      if (response.statusCode == 200) {
        String status = jsonDecode(response.body)['status'];
        if (status == 'ok') {
          String name = jsonDecode(response.body)['name'];
          print(name);
          String dob = jsonDecode(response.body)['dob'].toString();
          String gender = jsonDecode(response.body)['gender'];
          String email = jsonDecode(response.body)['email'];
          String phone = jsonDecode(response.body)['phone'].toString();
          String state = jsonDecode(response.body)['state'];
          String city = jsonDecode(response.body)['city'];

          String post = jsonDecode(response.body)['post'];
          String pincode = jsonDecode(response.body)['pincode'].toString();
          String district = jsonDecode(response.body)['district'];
          String currentlyCourse =
          jsonDecode(response.body)['Currently_course'];
          String photo =
              img_url + jsonDecode(response.body)['photo'].toString();

          setState(() {
            name_ = name;
            print(name_);
            dob_ = dob;
            gender_ = gender;
            email_ = email;
            phone_ = phone;
            state_ = state;
            post_ = post;
            city_ = city;
            pincode_ = pincode;
            district_ = district;
            photo_ = photo;
            CurrentlyCourse_ = currentlyCourse;
          });
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
