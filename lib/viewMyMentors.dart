import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:studapp/sendComplaints.dart';
import 'package:studapp/sendMentorReview.dart';
import 'package:studapp/userhome.dart';
import 'package:studapp/viewMentorDetail.dart';

import 'chat.dart';

void main() {
  runApp(const viewMyMentors());
}

class viewMyMentors extends StatelessWidget {
  const viewMyMentors({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'View Mentors',
      theme: ThemeData(
        colorScheme:
            ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 18, 82, 98)),
        useMaterial3: true,
      ),
      home: const viewMyMentorsPage(title: 'View Reply'),
    );
  }
}

class viewMyMentorsPage extends StatefulWidget {
  const viewMyMentorsPage({super.key, required this.title});

  final String title;

  @override
  State<viewMyMentorsPage> createState() => _viewMyMentorsPageState();
}

class _viewMyMentorsPageState extends State<viewMyMentorsPage> {
  _viewMyMentorsPageState() {
    viewMyMentors();
  }

  List<String> id_ = <String>[];
  List<String> photo_ = <String>[];
  List<String> name_ = <String>[];
  List<String> course_ = <String>[];
  List<String> mlid_ = <String>[];

  Future<void> viewMyMentors() async {
    List<String> id = <String>[];
    List<String> photo = <String>[];
    List<String> name = <String>[];
    List<String> course = <String>[];
    List<String> mlid = <String>[];

    try {
      SharedPreferences sh = await SharedPreferences.getInstance();
      String urls = sh.getString('url').toString();
      String lid = sh.getString('lid').toString();
      String url = '$urls/and_viewMyMentors/';

      var data = await http.post(Uri.parse(url), body: {'lid': lid});
      var jsondata = json.decode(data.body);
      String statuss = jsondata['status'];

      var arr = jsondata["data"];

      print(arr.length);

      for (int i = 0; i < arr.length; i++) {
        id.add(arr[i]['id'].toString());
        photo.add(sh.getString("img_url").toString() + arr[i]['photo']);
        name.add(arr[i]['name']);
        course.add(arr[i]['course']);
        mlid.add(arr[i]['mlid'].toString());
      }

      setState(() {
        id_ = id;
        photo_ = photo;
        name_ = name;
        course_ = course;
        mlid_ = mlid;
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
                            CircleAvatar(
                                backgroundImage: NetworkImage(photo_[index]),
                                radius: 100),
                            Padding(
                              padding: EdgeInsets.all(5),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("name"),
                                  Text(name_[index]),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(5),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Course"),
                                  Text(course_[index]),
                                ],
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                final sh =
                                    await SharedPreferences.getInstance();
                                sh.setString(('mid'), mlid_[index]);
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => MyChatPage(
                                        title: "chat",
                                      ),
                                    ));
                              },
                              child: Text("Chat"),
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                SharedPreferences sh =
                                    await SharedPreferences.getInstance();
                                sh.setString("mid", id_[index]).toString();
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SendMentorRating(
                                        title: "mentor rating",
                                      ),
                                    ));
                              },
                              child: Text("send review"),
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
      ),
    );
  }
}
