import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:linkedin_clone_app/persistent/persistent.dart';
import 'package:linkedin_clone_app/services/global_mathods.dart';
import 'package:linkedin_clone_app/services/global_variables.dart';
import 'package:linkedin_clone_app/widgets/bottomNavBar.dart';
import 'package:uuid/uuid.dart';

class UploadJobNow extends StatefulWidget {
  const UploadJobNow({super.key});

  @override
  State<UploadJobNow> createState() => _UploadJobNowState();
}

class _UploadJobNowState extends State<UploadJobNow> {
  final TextEditingController jobCategoryController =
      TextEditingController(text: 'Select Job Category');
  final TextEditingController jobTitleController = TextEditingController();
  final TextEditingController jobDescriptionController =
      TextEditingController();
  final TextEditingController deadLineDateController =
      TextEditingController(text: 'Job Deadline Date');

  final formKey = GlobalKey<FormState>();
  DateTime? picked;
  Timestamp? deadlineDateTimeStamp;
  bool isLoading = false;

  @override
  void dispose() {
    super.dispose();
    jobCategoryController.dispose();
    jobTitleController.dispose();
    jobDescriptionController.dispose();
    deadLineDateController.dispose();
  }

  void _uploadJob() async {
    final jobID = const Uuid().v4();
    User? user = FirebaseAuth.instance.currentUser;
    final uid = user!.uid;
    final isValid = formKey.currentState!.validate();
    if (isValid) {
      if (deadLineDateController.text == 'Choose task Deadline date' ||
          jobCategoryController.text == 'Choose task catgeory') {
        GlobalMethod.showErrorDialog(
            error: 'Please pick everything', ctx: context);
        return;
      }
      setState(() {
        isLoading = true;
      });
      try {
        await FirebaseFirestore.instance.collection('jobs').doc(jobID).set({
          'jobId': jobID,
          'uploadedBy': uid,
          'email': user.email,
          'jobTitle': jobTitleController.text,
          'jobDescription': jobDescriptionController.text,
          'deadlineDate': deadlineDateTimeStamp,
          'deadlineDateTimeStamp': deadLineDateController.text,
          'jobCategory': jobCategoryController.text,
          'jobComments': [],
          'recruitment': true,
          'createdAt': Timestamp.now(),
          'name': name,
          'userImage': userImage,
          'location': location,
          'applicants': 0,
        });
        await Fluttertoast.showToast(
          msg: 'The task has been uploaded',
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: Colors.grey,
          fontSize: 18,
        );
        jobTitleController.clear();
        jobDescriptionController.clear();
        setState(() {
          jobCategoryController.text = 'Choose job category';
          deadLineDateController.text = 'Choose job Deadline date';
        });
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    } else {
      log('It is not valid');
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      bottomNavigationBar: BottomNavigationBarForApp(indexNum: 2),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(7),
          child: Card(
            color: Colors.white10,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  const Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Please fill all Fields',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Divider(thickness: 1),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Form(
                        key: formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _textTitles(lable: "Job Category"),
                            _textFormFields(
                              valueKey: 'TaskCategory',
                              controller: jobCategoryController,
                              enabled: false,
                              fct: () {
                                _showTaskCategoriesDialog(size: size);
                              },
                              maxLength: 100,
                            ),
                            _textTitles(lable: "Job Title :"),
                            _textFormFields(
                              valueKey: 'jobTitle',
                              controller: jobTitleController,
                              enabled: true,
                              fct: () {},
                              maxLength: 100,
                            ),
                            _textTitles(lable: "Job Description :"),
                            _textFormFields(
                              valueKey: 'jobDescription',
                              controller: jobDescriptionController,
                              enabled: true,
                              fct: () {},
                              maxLength: 100,
                            ),
                            _textTitles(lable: "Job Deadline Date :"),
                            _textFormFields(
                              valueKey: 'JobDeadline',
                              controller: deadLineDateController,
                              enabled: false,
                              fct: () {
                                log('### Pressed Deadline Field ###');
                                _pickDateDialog();
                              },
                              maxLength: 100,
                            ),
                          ],
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 30),
                    child: isLoading
                        ? const CircularProgressIndicator()
                        : Center(
                            child: SizedBox(
                              width: 200,
                              child: MaterialButton(
                                onPressed: _uploadJob,
                                color: Colors.black,
                                elevation: 8,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(13)),
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 14),
                                  child: Row(children: [
                                    Text(
                                      'Post Now',
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    Icon(
                                      Icons.upload_file,
                                      color: Colors.white,
                                    )
                                  ]),
                                ),
                              ),
                            ),
                          ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _textFormFields({
    required String valueKey,
    required TextEditingController controller,
    required bool enabled,
    required Function fct,
    required int maxLength,
  }) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: InkWell(
        onTap: () {
          fct();
        },
        child: TextFormField(
          validator: (value) {
            if (value!.isEmpty) {
              return 'Value is missing';
            }
            return null;
          },
          controller: controller,
          enabled: enabled,
          key: ValueKey(valueKey),
          style: const TextStyle(
            color: Colors.white,
          ),
          // ignore: unrelated_type_equality_checks
          maxLines: ValueKey == 'TaskDescription' ? 3 : 1,
          maxLength: maxLength,
          keyboardType: TextInputType.text,
          decoration: const InputDecoration(
            filled: true,
            fillColor: Colors.grey,
            enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white10)),
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white)),
            errorBorder:
                UnderlineInputBorder(borderSide: BorderSide(color: Colors.red)),
          ),
        ),
      ),
    );
  }

  _showTaskCategoriesDialog({required Size size}) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.black,
            title: const Text(
              'Job Category',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
              ),
            ),
            content: SizedBox(
              width: size.width * 0.9,
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: Persistent.taskCategoryList.length,
                  itemBuilder: (contetx, index) {
                    return InkWell(
                      onTap: () {
                        setState(() {
                          jobCategoryController.text =
                              Persistent.taskCategoryList[index];
                        });
                        Navigator.pop(context);
                      },
                      child: Row(
                        children: [
                          const Icon(
                            Icons.arrow_right_alt_outlined,
                            color: Colors.grey,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              Persistent.taskCategoryList[index],
                              style: const TextStyle(
                                  color: Colors.grey, fontSize: 16),
                            ),
                          )
                        ],
                      ),
                    );
                  }),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ))
            ],
          );
        });
  }

  void _pickDateDialog() async {
    log('### Pick Date ###');
    picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now().subtract(const Duration(days: 0)),
        lastDate: DateTime(2100));
    if (picked != null) {
      setState(() {
        deadLineDateController.text =
            '${picked!.year}-${picked!.month}-${picked!.day}';
        deadlineDateTimeStamp = Timestamp.fromMicrosecondsSinceEpoch(
            picked!.microsecondsSinceEpoch);
      });
    }
  }

  Widget _textTitles({required String lable}) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Text(
        lable,
        style: const TextStyle(
          color: Colors.grey,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
