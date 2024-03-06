import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:linkedin_clone_app/jobs/job_details.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:linkedin_clone_app/services/global_mathods.dart';

class JobWidget extends StatefulWidget {
  final String taskTitle;
  final String taskId;
  final String taskDescription;
  final String uploadedBy;
  final String userImage;
  final String name;
  final bool recruitment;
  final String email;
  final String location;
  const JobWidget(
      {super.key,
      required this.taskTitle,
      required this.taskId,
      required this.uploadedBy,
      required this.userImage,
      required this.name,
      required this.recruitment,
      required this.email,
      required this.location,
      required this.taskDescription});

  @override
  State<JobWidget> createState() => _JobWidgetState();
}

class _JobWidgetState extends State<JobWidget> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white10,
      elevation: 8,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: ListTile(
        onTap: () {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => JobDetailsScreen(
                        uploadedBy: widget.uploadedBy,
                        taskID: widget.taskId,
                      )));
        },
        onLongPress: _deleteDialog,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        leading: Container(
          padding: const EdgeInsets.only(right: 12),
          decoration:
              const BoxDecoration(border: Border(right: BorderSide(width: 1))),
          child: Image.network(widget.userImage),
        ),
        title: Text(
          widget.taskTitle,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style:
              const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              widget.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.taskDescription,
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        trailing: const Icon(
          Icons.keyboard_arrow_right,
          size: 30,
          color: Colors.grey,
        ),
      ),
    );
  }

  _deleteDialog() {
    User? user = _auth.currentUser;
    final uid = user!.uid;
    showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            actions: [
              TextButton(
                  onPressed: () async {
                    try {
                      if (widget.uploadedBy == uid) {
                        await FirebaseFirestore.instance
                            .collection('tasks')
                            .doc(widget.taskId)
                            .delete();
                        await Fluttertoast.showToast(
                            msg: "Task has been deleted",
                            toastLength: Toast.LENGTH_LONG,
                            backgroundColor: Colors.grey,
                            fontSize: 18);
                        // ignore: use_build_context_synchronously
                        Navigator.pop(context);
                      } else {
                        GlobalMethod.showErrorDialog(
                            error: "You cannot perform this action", ctx: ctx);
                      }
                    } catch (error) {
                      // ignore: use_build_context_synchronously
                      GlobalMethod.showErrorDialog(
                          error: "this task cant be deleted", ctx: ctx);
                    } finally {}
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                      Text(
                        'Delete',
                        style: TextStyle(color: Colors.red),
                      )
                    ],
                  )),
            ],
          );
        });
  }
}
