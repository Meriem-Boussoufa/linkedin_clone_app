import 'package:flutter/material.dart';
import 'package:linkedin_clone_app/search/profile_company.dart';
import 'package:url_launcher/url_launcher.dart';

class AllWorkersWidget extends StatefulWidget {
  final String userId;
  final String userName;
  final String useremail;
  final String phoneNumber;
  final String userImageUrl;
  const AllWorkersWidget(
      {super.key,
      required this.userId,
      required this.userName,
      required this.useremail,
      required this.phoneNumber,
      required this.userImageUrl});

  @override
  State<AllWorkersWidget> createState() => _AllWorkersWidgetState();
}

class _AllWorkersWidgetState extends State<AllWorkersWidget> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      color: Colors.white10,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      child: ListTile(
        onTap: () {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => ProfileCompanyScreen(
                        userID: widget.userId,
                      )));
        },
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        leading: Container(
          padding: const EdgeInsets.only(right: 12),
          decoration: const BoxDecoration(
            border: Border(right: BorderSide(width: 1)),
          ),
          child: CircleAvatar(
            backgroundColor: Colors.transparent,
            radius: 20,
            // ignore: unnecessary_null_comparison, prefer_if_null_operators
            child: Image.network(widget.userImageUrl == null
                ? 'https://external-preview.redd.it/5kh5OreeLd85QsqYO1Xz_4XSLYwZntfjqou-8fyBFoE.png?auto=webp&s=dbdabd04c399ce9c761ff899f5d38656d1de87c2'
                : widget.userImageUrl),
          ),
        ),
        title: Text(
          widget.userName,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style:
              const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        subtitle: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'Visit Profile',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
        trailing: IconButton(
            onPressed: _mailTo,
            icon: const Icon(
              Icons.mail_outline,
              size: 30,
              color: Colors.grey,
            )),
      ),
    );
  }

  void _mailTo() async {
    var mailUrl = 'mainto : ${widget.useremail}';
    // ignore: deprecated_member_use
    if (await canLaunch(mailUrl)) {
      // ignore: deprecated_member_use
      await launch(mailUrl);
    } else {
      throw 'Error Occured';
    }
  }
}
