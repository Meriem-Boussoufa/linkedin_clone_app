import 'package:flutter/material.dart';

class JobDetailsScreen extends StatefulWidget {
  const JobDetailsScreen(
      {super.key, required this.uploadedBy, required this.taskID});
  final String uploadedBy;
  final String taskID;

  @override
  State<JobDetailsScreen> createState() => _JobDetailsScreenState();
}

class _JobDetailsScreenState extends State<JobDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
