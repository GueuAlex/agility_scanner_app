import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../config/app_text.dart';
import '../../../config/palette.dart';
import '../../../model/members_model.dart';
import '../../../model/qr_code_model.dart';
import '../../../model/user.dart';

class SheetHeader extends StatelessWidget {
  const SheetHeader({
    super.key,
    required this.user,
    required this.qrCodeModel,
  });
  final User user;
  final QrCodeModel qrCodeModel;

  @override
  Widget build(BuildContext context) {
    return Container(
      //height: 170,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.3),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.elliptical(200, 10),
          bottomRight: Radius.elliptical(200, 10),
        ),
      ),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 8.0),
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: Colors.black,
              border: Border.all(
                width: 3,
                color: Palette.secondaryColor,
              ),
              shape: BoxShape.circle,
              image: DecorationImage(
                image: AssetImage('assets/images/black-woman.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          AppText.large(
            '${user.nom} ${user.prenoms}',
            fontSize: 14,
            color: Colors.black.withOpacity(0.7),
            textOverflow: TextOverflow.ellipsis,
          ),
          AppText.small(
            '${user.motifVisite} \u2022 ${qrCodeModel.type}',
            textOverflow: TextOverflow.fade,
          ),
          user.members.isNotEmpty
              ? Container(
                  margin: const EdgeInsets.only(top: 5, bottom: 8),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Palette.greyColor.withOpacity(0.5),
                  ),
                  child: IconButton(
                    onPressed: () => alert(
                      ctxt: context,
                      members: user.members,
                      cancel: () => Navigator.pop(context),
                    ),
                    icon: Icon(
                      CupertinoIcons.person_3,
                    ),
                  ),
                )
              : Container()
        ],
      ),
    );
  }

  //affiche un alerte dialogue contenant les accompagnateur
  Future<Null> alert(
      {required BuildContext ctxt,
      required Function() cancel,
      required List<Member> members}) async {
    return showDialog(
      barrierDismissible: false,
      context: ctxt,
      builder: (BuildContext ctxt) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: AppText.medium(
            members.length > 1 ? 'Personnes associées' : 'Personne associée',
          ),
          content: Container(
            height: members.length > 1 ? 150 : 80,
            width: double.infinity,
            child: SingleChildScrollView(
              child: Column(
                children: members
                    .map(
                      (member) => MemberWidget(
                        member: member,
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
          contentPadding: const EdgeInsets.only(
            top: 5.0,
            right: 15.0,
            left: 15.0,
          ),
          titlePadding: const EdgeInsets.only(
            top: 10,
            left: 15,
          ),
          actions: [
            TextButton(
              onPressed: cancel,
              child: AppText.small(
                'Retour',
                fontWeight: FontWeight.w500,
                color: Palette.primaryColor,
              ),
            )
          ],
        );
      },
    );
  }
}

class MemberWidget extends StatelessWidget {
  final Member member;
  const MemberWidget({
    super.key,
    required this.member,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0.5,
      child: Container(
        margin: const EdgeInsets.only(left: 5),
        child: ListTile(
          contentPadding: const EdgeInsets.all(0),
          leading: Container(
            height: 25,
            width: 25,
            decoration: BoxDecoration(
              color: Palette.appPrimaryColor.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              CupertinoIcons.person,
              size: 15,
              color: Palette.appPrimaryColor,
            ),
          ),
          title: AppText.small(
            '${member.nom} ${member.prenoms}',
            fontSize: 10,
            textOverflow: TextOverflow.clip,
          ),
        ),
      ),
    );
  }
}
