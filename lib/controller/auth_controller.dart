import 'dart:developer';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:schats/common_Widget/dialouges.dart';
import 'package:schats/controller/controller.dart';
import 'package:schats/view/home_screen/home_screen.dart';
import 'package:velocity_x/velocity_x.dart';

loginWithGoogles(BuildContext context) async {
  Dialogs.showProgressBar(context);
  signInWithGoogle(context).then(
    (user) async {
      Navigator.pop(context);
      if (user != null) {
        log('\nUser: ${user.user}');
        log('\nUserAdditionalInfo: ${user.additionalUserInfo}');
        if ((await Controller.userExists())) {
          Get.offAll(() => const HomeScreeen());
        } else {
          await Controller.createUser().then((value) {
            Get.offAll(() => const HomeScreeen());
          });
        }
      }
    },
  );
}

Future<UserCredential?> signInWithGoogle(BuildContext context) async {
  try {
    await InternetAddress.lookup('google.com');
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await Controller.authController.signInWithCredential(credential);
  } catch (e) {
    // ignore: use_build_context_synchronously
    VxToast.show(context,
        msg: "No Internet, Check your internet connection",
        textColor: Colors.black,
        bgColor: Colors.green[400]);

    return null;
  }
}
