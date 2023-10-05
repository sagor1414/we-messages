import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:schats/common_Widget/my_date_utils.dart';
import 'package:schats/controller/controller.dart';
import 'package:schats/main.dart';
import 'package:schats/model/chat_model.dart';
import 'package:velocity_x/velocity_x.dart';

class MessageBuble extends StatefulWidget {
  final Message message;
  const MessageBuble({super.key, required this.message});

  @override
  State<MessageBuble> createState() => _MessageBubleState();
}

class _MessageBubleState extends State<MessageBuble> {
  @override
  Widget build(BuildContext context) {
    return Controller.user.uid == widget.message.fromId
        ? greenMessage()
        : blueMessage();
  }

  Widget blueMessage() {
    if (widget.message.read.isEmpty) {
      Controller.updateMessageReadStatus(widget.message);
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Container(
            padding: EdgeInsets.all(widget.message.type == Type.image
                ? mq.width * .001
                : mq.width * .03),
            margin: EdgeInsets.symmetric(
                horizontal: mq.width * .04, vertical: mq.height * .03),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 221, 245, 255),
              border: Border.all(color: Colors.lightBlue),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(25),
                topRight: Radius.circular(25),
                bottomRight: Radius.circular(25),
              ),
            ),
            child: widget.message.type == Type.text
                ? widget.message.msg.text.size(15).color(Colors.black87).make()
                : ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: CachedNetworkImage(
                      fit: BoxFit.cover,
                      imageUrl: widget.message.msg,
                      placeholder: (context, url) => const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      ),
                      errorWidget: (context, url, error) => const Icon(
                        Icons.broken_image_rounded,
                        size: 70,
                      ),
                    ),
                  ),
          ),
        ),
        MyDateUtils.getFormattedTime(
                context: context, time: widget.message.sent)
            .text
            .size(13)
            .color(Colors.black45)
            .make()
            .box
            .padding(EdgeInsets.only(right: mq.width * .04))
            .make(),
      ],
    );
  }

  Widget greenMessage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            SizedBox(
              width: mq.width * .04,
            ),
            if (widget.message.read.isNotEmpty)
              const Icon(
                Icons.done_all_rounded,
                size: 20,
                color: Colors.green,
              ),
            4.widthBox,
            MyDateUtils.getFormattedTime(
                    context: context, time: widget.message.sent)
                .text
                .size(13)
                .color(Colors.black45)
                .make()
                .box
                .padding(EdgeInsets.only(left: mq.width * .04))
                .make(),
          ],
        ),
        Flexible(
          child: Container(
            padding: EdgeInsets.all(widget.message.type == Type.image
                ? mq.width * .001
                : mq.width * .03),
            margin: EdgeInsets.symmetric(
                horizontal: mq.width * .04, vertical: mq.height * .03),
            decoration: BoxDecoration(
                color: const Color.fromARGB(255, 218, 255, 176),
                border: Border.all(color: Colors.lightGreen),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                  bottomLeft: Radius.circular(25),
                )),
            child: widget.message.type == Type.text
                ? widget.message.msg.text.size(15).color(Colors.black87).make()
                : ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: CachedNetworkImage(
                      fit: BoxFit.cover,
                      imageUrl: widget.message.msg,
                      placeholder: (context, url) => const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      ),
                      errorWidget: (context, url, error) => const Icon(
                        Icons.broken_image_rounded,
                        size: 70,
                      ),
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}
