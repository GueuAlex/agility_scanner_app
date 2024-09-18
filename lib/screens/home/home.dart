import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../bloc/visite_history_bloc/qr_code_bloc.dart';
import '../../bloc/visite_history_bloc/qr_code_event.dart';
import '../../config/app_text.dart';
import '../../config/functions.dart';
import '../../config/palette.dart';
import '../search_by_date/search_by_date_screen.dart';
import '../side_bar/custom_side_bar.dart';
import '../side_bar/open_side_dar.dart';
import 'widgets/tab_bar_menu.dart';
import 'widgets/tab_bar_view_body.dart';

class Home extends StatefulWidget {
  static String routeName = '/';
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  /////////////////////////////////////
  ///
  DateTime today = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );

  DateTime _selectedDate = Functions.getToday();

  // Méthode pour afficher le Date Picke

////////////////////////////////////////////
  ///
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
                            context, SearchByDateScreen.routeName,
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
        Navigator.pushNamed(context, SearchByDateScreen.routeName,
            arguments: _selectedDate);
      }
    }
  }

  /////////////////////////////////

  @override
  void initState() {
    //goToSearchByDate(selectedDate: _selectedDate);
    super.initState();
    // Démarrer le chargement des données lors de l'initialisation du widget
    BlocProvider.of<QrCodeBloc>(context)
        .add(LoadQrCodeData(date: _selectedDate)); // ou today si nécessaire
  }

  //////////////////////////////////////////
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BlocProvider(
      create: (context) => QrCodeBloc(qrCodeRepository: QrCodeRepository()),
      child: DefaultTabController(
        length: 7,
        initialIndex: 0,
        child: Scaffold(
          drawer: const CustomSiderBar(),
          appBar: AppBar(
            elevation: 1,
            title: AppText.medium(
              DateFormat('MMMM yyyy', 'fr_FR').format(DateTime.now()),
            ),
            centerTitle: true,
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
            backgroundColor: Palette.whiteColor,
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
            leading: const OpenSideBar(),
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
                (index) => TabBarViewBody(
                  date: today.subtract(Duration(days: index)),
                  size: size,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
