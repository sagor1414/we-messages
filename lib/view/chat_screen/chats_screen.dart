import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schats/controller/controller.dart';
import 'package:schats/main.dart';
import 'package:schats/model/chat_model.dart';
import 'package:schats/model/user_model.dart';
import 'package:velocity_x/velocity_x.dart';

import 'component/chat_buble.dart';

class ChatScreen extends StatefulWidget {
  final ChatUser user;
  const ChatScreen({super.key, required this.user});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<Message> _list = [];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          flexibleSpace: _appbar(),
        ),
        body: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                stream: Controller.getAllMessages(),
                // stream: Controller.getAllUsers(),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                    case ConnectionState.none:
                      return const Center(
                        child: CircularProgressIndicator(),
                      );

                    case ConnectionState.active:
                    case ConnectionState.done:
                      final data = snapshot.data?.docs;
                      // print('Data: ${jsonEncode(data![0].data())}');
                      // _list =
                      //     data?.map((e) => ChatUser.fromJson(e.data())).toList() ??
                      //         [];
                      _list.clear();
                      _list.add(Message(
                          msg: 'hi',
                          toId: 'xyz',
                          read: '',
                          type: Type.text,
                          sent: '12:05 PM',
                          fromId: Controller.user.uid));
                      _list.add(Message(
                          msg: 'hello',
                          toId: Controller.user.uid,
                          read: '',
                          type: Type.text,
                          sent: '12:05 PM',
                          fromId: 'xyz'));
                      if (_list.isNotEmpty) {
                        return ListView.builder(
                          padding: EdgeInsets.only(top: mq.height * .01),
                          physics: const BouncingScrollPhysics(),
                          itemCount: _list.length,
                          itemBuilder: (context, index) {
                            return MessageBuble(
                              message: _list[index],
                            );
                          },
                        );
                      } else {
                        return Center(
                          child: "Start messing...".text.size(20).make(),
                        );
                      }
                  }
                },
              ),
            ),
            _chatInput(),
          ],
        ),
      ),
    );
  }

  Widget _appbar() {
    return InkWell(
      onTap: () {},
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black87,
            ),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(mq.height * .03),
            child: CachedNetworkImage(
              width: mq.height * .060,
              height: mq.height * .060,
              imageUrl: widget.user.image,
              errorWidget: (context, url, error) => const CircleAvatar(
                child: Icon(CupertinoIcons.person_alt),
              ),
            ),
          ),
          10.widthBox,
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              widget.user.name.text
                  .size(16)
                  .color(Colors.black87)
                  .semiBold
                  .make(),
              3.heightBox,
              "last seen not available"
                  .text
                  .size(13)
                  .color(Colors.black54)
                  .make()
            ],
          )
        ],
      ),
    );
  }

  Widget _chatInput() {
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: mq.height * .01, horizontal: mq.width * .025),
      child: Row(
        children: [
          Expanded(
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Get.back();
                    },
                    icon: const Icon(
                      Icons.emoji_emotions,
                      color: Colors.green,
                      size: 25,
                    ),
                  ),
                  const Expanded(
                      child: TextField(
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration: InputDecoration(
                        hintText: "Type a message",
                        hintStyle: TextStyle(color: Colors.green),
                        border: InputBorder.none),
                  )),
                  IconButton(
                    onPressed: () {
                      Get.back();
                    },
                    icon: const Icon(
                      Icons.image,
                      color: Colors.green,
                      size: 25,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      Get.back();
                    },
                    icon: const Icon(
                      Icons.camera_alt_rounded,
                      color: Colors.green,
                      size: 25,
                    ),
                  ),
                  5.widthBox,
                ],
              ),
            ),
          ),
          MaterialButton(
            onPressed: () {},
            padding:
                const EdgeInsets.only(top: 10, bottom: 10, right: 7, left: 10),
            minWidth: 0,
            shape: const CircleBorder(),
            color: Colors.green,
            child: const Icon(
              Icons.send,
              color: Colors.white,
              size: 28,
            ),
          )
        ],
      ),
    );
  }
}
