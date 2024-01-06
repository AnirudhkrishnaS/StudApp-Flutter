import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const mySendComplaint());
}

class mySendComplaint extends StatelessWidget {
  const mySendComplaint({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SendComplaint',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const mySendComplaintPage(title: 'SendComplaint'),
    );
  }
}

class mySendComplaintPage extends StatefulWidget {
  const mySendComplaintPage({super.key, required this.title});

  final String title;

  @override
  State<mySendComplaintPage> createState() => _mySendComplaintPageState();
}

class _mySendComplaintPageState extends State<mySendComplaintPage> {
  TextEditingController complaintController = new TextEditingController();

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
                  controller: complaintController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), label: Text("complaint")),
                ),
              ),
              ElevatedButton(
                onPressed: () {},
                child: Text("SendComplaint"),
              ),
              TextButton(
                onPressed: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => SignUpPage()),
                  // );
                },
                child: Text("Signup"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _send_data() async {
    String complaint = complaintController.text;

    SharedPreferences sh = await SharedPreferences.getInstance();
    String url = sh.getString('url').toString();

    final urls = Uri.parse('$url/myapp/user_SendComplaintpost/');
    try {
      final response = await http.post(urls, body: {
        'complaint': complaint,
      });
      if (response.statusCode == 200) {
        String status = jsonDecode(response.body)['status'];
        if (status == 'ok') {
          String lid = jsonDecode(response.body)['lid'];
          sh.setString("lid", lid);

          // Navigator.push(
          //     context,
          //     MaterialPageRoute(
          //       builder: (context) => MyHomePage(title: "Home"),
          //     )
          // );
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
