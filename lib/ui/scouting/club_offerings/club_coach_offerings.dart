import 'package:flutter/material.dart';
import 'package:mobile_pssi/shared_ui/default_scaffold.dart';
import 'package:mobile_pssi/ui/scouting/club_offerings/my_club_coach_offering.dart';
import 'package:mobile_pssi/ui/scouting/club_offerings/other_club_coach_offering.dart';
import 'package:velocity_x/velocity_x.dart';

class ClubCoachOfferings extends StatelessWidget {
  static const routeName = '/club/coach/offerings';
  const ClubCoachOfferings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultScaffold(
        title: 'Offering Pelatih Klub'.text.make(),
        body: DefaultTabController(
          length: 2,
          child: VStack([
            const TabBar(tabs: [
              Tab(
                text: 'Penawaran Klub',
              ),
              Tab(
                text: 'Penawaran Klub Lain',
              ),
            ]),
            const TabBarView(
              children: [
                MyClubCoachOffering(),
                OtherClubCoachOffering(),
              ],
            ).expand()
          ]),
        ));
  }
}
