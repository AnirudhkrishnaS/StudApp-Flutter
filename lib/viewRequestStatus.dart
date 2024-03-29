import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:studapp/sendComplaints.dart';
import 'package:studapp/sendMentorReview.dart';
import 'package:studapp/userhome.dart';

void main() {
  runApp(const ViewReply());
}

class ViewReply extends StatelessWidget {
  const ViewReply({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'View Reply',
      theme: ThemeData(
        colorScheme:
            ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 18, 82, 98)),
        useMaterial3: true,
      ),
      home: const viewRequestStatus(title: 'View Reply'),
    );
  }
}

class viewRequestStatus extends StatefulWidget {
  const viewRequestStatus({super.key, required this.title});

  final String title;

  @override
  State<viewRequestStatus> createState() => _viewRequestStatusState();
}

class _viewRequestStatusState extends State<viewRequestStatus> {
  _viewRequestStatusState() {
    viewreply();
  }

  List<String> id_ = <String>[];
  List<String> mid_ = <String>[];
  List<String> date_ = <String>[];
  List<String> status_ = <String>[];
  List<String> mentorName_ = <String>[];

  Future<void> viewreply() async {
    List<String> id = <String>[];
    List<String> mid = <String>[];
    List<String> date = <String>[];
    List<String> status = <String>[];
    List<String> mentorName = <String>[];

    try {
      SharedPreferences sh = await SharedPreferences.getInstance();
      String urls = sh.getString('url').toString();
      String lid = sh.getString('lid').toString();
      String url = '$urls/and_viewRequestStatus/';

      var data = await http.post(Uri.parse(url), body: {'lid': lid});
      var jsondata = json.decode(data.body);
      String statuss = jsondata['status'];

      var arr = jsondata["data"];

      print(arr.length);

      for (int i = 0; i < arr.length; i++) {
        id.add(arr[i]['id'].toString());
        mid.add(arr[i]['mid'].toString());
        date.add(arr[i]['date']);
        status.add(arr[i]['status']);
        mentorName.add(arr[i]['mentorName']);
      }

      setState(() {
        id_ = id;
        mid_ = mid;
        date_ = date;
        status_ = status;
        mentorName_ = mentorName;
      });

      print(statuss);
    } catch (e) {
      print("Error ------------------- " + e.toString());
      //there is error during converting file image to base64 encoding.
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          leading: BackButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => MyHomePage(
                          title: '',
                        )),
              );
            },
          ),
          backgroundColor: Theme.of(context).colorScheme.primary,
          title: Text(widget.title),
        ),
        body: ListView.builder(
          physics: BouncingScrollPhysics(),
          // padding: EdgeInsets.all(5.0),
          // shrinkWrap: true,
          itemCount: id_.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              onLongPress: () {
                print("long press" + index.toString());
              },
              title: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Card(
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.all(5),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Date"),
                                  Text(date_[index]),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(5),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("status"),
                                  Text(status_[index]),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(5),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Mentor name"),
                                  Text(mentorName_[index]),
                                ],
                              ),
                            ),
                            if (status_[index] == 'approved') ...{}
                          ],
                        ),
                      ),
                    ],
                  )),
            );
          },
        ),
      ),
    );
  }
}
