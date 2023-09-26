import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:scanner/screens/delivering/widgets/deli_tab_bar_view_body.dart';

import '../../config/app_text.dart';

class DeliSearchByDateScreen extends StatelessWidget {
  static String routeName = 'deli_search_by_date_screen';
  const DeliSearchByDateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final selectedDate = ModalRoute.of(context)!.settings.arguments as DateTime;
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        title: AppText.medium(
          DateFormat('EEE dd MMMM yyyy', 'fr_FR').format(selectedDate),
        ),
      ),
      body: DeliTabBarViewBody(
        date: selectedDate,
        size: size,
      ),
    );
  }
}
