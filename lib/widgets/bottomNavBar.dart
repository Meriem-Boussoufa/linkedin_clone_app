import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:linkedin_clone_app/jobs/jobs_screen.dart';
import 'package:linkedin_clone_app/jobs/upload_job.dart';
import 'package:linkedin_clone_app/search/profile_company.dart';
import 'package:linkedin_clone_app/search/search_companies.dart';
import 'package:linkedin_clone_app/user_state.dart';

class BottomNavigationBarForApp extends StatelessWidget {
  int indexNum = 0;
  BottomNavigationBarForApp({super.key, required this.indexNum});

  void _logout(context) {
    final FirebaseAuth _auth = FirebaseAuth.instance;

    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.black,
            title: const Row(children: [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(
                  Icons.logout,
                  color: Colors.white70,
                  size: 36,
                ),
              ),
              Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Sign Out ',
                    style: TextStyle(color: Colors.grey, fontSize: 28),
                  )),
            ]),
            content: const Text(
              'Do you want to Log Out from App ?',
              style: TextStyle(color: Colors.grey, fontSize: 20),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('No',
                      style: TextStyle(color: Colors.green, fontSize: 18))),
              TextButton(
                  onPressed: () {
                    _auth.signOut();
                    Navigator.pop(context);
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const UserState()));
                  },
                  child: const Text('Yes',
                      style: TextStyle(color: Colors.red, fontSize: 18))),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return CurvedNavigationBar(
      color: Colors.white,
      backgroundColor: Colors.black,
      buttonBackgroundColor: Colors.white,
      height: 52,
      index: indexNum,
      items: const [
        Icon(Icons.list, size: 18, color: Colors.blue),
        Icon(Icons.search, size: 18, color: Colors.blue),
        Icon(Icons.add, size: 18, color: Colors.blue),
        Icon(Icons.person_pin, size: 18, color: Colors.blue),
        Icon(Icons.exit_to_app, size: 18, color: Colors.blue),
      ],
      animationDuration: const Duration(milliseconds: 300),
      animationCurve: Curves.bounceInOut,
      onTap: (index) {
        if (index == 0) {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const JobsScreen()));
        } else if (index == 1) {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const AllWorksScreen()));
        } else if (index == 2) {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const UploadJobNow()));
        } else if (index == 3) {
          final FirebaseAuth _auth = FirebaseAuth.instance;
          final User? user = _auth.currentUser;
          final String uid = user!.uid;
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => ProfileCompanyScreen(userID: uid)));
        } else if (index == 4) {
          _logout(context);
        }
      },
    );
  }
}
