import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class TableHighLevelAnxietyMentalReference extends StatelessWidget {
  const TableHighLevelAnxietyMentalReference({Key? key}) : super(key: key);

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
            '25'.text.semiBold.makeCentered(),
            '52'.text.semiBold.makeCentered(),
          ],
        ),
        TableRow(
          children: [
            '26'.text.semiBold.makeCentered(),
            '50'.text.semiBold.makeCentered(),
          ],
        ),
        TableRow(
          children: [
            '27'.text.semiBold.makeCentered(),
            '48'.text.semiBold.makeCentered(),
          ],
        ),
        TableRow(
          children: [
            '28'.text.semiBold.makeCentered(),
            '46'.text.semiBold.makeCentered(),
          ],
        ),
        TableRow(
          children: [
            '29'.text.semiBold.makeCentered(),
            '44'.text.semiBold.makeCentered(),
          ],
        ),
        TableRow(
          children: [
            '30'.text.semiBold.makeCentered(),
            '42'.text.semiBold.makeCentered(),
          ],
        ),
        TableRow(
          children: [
            '31'.text.semiBold.makeCentered(),
            '40'.text.semiBold.makeCentered(),
          ],
        ),
        TableRow(
          children: [
            '32'.text.semiBold.makeCentered(),
            '38'.text.semiBold.makeCentered(),
          ],
        ),
        TableRow(
          children: [
            '33'.text.semiBold.makeCentered(),
            '36'.text.semiBold.makeCentered(),
          ],
        ),
        TableRow(
          children: [
            '34'.text.semiBold.makeCentered(),
            '34'.text.semiBold.makeCentered(),
          ],
        ),
        TableRow(
          children: [
            '35'.text.semiBold.makeCentered(),
            '32'.text.semiBold.makeCentered(),
          ],
        ),
        TableRow(
          children: [
            '36'.text.semiBold.makeCentered(),
            '30'.text.semiBold.makeCentered(),
          ],
        ),
        TableRow(
          children: [
            '37'.text.semiBold.makeCentered(),
            '28'.text.semiBold.makeCentered(),
          ],
        ),
        TableRow(
          children: [
            '38'.text.semiBold.makeCentered(),
            '26'.text.semiBold.makeCentered(),
          ],
        ),
        TableRow(
          children: [
            '39'.text.semiBold.makeCentered(),
            '24'.text.semiBold.makeCentered(),
          ],
        ),
        TableRow(
          children: [
            '40'.text.semiBold.makeCentered(),
            '22'.text.semiBold.makeCentered(),
          ],
        ),
        TableRow(
          children: [
            '41'.text.semiBold.makeCentered(),
            '20'.text.semiBold.makeCentered(),
          ],
        ),
        TableRow(
          children: [
            '42'.text.semiBold.makeCentered(),
            '18'.text.semiBold.makeCentered(),
          ],
        ),
        TableRow(
          children: [
            '43'.text.semiBold.makeCentered(),
            '16'.text.semiBold.makeCentered(),
          ],
        ),
        TableRow(
          children: [
            '44'.text.semiBold.makeCentered(),
            '14'.text.semiBold.makeCentered(),
          ],
        ),
        TableRow(
          children: [
            '45'.text.semiBold.makeCentered(),
            '12'.text.semiBold.makeCentered(),
          ],
        ),
      ],
    ).scrollVertical();
  }
}
