// ignore_for_file: use_build_context_synchronously
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:schats/main.dart';
import 'package:schats/view/auth_screen/login_screen.dart';
import 'package:schats/view/home_screen/home_screen.dart';
import 'package:velocity_x/velocity_x.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<SplashScreen> {
  bool isAnimate = false;

  @override
  void initState() {
    super.initState();
    _checkAuthenticationStatus();
  }

  // Check Firebase Authentication state
  _checkAuthenticationStatus() async {
    User? user = FirebaseAuth.instance.currentUser;

    // You can add a delay here for a more visually appealing splash screen
    await Future.delayed(const Duration(milliseconds: 500));

    if (user != null) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
          statusBarColor: Colors.white,
          systemNavigationBarColor: Colors.white));
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const HomeScreeen()),
      );
    } else {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
          statusBarColor: Colors.white,
          systemNavigationBarColor: Colors.white));
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: "Wellcome to We Message".text.color(Colors.black).bold.make(),
      ),
      body: Stack(
        children: [
          Positioned(
            top: mq.height * .10,
            left: mq.width * .15,
            width: mq.width * .70,
            child: Image.asset("assets/wechat.png"),
          ),
          Positioned(
            bottom: mq.height * .10,
            width: mq.width,
            child: "Credit  📧srss@gmail.com"
                .text
                .size(16)
                .color(Colors.black87)
                .align(TextAlign.center)
                .letterSpacing(5)
                .make(),
          ),
        ],
      ),
    );
  }
}
