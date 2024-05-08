import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cue_bar/screens/home_screen.dart';
import 'package:cue_bar/utlis/colors.dart';
import 'package:cue_bar/widgets/button_widget.dart';
import 'package:cue_bar/widgets/text_widget.dart';
import 'package:cue_bar/widgets/textfield_widget.dart';
import 'package:cue_bar/widgets/toast_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();

  final passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 100,
              ),
              Image.asset(
                'assets/images/123.jpg',
                height: 200,
              ),
              const SizedBox(
                height: 75,
              ),
              TextFieldWidget(
                textColor: Colors.white,
                color: Colors.white,
                borderColor: Colors.white,
                label: 'Username',
                controller: emailController,
              ),
              const SizedBox(
                height: 20,
              ),
              TextFieldWidget(
                textColor: Colors.white,
                color: Colors.white,
                isObscure: true,
                borderColor: Colors.white,
                label: 'Password',
                controller: passwordController,
                showEye: true,
              ),
              const SizedBox(
                height: 50,
              ),
              ButtonWidget(
                radius: 10,
                color: Colors.white,
                textColor: Colors.black,
                width: 175,
                label: 'Login',
                onPressed: () {
                  if (emailController.text == 'user001' &&
                      passwordController.text == 'user001_password') {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => const HomeScreen()));
                  } else {
                    showToast('Invalid account! Please try again');
                  }
                },
              ),
              const SizedBox(
                height: 50,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
