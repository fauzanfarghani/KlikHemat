import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:klik_hemat/firebase_service.dart';
import 'package:klik_hemat/font_color_util.dart';
import 'package:klik_hemat/widget/perangkat_item.dart';
import 'package:klik_hemat/widget/rekomendasi_item.dart';
import 'package:url_launcher/url_launcher.dart';

import 'model/rekomendasi_model.dart';

class RekomendasiScreen extends StatefulWidget {
  const RekomendasiScreen({super.key});

  @override
  State<RekomendasiScreen> createState() => _RekomendasiScreenState();
}

class _RekomendasiScreenState extends State<RekomendasiScreen> {

  List<RekomendasiModel> list = [];

  @override
  void initState() {
    FirebaseService.allRekomendasi().then((e) {
      setState(() {
        list = e;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue.shade800, Colors.blue.shade400],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            )
          ),
        ),
        elevation: 0,
        iconTheme: const IconThemeData(
          color: Colors.white
        ),
        title: const Text('Rekomendasi Penghematan', style: TextStyle(
          fontFamily: FontColorUtil.fontPoppins,
          color: Colors.white,
          fontWeight: FontWeight.w600
        ),),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    return RekomendasiItem(onTap: () async {
                      try {
                        launchUrl(Uri.parse(list[index]
                        .url));
                      } catch(e) {

                      }
                    }, model: list[index],);
                  }),
            )
          ],
        ),
      ),
    );
  }
}
