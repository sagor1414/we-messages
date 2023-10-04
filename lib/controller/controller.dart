import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:schats/model/user_model.dart';

class Controller {
  static FirebaseAuth authController = FirebaseAuth.instance;
  static FirebaseFirestore firestoreController = FirebaseFirestore.instance;
  static FirebaseStorage storage = FirebaseStorage.instance;

  static User get user => authController.currentUser!;

  // store self info
  static late ChatUser me;

  static Future<bool> userExists() async {
    return (await firestoreController
            .collection('users')
            .doc(authController.currentUser!.uid)
            .get())
        .exists;
  }

  //get user info
  static Future<void> getSelfInfo() async {
    await firestoreController
        .collection('users')
        .doc(authController.currentUser!.uid)
        .get()
        .then((user) async => {
              if (user.exists)
                {me = ChatUser.fromJson(user.data()!)}
              else
                {await createUser().then((value) => getSelfInfo())}
            });
  }

  static Future<void> createUser() async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();

    final chatUser = ChatUser(
        image: user.photoURL.toString(),
        about: "Hay i am using we message",
        name: user.displayName.toString(),
        createdAt: time,
        lastActive: time,
        id: user.uid,
        isOnline: false,
        email: user.email.toString(),
        pushToken: '');

    return (await firestoreController
        .collection('users')
        .doc(user.uid)
        .set(chatUser.toJson()));
  }

  //get all user
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUsers() {
    return firestoreController
        .collection('users')
        .where('id', isNotEqualTo: user.uid)
        .snapshots();
  }

  static Future<void> updateUserInfo() async {
    await firestoreController.collection('users').doc(user.uid).update({
      'name': me.name,
      'about': me.about,
    });
  }

  static Future<void> updateProfilePicture(File file) async {
    final ext = file.path.split('.').last;
    final ref = storage.ref().child('profile_pictures/${user.uid}.$ext');
    await ref
        .putFile(file, SettableMetadata(contentType: 'image/$ext'))
        .then((p0) {
      log('Data Transferred: ${p0.bytesTransferred / 1000}kb');
    });
    me.image = await ref.getDownloadURL();
    await firestoreController.collection('users').doc(user.uid).update({
      'image': me.image,
    });
  }
}
