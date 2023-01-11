import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile_pssi/ui/reusable/divider_component.dart';

class DrawerComponent extends StatelessWidget {
  final List<Widget> children;

  const DrawerComponent({Key? key, required this.children}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.white,
        child: CustomScrollView(
          slivers: [
            SliverList(
              delegate: SliverChildListDelegate.fixed([
                Container(
                  margin: const EdgeInsets.only(top: 50),
                  height: 132,
                  child: Column(
                    children: [
                      SizedBox(
                        width: 180,
                        child: SvgPicture.asset(
                          'assets/images/logo_kominfo.svg',
                        ),
                      ),
                    ],
                  ),
                ),
                const DividerComponent(),
              ]),
            ),
            SliverFillRemaining(
              child: ListView(
                children: children,
              ),
            )
          ],
        ),
      ),
    );
  }
}
