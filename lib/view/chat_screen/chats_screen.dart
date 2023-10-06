import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:schats/common_Widget/my_date_utils.dart';
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
  final textController = TextEditingController();
  var isUploading = false;
  List<ChatUser>? list = [];
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            flexibleSpace: _appbar(),
          ),
          body: Column(
            children: [
              Expanded(
                child: StreamBuilder(
                  stream: Controller.getAllMessages(widget.user),
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                      case ConnectionState.none:
                        return const Center(
                          child: SizedBox(),
                        );

                      case ConnectionState.active:
                      case ConnectionState.done:
                        final data = snapshot.data?.docs;
                        // print('Data: ${jsonEncode(data![0].data())}');
                        _list = data
                                ?.map((e) => Message.fromJson(e.data()))
                                .toList() ??
                            [];

                        if (_list.isNotEmpty) {
                          return ListView.builder(
                            reverse: true,
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
              if (isUploading)
                const Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                    child: CircularProgressIndicator(
                      color: Colors.green,
                    ),
                  ),
                ),
              _chatInput(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _appbar() {
    return InkWell(
      onTap: () {},
      child: StreamBuilder(
          stream: Controller.getUserInfo(widget.user),
          builder: ((context, snapshot) {
            final data = snapshot.data?.docs;
            final list = data!.map((e) => ChatUser.fromJson(e.data())).toList();

            return Row(
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
                    imageUrl:
                        list.isNotEmpty ? list[0].image : widget.user.image,
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
                    list.isNotEmpty
                        ? list[0]
                            .name
                            .text
                            .size(16)
                            .color(Colors.black87)
                            .semiBold
                            .make()
                        : widget.user.name.text
                            .size(16)
                            .color(Colors.black87)
                            .semiBold
                            .make(),
                    3.heightBox,
                    list.isNotEmpty
                        ? list[0].isOnline
                            ? 'Online'.text.color(Colors.black87).make()
                            : MyDateUtils.getLastActiveTime(
                                    context: context,
                                    lastActive: list[0].lastActive)
                                .text
                                .size(13)
                                .color(Colors.black54)
                                .make()
                        : MyDateUtils.getLastActiveTime(
                                context: context,
                                lastActive: widget.user.lastActive)
                            .text
                            .size(13)
                            .color(Colors.black54)
                            .make()
                  ],
                )
              ],
            );
          })),
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
                  Expanded(
                      child: TextField(
                    controller: textController,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration: const InputDecoration(
                        hintText: "Type a message",
                        hintStyle: TextStyle(color: Colors.green),
                        border: InputBorder.none),
                  )),
                  IconButton(
                    onPressed: () async {
                      final ImagePicker picker = ImagePicker();
                      // Pick an image.
                      final List<XFile> images =
                          await picker.pickMultiImage(imageQuality: 70);
                      for (var i in images) {
                        setState(() => isUploading = true);
                        await Controller.sendChatImage(
                            widget.user, File(i.path));
                        setState(() => isUploading = false);
                      }
                    },
                    icon: const Icon(
                      Icons.image,
                      color: Colors.green,
                      size: 25,
                    ),
                  ),
                  IconButton(
                    onPressed: () async {
                      final ImagePicker picker = ImagePicker();
                      // Pick an image.
                      final XFile? image = await picker.pickImage(
                          source: ImageSource.camera, imageQuality: 70);
                      if (image != null) {
                        setState(() => isUploading = true);
                        await Controller.sendChatImage(
                            widget.user, File(image.path));
                        setState(() => isUploading = false);
                      }
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
            onPressed: () {
              if (textController.text.isNotEmpty) {
                Controller.sendMessage(
                    widget.user, textController.text, Type.text);
                textController.text = '';
              }
            },
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
