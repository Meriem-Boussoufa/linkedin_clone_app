import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:linkedin_clone_app/jobs/jobs_screen.dart';
import 'package:linkedin_clone_app/jobs/upload_job.dart';
import 'package:linkedin_clone_app/search/profile_company.dart';
import 'package:linkedin_clone_app/search/search_companies.dart';

class BottomNavigationBarForApp extends StatelessWidget {
  int indexNum = 0;
  BottomNavigationBarForApp({super.key, required this.indexNum});

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
        } else if (index == 4) {}
      },
    );
  }
}
