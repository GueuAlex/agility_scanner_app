import 'package:flutter/material.dart';

import '../../../config/app_text.dart';
import '../../../model/scan_history_model.dart';
import '../../scanner/widgets/infos_column.dart';

class Details extends StatelessWidget {
  final ScanHistoryModel scanHistoryModel;
  const Details({
    required this.scanHistoryModel,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 5, top: 5),
      child: InfosColumn(
        opacity: 0.1,
        label: scanHistoryModel.motif,
        widget: Expanded(
          child: AppText.medium(scanHistoryModel.scanHour),
        ),
      ),
    );
  }
}
