import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../config/app_text.dart';

class TopMenu extends StatelessWidget {
  const TopMenu({
    super.key,
    required this.date,
  });
  final DateTime date;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: AppText.medium(dateFormateur(dateTime: date)),
      ),
    );
  }

  String dateFormateur({required DateTime dateTime}) {
    DateTime today = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    );
    if (dateTime == today) {
      return "Auj";
    }
    if (today.subtract(const Duration(days: 1)) == dateTime) {
      return "Hier";
    }
    return DateFormat("EEE\n dd", 'fr_FR').format(dateTime);
  }
}
