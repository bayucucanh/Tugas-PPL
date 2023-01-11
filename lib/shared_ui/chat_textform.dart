import 'package:flutter/material.dart';
import 'package:mobile_pssi/constant/colors.dart';
import 'package:velocity_x/velocity_x.dart';

class ChatTextForm extends StatelessWidget {
  final TextEditingController? controller;
  final bool? isSendingMessage;
  final void Function()? sendMessage;

  const ChatTextForm({
    Key? key,
    this.controller,
    this.isSendingMessage = false,
    this.sendMessage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HStack([
      TextFormField(
        controller: controller,
        cursorColor: primaryColor,
        enabled: isSendingMessage == true ? false : true,
        decoration: const InputDecoration(
          hintText: 'Aa',
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
            gapPadding: 0,
            borderRadius: BorderRadius.all(Radius.circular(50)),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
            gapPadding: 0,
            borderRadius: BorderRadius.all(Radius.circular(50)),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: primaryColor),
            gapPadding: 0,
            borderRadius: BorderRadius.all(Radius.circular(50)),
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 4, horizontal: 30),
        ),
        maxLines: 3,
        minLines: 1,
        style: const TextStyle(
          fontSize: 12,
        ),
      ).expand(),
      IconButton(
        onPressed: isSendingMessage == true ? null : sendMessage,
        icon: Icon(
          Icons.send_rounded,
          color: isSendingMessage == true ? Colors.grey : primaryColor,
        ),
      )
    ]);
  }
}
