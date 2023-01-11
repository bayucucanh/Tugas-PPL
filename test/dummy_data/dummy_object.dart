import 'package:mobile_pssi/data/model/academy_partner.dart';
import 'package:mobile_pssi/data/model/category.dart';
import 'package:mobile_pssi/data/model/employee.dart';
import 'package:mobile_pssi/data/model/status.dart';

final tAcademyPartner = AcademyPartner(
  id: 1,
  employee: const Employee(
    id: 1,
    name: 'test',
    address: 'test',
    category: Category(
      id: 1,
      name: 'test',
    ),
  ),
  reason: 'test',
  status: const Status(
    id: 1,
    name: 'test',
  ),
  createdAt: DateTime.now(),
  updatedAt: DateTime.now(),
);
