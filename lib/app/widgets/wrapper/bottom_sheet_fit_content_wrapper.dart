import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

Future<dynamic> bottomSheetFitContentWrapper(
    BuildContext context, Widget content) {
  return showMaterialModalBottomSheet(
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      ),
    ),
    builder: (context) => SingleChildScrollView(
      child: Container(
        child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20), child: content),
      ),
    ),
  );
}
