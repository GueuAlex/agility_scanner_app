import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:scanner/config/app_text.dart';
import 'package:scanner/config/functions.dart';
import 'package:scanner/screens/add_delivering/add_deli_screen.dart';
import 'package:scanner/screens/delivering/widgets/search_sheet.dart';

import '../../config/palette.dart';
import '../search_by_date/deli_search_by_date_screen.dart';
import '../side_bar/custom_side_bar.dart';
import '../side_bar/open_side_dar.dart';
import 'widgets/tab_bar_menu.dart';
import 'widgets/deli_tab_bar_view_body.dart';

class DeliveringScreen extends StatefulWidget {
  static String routeName = 'delivering_screen';
  const DeliveringScreen({super.key});

  @override
  State<DeliveringScreen> createState() => _DeliveringScreenState();
}

class _DeliveringScreenState extends State<DeliveringScreen> {
  ////////////////
  /////////////////////////////////////
  ///
  DateTime today = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );
  ///////:::
  DateTime _selectedDate = Functions.getToday();
  /////////////////////////////////
  /// TO ADD NEW DELIVERY
  ////////////// SELECTED ENTREPRISE /////////////////////

  bool canPush = false;

  @override
  void initState() {
    if (canPush) {
      Navigator.pushNamed(context, AddDeliScree.routeName);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return DefaultTabController(
      length: 7,
      initialIndex: 0,
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
            backgroundColor: Palette.primaryColor,
            onPressed: () {
              Functions.showBottomSheet(
                ctxt: context,
                widget: SearchBottomSheet(),
              );
            },
            child: Center(
              child: Icon(
                CupertinoIcons.add,
                color: Palette.whiteColor,
                size: 20,
              ),
            )),
        drawer: const CustomSiderBar(),
        appBar: AppBar(
          elevation: 1,
          title: AppText.medium(
            'Livraisons - ${DateFormat('MMM yyyy', 'fr_FR').format(DateTime.now())}',
            textOverflow: TextOverflow.fade,
          ),
          centerTitle: true,
          leading: const OpenSideBar(),
          backgroundColor: Palette.whiteColor,
          bottom: TabBar(
            onTap: (value) {
              //print(today.subtract(Duration(days: value)));
            },
            indicatorSize: TabBarIndicatorSize.label,
            indicatorWeight: 3,
            indicatorColor: Palette.primaryColor,
            labelColor: Palette.primaryColor,
            isScrollable: true,
            tabs: List.generate(
              7,
              (index) => TopMenu(
                date: today.subtract(Duration(days: index)),
              ),
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(
                CupertinoIcons.calendar_today,
                size: 29,
                color: Palette.greyColor,
              ),
              onPressed: () {
                //print(today);
                /* Functions.showSnackBar(
                    ctxt: context,
                    messeage: 'Selecteur de période',
                  ); */
                _dateSelector(context);
              },
            ),
            SizedBox(
              width: 8,
            )
          ],
        ),
        body: DoubleBackToCloseApp(
          snackBar: SnackBar(
            content: AppText.medium(
              'Double clic pour quitter',
              color: Colors.grey,
            ),
          ),
          child: TabBarView(
            children: List.generate(
              7,
              (index) => DeliTabBarViewBody(
                size: size,
                date: today.subtract(
                  Duration(days: index),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _dateSelector(BuildContext context) async {
    if (Theme.of(context).platform == TargetPlatform.iOS) {
      return showModalBottomSheet(
        context: context,
        builder: (BuildContext builder) {
          return Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: CupertinoColors.quaternarySystemFill,
            ),
            height: MediaQuery.of(context).copyWith().size.height / 3,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'Annuler',
                        style: TextStyle(
                          color: CupertinoColors.systemRed,
                          fontSize: 20,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        // Navigation vers la page 2 avec la date sélectionnée
                        Navigator.pushNamed(
                            context, DeliSearchByDateScreen.routeName,
                            arguments: _selectedDate);
                      },
                      child: const Text(
                        'Voir',
                        style: TextStyle(
                          color: CupertinoColors.activeBlue,
                          fontSize: 20,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    )
                  ],
                ),
                Expanded(
                  child: CupertinoDatePicker(
                    use24hFormat: true,
                    initialDateTime: DateTime.now(),
                    onDateTimeChanged: (DateTime newDate) {
                      setState(() {
                        _selectedDate = newDate;
                        // print(newDate.toString());
                      });
                    },
                    minimumYear: 1900,
                    maximumYear: 2100,
                    mode: CupertinoDatePickerMode.date,
                  ),
                ),
              ],
            ),
          );
        },
      );
    } else {
      final DateTime? picked = await showDatePicker(
        locale: const Locale('fr', 'FR'),
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1900),
        lastDate: DateTime(2100),
      );
      if (picked != null && picked != _selectedDate) {
        setState(() {
          _selectedDate = picked;
        });

        // Navigation vers la page 2 avec la date sélectionnée
        Navigator.pushNamed(context, DeliSearchByDateScreen.routeName,
            arguments: _selectedDate);
      }
    }
  }
}
