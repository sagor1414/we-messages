import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:schats/main.dart';
import 'package:schats/model/user_model.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ChatUsers extends StatefulWidget {
  final ChatUser user;
  const ChatUsers({super.key, required this.user});

  @override
  State<ChatUsers> createState() => _ChatUsersState();
}

class _ChatUsersState extends State<ChatUsers> {
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      color: Colors.blue.shade100,
      elevation: 0.5,
      margin: EdgeInsets.symmetric(horizontal: mq.width * .02, vertical: 3),
      child: InkWell(
        onTap: () {},
        child: ListTile(
          leading: ClipRRect(
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

          title: widget.user.name.text.make(),
          subtitle: widget.user.about.text.maxLines(1).make(),
          trailing: Container(
            width: 15,
            height: 15,
            decoration: BoxDecoration(
                color: Colors.blue, borderRadius: BorderRadius.circular(10)),
          ),
          // trailing: "12:12 PM".text.color(Colors.black54).make(),
        ),
      ),
    );
  }
}
