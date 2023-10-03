import 'package:flutter/material.dart';
import 'package:schats/controller/auth_controller.dart';
import 'package:schats/main.dart';
import 'package:velocity_x/velocity_x.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isAnimate = false;

  @override
  void initState() {
    super.initState();
    // Use WidgetsBinding to schedule the animation after the widget is fully built.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          isAnimate = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: "Welcome to We Message".text.color(Colors.black).bold.make(),
      ),
      body: Stack(
        children: [
          AnimatedPositioned(
            top: mq.height * 0.10,
            right: isAnimate ? mq.width * 0.15 : -mq.width * 0.15,
            width: mq.width * 0.70,
            duration: const Duration(seconds: 1),
            child: Image.asset("assets/wechat.png"),
          ),
          Positioned(
            bottom: mq.height * 0.10,
            left: mq.width * 0.05,
            width: mq.width * 0.90,
            height: mq.height * 0.06,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 219, 255, 178),
                shape: const StadiumBorder(),
                elevation: 1,
              ),
              onPressed: () {
                loginWithGoogles(context);
              },
              icon: Image.asset(
                "assets/google.png",
                height: mq.height * 0.03,
              ),
              label: RichText(
                text: const TextSpan(
                  style: TextStyle(color: Colors.black, fontSize: 16),
                  children: [
                    TextSpan(text: "Log In with "),
                    TextSpan(
                      text: "Google",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
