import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:linkedin_clone_app/persistent/persistent.dart';
import 'package:linkedin_clone_app/widgets/bottomNavBar.dart';

class UploadJobNow extends StatefulWidget {
  const UploadJobNow({super.key});

  @override
  State<UploadJobNow> createState() => _UploadJobNowState();
}

class _UploadJobNowState extends State<UploadJobNow> {
  final TextEditingController taskCategoryController =
      TextEditingController(text: 'Select Job Category');
  final TextEditingController taskTitleController = TextEditingController();
  final TextEditingController taskDescriptionController =
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
    taskCategoryController.dispose();
    taskTitleController.dispose();
    taskDescriptionController.dispose();
    deadLineDateController.dispose();
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
                crossAxisAlignment: CrossAxisAlignment.start,
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
                          children: [],
                        )),
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
        onTap: () {},
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
            content: Container(
              width: size.width * 0.9,
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: Persistent.taskCategoryList.length,
                  itemBuilder: (contetx, index) {
                    return InkWell(
                      onTap: () {
                        setState(() {
                          taskCategoryController.text =
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
