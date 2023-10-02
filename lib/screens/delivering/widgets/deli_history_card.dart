import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:scanner/config/functions.dart';
import 'package:scanner/model/livraison_model.dart';
import 'package:scanner/screens/deli_details/deli_details_sheet.dart';

import '../../../config/app_text.dart';
import '../../../config/palette.dart';
import '../../../widgets/profil_picture_container.dart';

class DeliHistoryCard extends StatelessWidget {
  final Livraison livraison;
  const DeliHistoryCard({
    super.key,
    required this.livraison,
  });

  @override
  Widget build(BuildContext context) {
    // User user = qrCodeModel.user;
    //final size = MediaQuery.of(context).size;
    return Card(
      elevation: 0.3,
      margin: const EdgeInsets.all(2.5),
      child: Container(
        width: double.infinity,
        child: ListTile(
          onTap: () => Functions.showBottomSheet(
            ctxt: context,
            widget: DeliDetailSheet(
              deli: livraison,
            ),
          ),
          leading: ProfilPictureContaire(asset: 'assets/images/deli.jpg'),
          title: AppText.medium(
            livraison.entreprise,
            textOverflow: TextOverflow.fade,
            fontSize: 12,
          ),
          subtitle: AppText.small(
            '${livraison.heureEntree!.substring(0, 5)}  \u2022 Par ${livraison.nom}  ',
            textOverflow: TextOverflow.fade,
          ),
          trailing: FittedBox(
            child: Row(
              children: [
                AppText.small(livraison.status),
                Icon(
                  CupertinoIcons.chevron_right,
                  size: 15,
                  color: Palette.greyColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
