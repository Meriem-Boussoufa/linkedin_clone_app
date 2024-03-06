import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:linkedin_clone_app/auth/login.dart';
import 'package:linkedin_clone_app/jobs/jobs_screen.dart';
import 'package:linkedin_clone_app/jobs/upload_job.dart';

class UserState extends StatelessWidget {
  const UserState({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (ctx, userSnapshot) {
          if (userSnapshot.data == null) {
            log('User is not logged in yet');
            return const LoginScreen();
          } else if (userSnapshot.hasData) {
            log('user is already logged in');
            return const UploadJobNow();
          } else if (userSnapshot.hasError) {
            return const Scaffold(
              body: Center(
                child: Text('An Error has been occured. Try again later'),
              ),
            );
          } else if (userSnapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          return const Scaffold(
            body: Center(
              child: Text('Something went wrong'),
            ),
          );
        });
  }
}
