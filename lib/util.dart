

import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';


import 'font_color_util.dart';

class Util {
  static String convertToIdr(dynamic number) {
    NumberFormat currencyFormatter = NumberFormat.currency(
      locale: 'id',
      symbol: 'Rp. ',
      decimalDigits: 0,
    );
    return currencyFormatter.format(number);
  }

  static String fromMillisToDate(int millis) {
    var dt = DateTime.fromMillisecondsSinceEpoch(millis);
    var date = DateFormat('dd MMMM yyyy').format(dt);
    return date;
  }

  static void showLoading(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            insetPadding: EdgeInsets.zero,
            titlePadding: EdgeInsets.zero,
            content: Row(
              children: [
                const CircularProgressIndicator(),
                Container(
                    margin: const EdgeInsets.only(left: 7),
                    child: const Text(
                      "Loading...",
                      style: TextStyle(fontFamily: FontColorUtil.fontPoppins),
                    )),
              ],
            ),
          );
        });
  }

  static Future<String> saveImage(Uint8List bytes) async {
    String path = "";
    try {
      String directoryPath = '/storage/emulated/0/Download';
      var drc = await getApplicationDocumentsDirectory();
      String filePath = '${Platform.isIOS ? drc.path : directoryPath}/${DateTime.now().millisecond}.jpg';
      final file = await File(filePath).writeAsBytes(bytes as List<int>);
      path = file.path;
    } catch (e) {
      debugPrint(e.toString());
    }
    print(path);
    return path;
  }
}