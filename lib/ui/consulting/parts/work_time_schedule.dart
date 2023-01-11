import 'package:flutter/material.dart';
import 'package:mobile_pssi/data/model/consultation_schedule.dart';
import 'package:mobile_pssi/data/model/day.dart';
import 'package:mobile_pssi/utils/ui.spacer.dart';
import 'package:velocity_x/velocity_x.dart';

class WorkTimeSchedule extends StatelessWidget {
  final ScheduleForm schedule;
  final Function()? onTap;
  final Function(Day?)? onChangedDay;
  final Function()? delete;
  const WorkTimeSchedule({
    Key? key,
    required this.schedule,
    this.onTap,
    this.onChangedDay,
    this.delete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HStack([
      DropdownButtonFormField(
        isExpanded: true,
        isDense: true,
        decoration: InputDecoration(
          hintText:
              schedule.day == null ? 'Pilih Hari' : (schedule.day?.name ?? '-'),
        ),
        items: schedule.days
            .map((e) => DropdownMenuItem(
                  value: e,
                  child: (e.name ?? '-').text.make(),
                ))
            .toList(),
        onChanged: onChangedDay,
      ).expand(),
      UiSpacer.horizontalSpace(),
      TextFormField(
        controller: schedule.startTime,
        readOnly: true,
        showCursor: false,
        onTap: onTap,
        decoration: const InputDecoration(
            isDense: true, hintText: 'HH:mm', labelText: 'Mulai Jam Kerja'),
      ).expand(),
      UiSpacer.horizontalSpace(),
      TextFormField(
        controller: schedule.endTime,
        readOnly: true,
        showCursor: false,
        onTap: onTap,
        decoration: const InputDecoration(
          isDense: true,
          hintText: 'HH:mm',
          labelText: 'Selesai Jam Kerja',
        ),
      ).expand(),
      IconButton(
          onPressed: delete, icon: const Icon(Icons.delete_forever_rounded))
    ]);
  }
}
