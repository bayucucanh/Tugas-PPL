import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class TableAverageLevelAnxietyMentalReference extends StatelessWidget {
  const TableAverageLevelAnxietyMentalReference({Key? key}) : super(key: key);

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
            '17'.text.semiBold.makeCentered(),
            '68'.text.semiBold.makeCentered(),
          ],
        ),
        TableRow(
          children: [
            '18'.text.semiBold.makeCentered(),
            '66'.text.semiBold.makeCentered(),
          ],
        ),
        TableRow(
          children: [
            '19'.text.semiBold.makeCentered(),
            '64'.text.semiBold.makeCentered(),
          ],
        ),
        TableRow(
          children: [
            '20'.text.semiBold.makeCentered(),
            '62'.text.semiBold.makeCentered(),
          ],
        ),
        TableRow(
          children: [
            '21'.text.semiBold.makeCentered(),
            '60'.text.semiBold.makeCentered(),
          ],
        ),
        TableRow(
          children: [
            '22'.text.semiBold.makeCentered(),
            '58'.text.semiBold.makeCentered(),
          ],
        ),
        TableRow(
          children: [
            '23'.text.semiBold.makeCentered(),
            '56'.text.semiBold.makeCentered(),
          ],
        ),
        TableRow(
          children: [
            '24'.text.semiBold.makeCentered(),
            '54'.text.semiBold.makeCentered(),
          ],
        ),
      ],
    ).scrollVertical();
  }
}
