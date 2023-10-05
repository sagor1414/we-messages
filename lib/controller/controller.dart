import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:schats/model/chat_model.dart';
import 'package:schats/model/user_model.dart';

class Controller {
  static FirebaseAuth authController = FirebaseAuth.instance;
  static FirebaseFirestore firestoreController = FirebaseFirestore.instance;
  static FirebaseStorage storage = FirebaseStorage.instance;

  static User get user => authController.currentUser!;

  static ChatUser? me;

  static Future<bool> userExists() async {
    return (await firestoreController
            .collection('users')
            .doc(authController.currentUser!.uid)
            .get())
        .exists;
  }

  static Future<void> getSelfInfo() async {
    try {
      final user = await firestoreController
          .collection('users')
          .doc(authController.currentUser!.uid)
          .get();

      if (user.exists) {
        me = ChatUser.fromJson(user.data()!);
      } else {
        await createUser();
        await getSelfInfo();
      }
    } catch (e) {
      rethrow;
    }
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
      pushToken: '',
    );

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
    if (me == null) {
      return; // Return early if me is null.
    }
    try {
      await firestoreController.collection('users').doc(user.uid).update({
        'name': me!.name,
        'about': me!.about,
      });
    } catch (e) {
      rethrow;
    }
  }

  static Future<void> updateProfilePicture(File file) async {
    final ext = file.path.split('.').last;
    final ref = storage.ref().child('profile_pictures/${user.uid}.$ext');
    await ref
        .putFile(file, SettableMetadata(contentType: 'image/$ext'))
        .then((p0) {
      log('Data Transferred: ${p0.bytesTransferred / 1000}kb');
    });
    me!.image = await ref.getDownloadURL();
    await firestoreController.collection('users').doc(user.uid).update({
      'image': me!.image,
    });
  }

  static String getConversationID(String id) => user.uid.hashCode <= id.hashCode
      ? '${user.uid}_$id'
      : '${id}_${user.uid}';

  //getting al message from database
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllMessages(
      ChatUser user) {
    return firestoreController
        .collection('/chats/${getConversationID(user.id)}/messages/')
        .orderBy('sent', descending: true)
        .snapshots();
  }

  static Future<void> sendMessage(
      ChatUser chatUser, String msg, Type type) async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();

    final Message message = Message(
        msg: msg,
        toId: chatUser.id,
        read: '',
        type: type,
        sent: time,
        fromId: user.uid);

    final ref = firestoreController
        .collection('/chats/${getConversationID(chatUser.id)}/messages/');
    await ref.doc(time).set(message.toJson());
  }

  static Future<void> updateMessageReadStatus(Message message) async {
    firestoreController
        .collection('/chats/${getConversationID(message.fromId)}/messages/')
        .doc(message.sent)
        .update({'read': DateTime.now().millisecondsSinceEpoch.toString()});
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getLastMessages(
      ChatUser user) {
    return firestoreController
        .collection('/chats/${getConversationID(user.id)}/messages/')
        .orderBy('sent', descending: true)
        .limit(1)
        .snapshots();
  }

  static Future<void> sendChatImage(ChatUser chatuser, File file) async {
    final ext = file.path.split('.').last;
    final ref = storage.ref().child(
        'images/${getConversationID(chatuser.id)}/${DateTime.now().millisecondsSinceEpoch}.$ext');
    await ref
        .putFile(file, SettableMetadata(contentType: 'image/$ext'))
        .then((p0) {
      log('Data Transferred: ${p0.bytesTransferred / 1000}kb');
    });
    final imageUrl = await ref.getDownloadURL();
    await sendMessage(chatuser, imageUrl, Type.image);
  }
}
