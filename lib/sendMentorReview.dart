import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:studapp/userhome.dart';
import 'package:studapp/viewRequestStatus.dart';
import 'package:studapp/view_review.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const SendMentorRating(title: 'Flutter Demo Home Page'),
    );
  }
}

class SendMentorRating extends StatefulWidget {
  const SendMentorRating({super.key, required this.title});

  final String title;

  @override
  State<SendMentorRating> createState() => _SendMentorRatingState();
}

class _SendMentorRatingState extends State<SendMentorRating> {
  final reviewcontroller = TextEditingController();
  final _formKey = new GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Form(
          key: _formKey,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                RatingBar.builder(
                  initialRating: 1,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                  itemBuilder: (context, _) => Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: (rating) {
                    ratings = rating;
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    validator: (value) => Validatereview(value!),
                    controller: reviewcontroller,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(), labelText: "Review"),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _send_data();
                      }
                    },
                    child: Text("Send"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  double ratings = 1;

  void _send_data() async {
    String review = reviewcontroller.text;

    SharedPreferences sh = await SharedPreferences.getInstance();
    String url = sh.getString('url').toString();

    final urls = Uri.parse('$url/and_sendMentorReview/');
    try {
      final response = await http.post(urls, body: {
        'review': review,
        'rating': ratings.toString(),
        'lid': sh.getString('lid').toString(),
        'mid': sh.getString('mid').toString(),
      });
      if (response.statusCode == 200) {
        String status = jsonDecode(response.body)['status'];
        if (status == 'ok') {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => viewRequestStatus(title: "Home"),
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

String? Validatereview(String value) {
  if (value.isEmpty) {
    return "Please enter Review";
  }
  return null;
}
