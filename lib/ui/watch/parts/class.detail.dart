import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/ui/watch/controller/watch.controller.dart';
import 'package:velocity_x/velocity_x.dart';

class ClassDetail extends GetView<WatchController> {
  const ClassDetail({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return (controller.classDetail.description ?? '-')
        .text
        .make()
        .p12()
        .scrollVertical();
  }
}
