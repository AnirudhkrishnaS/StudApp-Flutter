import 'package:flutter/material.dart';
import 'package:studapp/sendComplaints.dart';
import 'package:studapp/sendMentorReview.dart';
import 'package:studapp/viewMentors.dart';
import 'package:studapp/viewMyMentors.dart';
import 'package:studapp/viewMyMentorsSession.dart';
import 'package:studapp/viewProfile.dart';
import 'package:studapp/viewReply.dart';
import 'package:studapp/viewRequestStatus.dart';
import 'package:studapp/view_review.dart';

import 'changePassword.dart';

// function to trigger app build
void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  final appTitle = 'Flutter Drawer Demo';

  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Login'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
        backgroundColor: Colors.green,
      ),
      body: const Center(
          child: Text(
        '',
        style: TextStyle(fontSize: 20.0),
      )),
      drawer: Drawer(
        child: ListView(
          padding: const EdgeInsets.all(0),
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.green,
              ), //BoxDecoration
              child: UserAccountsDrawerHeader(
                decoration: BoxDecoration(color: Colors.green),
                accountName: Text(
                  "Name",
                  style: TextStyle(fontSize: 18),
                ),
                accountEmail: Text("email"),
                currentAccountPictureSize: Size.square(50),
                currentAccountPicture: CircleAvatar(
                  backgroundColor: Color.fromARGB(255, 165, 255, 137),
                  child: Text(
                    "A",
                    style: TextStyle(fontSize: 30.0, color: Colors.blue),
                  ), //Text
                ), //circleAvatar
              ), //UserAccountDrawerHeader
            ), //DrawerHeader
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text(' My Profile '),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ViewProfilePage(
                        title: "login",
                      ),
                    ));
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('View Mentors'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ViewMentorPage(
                        title: "login",
                      ),
                    ));
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('View Request Status'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => viewRequestStatus(
                        title: "View request status",
                      ),
                    ));
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('View My Mentors'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => viewMyMentorsPage(
                        title: "",
                      ),
                    ));
              },
            ),
            ListTile(
              leading: const Icon(Icons.book),
              title: const Text(' Send complaint '),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => mySendComplaintPage(
                        title: "login",
                      ),
                    ));
              },
            ),
            ListTile(
              leading: const Icon(Icons.book),
              title: const Text(' View Reply'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ViewReplyPage(
                        title: "View Reply",
                      ),
                    ));
              },
            ),
            ListTile(
              leading: const Icon(Icons.workspace_premium),
              title: const Text(' change password '),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChangePasswordPage(
                        title: "change password",
                      ),
                    ));
              },
            ),
            ListTile(
              leading: const Icon(Icons.video_label),
              title: const Text(' Send App review '),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => View_Rating(
                        title: "login",
                      ),
                    ));
              },
            ),
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text(' Send Mentor review '),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SendMentorRating(
                        title: "login",
                      ),
                    ));
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('View Sessions'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => viewMyMentorsSessionPage(
                        title: "session",
                      ),
                    ));
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('LogOut'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ), //Drawer
    );
  }
}
