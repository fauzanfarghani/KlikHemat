import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:klik_hemat/CustomDropDown.dart';
import 'package:klik_hemat/detail_kbth_screen.dart';
import 'package:klik_hemat/firebase_service.dart';
import 'package:klik_hemat/font_color_util.dart';
import 'package:klik_hemat/model/kalkulasi_model.dart';
import 'package:klik_hemat/util.dart';
import 'package:klik_hemat/widget/kbth_listrik_item.dart';

class KebutuhanListrikScreen extends StatefulWidget {
  const KebutuhanListrikScreen({super.key});

  @override
  State<KebutuhanListrikScreen> createState() => _KebutuhanListrikScreenState();
}

class _KebutuhanListrikScreenState extends State<KebutuhanListrikScreen> {
  final periode = ['6 Jam', '1 Hari', '1 Bulan'];
  String selectedPeriode = '';
  List<KalkulasiModel> list = [];



  void calculate() {
    if (selectedPeriode.isNotEmpty) {
      Util.showLoading(context);
      FirebaseService.allPerangkat().then((e) {
        if (e.isNotEmpty) {
          var totalDailyKwh = 0.0;
          for (var a in e) {
            // kWh per hari = (Daya (Watt) * Durasi per Hari (Jam)) / 1000
            totalDailyKwh += (a.daya * a.durasiHarian) / 1000;
          }
          var multiplier = selectedPeriode == '6 Jam'
              ? 0.25
              : selectedPeriode == '1 Hari'
                  ? 1.0
                  : 30.0;
          var actualKwh = totalDailyKwh * multiplier;
          var totalBiaya = actualKwh * 1467;
          final model = KalkulasiModel(DateTime.now().millisecondsSinceEpoch,
              selectedPeriode, actualKwh, totalBiaya, e);
          FirebaseService.addKalkulasi(model).whenComplete(() {
            Navigator.pop(context);
            Fluttertoast.showToast(msg: 'Sukses');
          });
        } else {
          Fluttertoast.showToast(msg: 'Belum ada perangkat');
        }
      });
    } else {
      Fluttertoast.showToast(msg: 'Pilih Periode');
    }
  }

  @override
  void initState() {
    FirebaseDatabase.instance.ref().child('Kalkulasi').child(FirebaseAuth.instance.currentUser!.uid).onValue.listen((e) {
        list.clear();
        for (var e in e.snapshot.children) {
          final model = KalkulasiModel.fromMap(e.value as Map<Object?, dynamic>);
          list.insert(0, model);
        }
        if (mounted) {
          setState(() {
          });
        }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Hitung Listrik',
          style: TextStyle(
              fontFamily: FontColorUtil.fontPoppins, color: Colors.white, fontWeight: FontWeight.w600),
        ),
        elevation: 0,
      ),
      backgroundColor: Colors.grey.shade200,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.08),
                    blurRadius: 20,
                    spreadRadius: 2,
                    offset: const Offset(0, 8)
                  )
                ]
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.orange.withOpacity(0.12),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.electric_bolt_rounded, color: Colors.orange.shade700, size: 28,),
                      ),
                      const SizedBox(width: 16,),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Estimasi Biaya',
                              style: TextStyle(fontFamily: FontColorUtil.fontPoppins, color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                            SizedBox(height: 2,),
                            Text(
                              'Kalkulasi total tarif berdasarkan pemakaian perangkat',
                              style: TextStyle(fontFamily: FontColorUtil.fontPoppins, color: Colors.grey, fontSize: 12, height: 1.3),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 24,),
                  const Text(
                    'Pilih Periode',
                    style: TextStyle(
                        fontFamily: FontColorUtil.fontPoppins, color: Colors.black87, fontWeight: FontWeight.w600, fontSize: 14),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  CustomDropdown(
                    genders: periode,
                    onSelected: (v) {
                      setState(() {
                        selectedPeriode = v;
                      });
                    },
                    value: selectedPeriode,
                    hint: 'Pilih Periode Penggunaan...',
                    prefixIcon: Icons.calendar_month_rounded,
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        calculate();
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue[700],
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          elevation: 4,
                          shadowColor: Colors.blue.withOpacity(0.4),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16))),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.calculate_rounded, color: Colors.white,),
                          SizedBox(width: 10,),
                          Text(
                            'Kalkulasi Biaya',
                            style: TextStyle(
                              fontFamily: FontColorUtil.fontPoppins,
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: Colors.white
                            ),
                          ),
                        ],
                      )),
                ],
              ),
            ),
            const SizedBox(
              height: 32,
            ),
            Row(
              children: [
                Icon(Icons.history_rounded, color: Colors.blue.shade700, size: 24,),
                const SizedBox(width: 10,),
                const Text(
                  'Riwayat Kalkulasi',
                  style: TextStyle(
                      fontFamily: FontColorUtil.fontPoppins,
                      color: Colors.black87,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(
              height: 8,
            ),
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
