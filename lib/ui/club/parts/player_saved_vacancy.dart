import 'package:flutter/material.dart';
import 'package:mobile_pssi/ui/club/parts/new_student_tab_list.dart';
import 'package:mobile_pssi/ui/club/parts/selection_tab_list.dart';
import 'package:velocity_x/velocity_x.dart';

class PlayerSavedVacancy extends StatelessWidget {
  const PlayerSavedVacancy({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: VStack(
        [
          const TabBar(tabs: [
            Tab(
              text: 'Seleksi',
            ),
            Tab(
              text: 'Siswa Baru',
            ),
          ]),
          const TabBarView(
            children: [
              SelectionTabList(),
              NewStudentTabList(),
            ],
          ).expand()
        ],
      ),
    );
  }
}
