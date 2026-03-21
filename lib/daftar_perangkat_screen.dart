import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:klik_hemat/font_color_util.dart';
import 'package:klik_hemat/model/perangkat_model.dart';
import 'package:klik_hemat/tbh_perangkat_screen.dart';
import 'package:klik_hemat/widget/perangkat_item.dart';

class DaftarPerangkatScreen extends StatefulWidget {
  const DaftarPerangkatScreen({super.key});

  @override
  State<DaftarPerangkatScreen> createState() => _DaftarPerangkatScreenState();
}

class _DaftarPerangkatScreenState extends State<DaftarPerangkatScreen> {
  List<PerangkatModel> list = [];

  @override
  void initState() {
    super.initState();
    FirebaseDatabase.instance.ref().child('Perangkat').child(FirebaseAuth.instance.currentUser!.uid).onValue.listen((e) {
      list.clear();
      for (var a in e.snapshot.children) {
        final model = PerangkatModel.fromMap(a.value as Map<Object?, dynamic>);
        list.add(model);
      }
      if (mounted) {
        setState(() {});
      }
    });
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
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('Daftar Perangkat', style: TextStyle(fontFamily: FontColorUtil.fontPoppins, color: Colors.white, fontWeight: FontWeight.w600)),
      ),
      body: list.isEmpty 
        ? const Center(child: Text("Belum ada perangkat. Tambahkan perangkat baru!", style: TextStyle(fontFamily: FontColorUtil.fontPoppins, color: Colors.black54),))
        : ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: list.length,
            itemBuilder: (context, index) {
              return PerangkatItem(onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => TbhPerangkatScreen(mode: 1, model: list[index])));
              }, model: list[index], index: index,);
            }
          ),
    );
  }
}
