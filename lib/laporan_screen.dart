import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:klik_hemat/font_color_util.dart';
import 'package:klik_hemat/model/kalkulasi_model.dart';
import 'package:klik_hemat/widget/kbth_listrik_item.dart';

import 'detail_kbth_screen.dart';

class LaporanScreen extends StatefulWidget {
  const LaporanScreen({super.key});

  @override
  State<LaporanScreen> createState() => _LaporanScreenState();
}

class _LaporanScreenState extends State<LaporanScreen> {

  List<KalkulasiModel> list = [];

  @override
  void initState() {
    FirebaseDatabase.instance.ref().child('Kalkulasi').child(FirebaseAuth.instance.currentUser!.uid).onValue.listen((e) {
      list.clear();

      for (var e in e.snapshot.children) {
        final model = KalkulasiModel.fromMap(e.value as Map<Object?, dynamic>);
        list.insert(0, model);
      }
setState(() {

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
        title: const Text('Laporan Penggunaan', style: TextStyle(
          fontFamily: FontColorUtil.fontPoppins,
          color: Colors.white,
          fontWeight: FontWeight.w600
        ),),
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Hapus Riwayat?'),
                  content: const Text('Apakah anda yakin ingin menghapus semua riwayat laporan?'),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal')),
                    TextButton(onPressed: () {
                      FirebaseDatabase.instance.ref().child('Kalkulasi').child(FirebaseAuth.instance.currentUser!.uid).remove().then((_) {
                        Navigator.pop(context);
                      });
                    }, child: const Text('Hapus', style: TextStyle(color: Colors.red))),
                  ],
                )
              );
            },
            icon: const Icon(Icons.delete_outline),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    return KbthListrikItem(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>  DetailKbthScreen(model: list[index],)));
                      },
                      model: list[index],
                    );
                  }),
            )
          ],
        ),
      ),
    );
  }
}
