import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mobile_pssi/data/model/day.dart';
import 'package:mobile_pssi/extensions/format_timeofday.extension.dart';
import 'package:mobile_pssi/ui/transfer_market/pages/new_student_form/new_student_form.controller.dart';
import 'package:mobile_pssi/utils/date_picker.dart';
import 'package:mobile_pssi/utils/ui.spacer.dart';
import 'package:velocity_x/velocity_x.dart';

class ScheduleFormCard extends StatelessWidget {
  final ScheduleForm scheduleForm;
  final Function(Day?)? selectedDay;
  final Function()? deleteSchedule;

  ScheduleFormCard({
    Key? key,
    this.selectedDay,
    this.deleteSchedule,
    required this.scheduleForm,
  }) : super(key: key);

  final _tf = DateFormat.Hm();

  @override
  Widget build(BuildContext context) {
    return HStack([
      DropdownButtonFormField(
        isExpanded: true,
        decoration: const InputDecoration(
          hintText: 'Hari',
          labelText: 'Hari',
        ),
        items: scheduleForm.days
            .map((e) => DropdownMenuItem(
                  value: e,
                  child: (e.name ?? '-').text.make(),
                ))
            .toList(),
        onChanged: selectedDay,
        value: scheduleForm.day,
        validator: (Day? value) {
          if (value?.id == null) {
            return 'Masukan tidak boleh kosong';
          }
          return null;
        },
      ).expand(),
      UiSpacer.horizontalSpace(space: 10),
      TextFormField(
        controller: scheduleForm.startTime,
        validator: ValidationBuilder(localeName: 'id').required().build(),
        decoration: const InputDecoration(
          hintText: 'hh:mm',
          labelText: 'Waktu Mulai',
        ),
        readOnly: true,
        onTap: () => selectTimeRange(context),
      ).expand(),
      UiSpacer.horizontalSpace(space: 10),
      TextFormField(
        controller: scheduleForm.endTime,
        validator: ValidationBuilder(localeName: 'id').required().build(),
        decoration: const InputDecoration(
          hintText: 'hh:mm',
          labelText: 'Waktu Selesai',
        ),
        readOnly: true,
        onTap: () => selectTimeRange(context),
      ).expand(),
      IconButton(
          onPressed: deleteSchedule,
          icon: const Icon(Icons.delete_forever_rounded)),
    ]);
  }

  selectTimeRange(BuildContext context) async {
    await DatePicker.getRangeTime(
      context,
      title: 'Pilih Waktu',
      onSelect: (TimeOfDay from, TimeOfDay to) {
        var df = DateFormat.Hm();
        scheduleForm.startTime?.text = _tf.format(df.parse(from.formatTime()));
        scheduleForm.endTime?.text = _tf.format(df.parse(to.formatTime()));
        Get.back();
      },
    );
  }
}
