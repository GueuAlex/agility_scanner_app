import 'package:flutter/material.dart';
import 'package:scanner/config/app_text.dart';
import 'package:scanner/screens/scanner/widgets/infos_column.dart';
import 'package:scanner/widgets/all_sheet_header.dart';

import '../../../model/entreprise_model.dart';
import '../../add_delivering/add_deli_screen.dart';

class SearchBottomSheet extends StatefulWidget {
  @override
  _SearchBottomSheetState createState() => _SearchBottomSheetState();
}

class _SearchBottomSheetState extends State<SearchBottomSheet> {
  TextEditingController _searchController = TextEditingController();
  List<String> _suggestions = [];
  List<String> _filteredSuggestions = [];

  @override
  void initState() {
    _suggestions.clear();
    _suggestions = getEntrepriseList(entrepises: Entreprise.entrepriseList);
    super.initState();
    _filteredSuggestions.addAll(_suggestions);
  }

  void _onTextChanged(String value) {
    setState(() {
      _filteredSuggestions = _suggestions
          .where((suggestion) =>
              suggestion.toLowerCase().contains(value.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    //final size = MediaQuery.of(context).size;
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      margin: EdgeInsets.only(bottom: keyboardHeight),
      //height: size.height / 2,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          AllSheetHeader(),
          SizedBox(
            height: 5,
          ),
          Padding(
            padding: EdgeInsets.only(right: 16.0, left: 16.0),
            child: AppText.medium('Nouvelle livraison'),
          ),
          SizedBox(
            height: 5,
          ),
          Padding(
            padding: EdgeInsets.only(right: 16.0, left: 16.0),
            child: InfosColumn(
              height: 50,
              opacity: 0.2,
              label: 'Nom de l\'entreprise',
              widget: Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: TextField(
                    controller: _searchController,
                    onChanged: _onTextChanged,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 16.0),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: 16.0, left: 16.0),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _filteredSuggestions.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_filteredSuggestions[index]),
                    onTap: () {
                      // Here, you can define what happens when a suggestion is tapped
                      String SelectedName =
                          _filteredSuggestions[index].toString();
                      Navigator.pop(context);
                      Navigator.pushNamed(
                        context,
                        AddDeliScree.routeName,
                        arguments: SelectedName,
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  //////////get Selected item list /////////////
  List<String> getEntrepriseList({required List<Entreprise> entrepises}) {
    List<String> _items = [];
    _items.clear();
    for (Entreprise element in entrepises) {
      _items.add(element.nom);
    }
    return _items;
  }
}
