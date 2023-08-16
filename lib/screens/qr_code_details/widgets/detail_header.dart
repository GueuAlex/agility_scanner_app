import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../config/app_text.dart';
import '../../../config/palette.dart';
import '../../../model/qr_code_model.dart';
import '../../../model/user.dart';
import '../../scanner/widgets/infos_column.dart';

class DetailsHeader extends StatelessWidget {
  final bool isQrcodeInfos;
  final User user;
  final QrCodeModel qrCodeModel;
  const DetailsHeader({
    this.isQrcodeInfos = false,
    required this.qrCodeModel,
    required this.user,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(8),
        width: double.infinity,
        height: 130,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Color.fromARGB(255, 124, 17, 20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  margin: const EdgeInsets.only(bottom: 3),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Palette.primaryColor,
                  ),
                  height: 30,
                  width: 30,
                  child: Center(
                    child: Icon(
                      isQrcodeInfos
                          ? CupertinoIcons.qrcode
                          : CupertinoIcons.person,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ),
              ],
            ),
            AppText.medium(
              isQrcodeInfos ? user.motifVisite : '${user.nom} ${user.prenoms}',
              textOverflow: TextOverflow.ellipsis,
              color: Palette.whiteColor,
              fontSize: 11,
            ),
            isQrcodeInfos
                ? AppText.small(
                    qrCodeModel.type,
                    textOverflow: TextOverflow.fade,
                    color: Palette.whiteColor,
                  )
                : AppText.small(
                    user.entreprise,
                    textOverflow: TextOverflow.fade,
                    fontWeight: FontWeight.w500,
                    color: Palette.whiteColor,
                    fontSize: 10,
                  ),
            isQrcodeInfos
                ? Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: InfosColumn(
                            opacity: 0.3,
                            label: qrCodeModel.type == 'temporaire'
                                ? 'Du'
                                : 'Depuis',
                            widget: FittedBox(
                              child: AppText.medium(
                                DateFormat('dd/MM/yyyy')
                                    .format(qrCodeModel.dateDebut),
                                color: Palette.whiteColor,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 3,
                        ),
                        qrCodeModel.type == 'temporaire'
                            ? Expanded(
                                child: InfosColumn(
                                  opacity: 0.3,
                                  label: 'Au',
                                  widget: FittedBox(
                                    child: AppText.medium(
                                      DateFormat('dd/MM/yyyy')
                                          .format(qrCodeModel.dateFin!),
                                      color: Palette.whiteColor,
                                    ),
                                  ),
                                ),
                              )
                            : Container()
                      ],
                    ),
                  )
                : AppText.small(
                    user.number,
                    textOverflow: TextOverflow.fade,
                    color: Palette.whiteColor,
                  )
          ],
        ),
      ),
    );
  }
}
