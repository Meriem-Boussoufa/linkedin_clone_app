import 'dart:io';

import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  late AnimationController _animationController;
  late Animation<double> _animation;
  late final TextEditingController _fullNameController =
      TextEditingController(text: '');
  late final TextEditingController _emailController =
      TextEditingController(text: '');
  late final TextEditingController _passTextController =
      TextEditingController(text: '');
  late final TextEditingController _locationController =
      TextEditingController(text: '');
  late final TextEditingController _phoneNumberController =
      TextEditingController(text: '');
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passFocusNode = FocusNode();
  final FocusNode _positionFocusNode = FocusNode();
  final FocusNode _phoneNumberFocusNode = FocusNode();
  final bool _obscureText = true;
  final _signUpFormKey = GlobalKey<FormState>();

  File? imageFile;
  bool isLoading = false;
  String? imageUrl;

  @override
  void dispose() {
    _animationController.dispose();
    _phoneNumberController.dispose();
    _fullNameController.dispose();
    _emailController.dispose();
    _passTextController.dispose();
    _emailFocusNode.dispose();
    _passFocusNode.dispose();
    _positionFocusNode.dispose();
    _phoneNumberFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
