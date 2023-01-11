import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_pssi/data/model/performance_item.dart';
import 'package:mobile_pssi/data/model/scat_question.dart';
import 'package:mobile_pssi/observables/file_observable.dart';

class PerformanceForm {
  final _picker = ImagePicker();
  PerformanceItem? performanceItem;
  ScatQuestion? scatQuestion;
  int? scatAnswer;
  TextEditingController? scoreText;
  TextEditingController? linkText;
  Rx<FileObservable>? fileVideo;

  PerformanceForm({
    this.linkText,
    this.scatQuestion,
    this.scatAnswer,
    this.performanceItem,
    this.scoreText,
    this.fileVideo,
  });

  selectFile({required ImageSource source}) async {
    XFile? file = await _picker.pickVideo(
        source: source, maxDuration: const Duration(hours: 1));

    if (file != null) {
      fileVideo!(FileObservable.xFileResult(file));
    } else {
      fileVideo!(FileObservable());
    }
  }
}
