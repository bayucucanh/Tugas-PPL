import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class TableLowLevelAnxietyMentalReference extends StatelessWidget {
  const TableLowLevelAnxietyMentalReference({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Table(
      border: TableBorder.all(borderRadius: BorderRadius.circular(5)),
      children: [
        TableRow(
          decoration: BoxDecoration(
            color: Colors.amber.shade500,
          ),
          children: [
            'Skor'.text.semiBold.makeCentered(),
            'Rating'.text.semiBold.makeCentered(),
          ],
        ),
        TableRow(
          children: [
            '1'.text.semiBold.makeCentered(),
            '100'.text.semiBold.makeCentered(),
          ],
        ),
        TableRow(
          children: [
            '2'.text.semiBold.makeCentered(),
            '98'.text.semiBold.makeCentered(),
          ],
        ),
        TableRow(
          children: [
            '3'.text.semiBold.makeCentered(),
            '96'.text.semiBold.makeCentered(),
          ],
        ),
        TableRow(
          children: [
            '4'.text.semiBold.makeCentered(),
            '94'.text.semiBold.makeCentered(),
          ],
        ),
        TableRow(
          children: [
            '5'.text.semiBold.makeCentered(),
            '92'.text.semiBold.makeCentered(),
          ],
        ),
        TableRow(
          children: [
            '6'.text.semiBold.makeCentered(),
            '90'.text.semiBold.makeCentered(),
          ],
        ),
        TableRow(
          children: [
            '7'.text.semiBold.makeCentered(),
            '88'.text.semiBold.makeCentered(),
          ],
        ),
        TableRow(
          children: [
            '8'.text.semiBold.makeCentered(),
            '86'.text.semiBold.makeCentered(),
          ],
        ),
        TableRow(
          children: [
            '9'.text.semiBold.makeCentered(),
            '84'.text.semiBold.makeCentered(),
          ],
        ),
        TableRow(
          children: [
            '10'.text.semiBold.makeCentered(),
            '82'.text.semiBold.makeCentered(),
          ],
        ),
        TableRow(
          children: [
            '11'.text.semiBold.makeCentered(),
            '80'.text.semiBold.makeCentered(),
          ],
        ),
        TableRow(
          children: [
            '12'.text.semiBold.makeCentered(),
            '78'.text.semiBold.makeCentered(),
          ],
        ),
        TableRow(
          children: [
            '13'.text.semiBold.makeCentered(),
            '76'.text.semiBold.makeCentered(),
          ],
        ),
        TableRow(
          children: [
            '14'.text.semiBold.makeCentered(),
            '74'.text.semiBold.makeCentered(),
          ],
        ),
        TableRow(
          children: [
            '15'.text.semiBold.makeCentered(),
            '72'.text.semiBold.makeCentered(),
          ],
        ),
        TableRow(
          children: [
            '16'.text.semiBold.makeCentered(),
            '70'.text.semiBold.makeCentered(),
          ],
        ),
      ],
    ).scrollVertical();
  }
}
