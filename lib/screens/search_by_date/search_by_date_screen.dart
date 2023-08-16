import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../config/app_text.dart';
import '../home/widgets/tab_bar_view_body.dart';

class SearchByDateScreen extends StatelessWidget {
  static const routeName = 'searchByDateScreen';
  const SearchByDateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final selectedDate = ModalRoute.of(context)!.settings.arguments as DateTime;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 1,
        title: AppText.medium(
          DateFormat('EEE dd MMMM yyyy', 'fr_FR').format(selectedDate),
        ),
      ),
      body: TabBarViewBody(
        size: size,
        date: selectedDate,
      ),
    );
  }
}
