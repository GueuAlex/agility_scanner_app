import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../config/app_text.dart';
import '../../../config/palette.dart';
import '../../../model/qr_code_model.dart';
import '../../../model/user.dart';
import '../../../widgets/profil_picture_container.dart';
import '../../qr_code_details/qr_code_details_screen.dart';

class ScanHistoryCard extends StatelessWidget {
  final QrCodeModel qrCodeModel;
  const ScanHistoryCard({
    super.key,
    required this.qrCodeModel,
  });

  @override
  Widget build(BuildContext context) {
    User user = qrCodeModel.user;
    //final size = MediaQuery.of(context).size;
    return Card(
      elevation: 0.3,
      margin: const EdgeInsets.all(2.5),
      child: Container(
        width: double.infinity,
        child: ListTile(
          onTap: () => Navigator.pushNamed(
            context,
            QrCodeDetailsScreen.routeName,
            arguments: qrCodeModel,
          ),
          leading:
              ProfilPictureContaire(asset: 'assets/images/black-woman.png'),
          title: AppText.medium(
            '${user.nom} ${user.prenoms}',
            textOverflow: TextOverflow.fade,
            fontSize: 12,
          ),
          subtitle: AppText.small(
            '${user.motifVisite} \u2022 ${qrCodeModel.type}',
            textOverflow: TextOverflow.fade,
          ),
          trailing: Icon(
            CupertinoIcons.chevron_right,
            size: 15,
            color: Palette.greyColor,
          ),
        ),
      ),
    );
  }
}
