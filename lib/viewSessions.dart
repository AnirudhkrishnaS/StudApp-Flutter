import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:studapp/sendComplaints.dart';

void main() {
  runApp(const viewSession());
}

class viewSession extends StatelessWidget {
  const viewSession({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'View Reply',
      theme: ThemeData(
        colorScheme:
            ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 18, 82, 98)),
        useMaterial3: true,
      ),
      home: const viewSessionPage(title: 'View Reply'),
    );
  }
}

class viewSessionPage extends StatefulWidget {
  const viewSessionPage({super.key, required this.title});

  final String title;

  @override
  State<viewSessionPage> createState() => _viewSessionPageState();
}

class _viewSessionPageState extends State<viewSessionPage> {
  _viewSessionPageState() {
    viewSession();
  }

  List<String> id_ = <String>[];
  List<String> date_ = <String>[];
  List<String> fromTime_ = <String>[];
  List<String> toTime_ = <String>[];
  List<String> title_ = <String>[];
  List<String> document_ = <String>[];

  Future<void> viewSession() async {
    List<String> id = <String>[];
    List<String> date = <String>[];
    List<String> fromTime = <String>[];
    List<String> toTime = <String>[];
    List<String> title = <String>[];
    List<String> document = <String>[];

    try {
      SharedPreferences sh = await SharedPreferences.getInstance();
      String urls = sh.getString('url').toString();
      String lid = sh.getString('lid').toString();
      String mid = sh.getString('mid').toString();
      String url = '$urls/and_viewSession/';

      var data = await http.post(Uri.parse(url), body: {
        'lid': lid,
        'mid': mid,
      });
      var jsondata = json.decode(data.body);
      String statuss = jsondata['status'];

      var arr = jsondata["data"];

      print(arr.length);

      for (int i = 0; i < arr.length; i++) {
        id.add(arr[i]['id'].toString());
        date.add(arr[i]['date']);
        fromTime.add(arr[i]['from_time']);
        toTime.add(arr[i]['to_time']);
        title.add(arr[i]['title']);
        document.add(arr[i]['document']);
      }

      setState(() {
        id_ = id;
        date_ = date;
        fromTime_ = fromTime;
        toTime_ = toTime;
        title_ = title;
        document_ = document;
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
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) => HomeNew()),
              // );
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
                                  Text("from date"),
                                  Text(fromTime_[index]),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(5),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("to date"),
                                  Text(toTime_[index]),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(5),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("title"),
                                  Text(title_[index]),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(5),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("document"),
                                  Text(document_[index]),
                                ],
                              ),
                            ),
                          ],
                        ),
                        elevation: 8,
                        margin: EdgeInsets.all(10),
                      ),
                    ],
                  )),
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => mySendComplaint()));
          },
          child: Icon(Icons.plus_one),
        ),
      ),
    );
  }
}
