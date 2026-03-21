
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:klik_hemat/firebase_service.dart';
import 'package:klik_hemat/font_color_util.dart';
import 'package:klik_hemat/model/perangkat_model.dart';
import 'package:klik_hemat/util.dart';

import 'CustomDropDown.dart';
import 'package:klik_hemat/bottom_nav_screen.dart';

class TbhPerangkatScreen extends StatefulWidget {
  const TbhPerangkatScreen({super.key, required this.mode, required this.model});

  final int mode;
  final PerangkatModel? model;

  @override
  State<TbhPerangkatScreen> createState() => _TbhPerangkatScreenState();
}

class _TbhPerangkatScreenState extends State<TbhPerangkatScreen> {
  final nameController = TextEditingController();
  final dayaController = TextEditingController();
  final durasiController = TextEditingController();

  String selectedJenis = '';
  List<String> jenis = ['Gadget', 'AC', 'Kulkas', 'Kipas Angin', 'Kompor Listrik', 'Lainnya'];

  void add() {
    if (nameController.text.isEmpty || dayaController.text.isEmpty || durasiController.text.isEmpty || selectedJenis.isEmpty) {
      Fluttertoast.showToast(msg: 'Data belum lengkap');
    } else {
      Util.showLoading(context);
      final model = PerangkatModel(DateTime
          .now()
          .millisecondsSinceEpoch, nameController.text, selectedJenis,
          double.parse(dayaController.text), double.parse(durasiController.text));
      FirebaseService.addPerangkat(model).then((e) {
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const BottomNavScreen()), (route) => false);
        Fluttertoast.showToast(msg: 'Berhasil ditambahkan');
      });
    }
  }

  void edit() {
    if (nameController.text.isEmpty || dayaController.text.isEmpty || durasiController.text.isEmpty||selectedJenis.isEmpty) {
      Fluttertoast.showToast(msg: 'Data belum lengkap');
    } else {
      Util.showLoading(context);
      final model = PerangkatModel(widget.model!.id, nameController.text, selectedJenis,
          double.parse(dayaController.text), double.parse(durasiController.text));
      FirebaseService.updatePerangkat(model).then((e) {
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const BottomNavScreen()), (route) => false);
        Fluttertoast.showToast(msg: 'Perubahan disimpan');
      });
    }
  }

  void delete() {
    Util.showLoading(context);
      FirebaseService.deletePerangkat(widget.model!.id.toString()).then((e) {
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const BottomNavScreen()), (route) => false);
        Fluttertoast.showToast(msg: 'Perangkat dihapus');
      });
  }

  @override
  void initState() {
    if (widget.mode == 1) {
      nameController.text = widget.model!.namaPerangkat;
      dayaController.text = widget.model!.daya.toString();
      durasiController.text = widget.model!.durasiHarian.toString();
      selectedJenis = widget.model!.jenisPerangkat;
    }
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
        title:  Text(
          widget.mode == 1 ? 'Ubah Perangkat' :'Tambah Perangkat',
          style: const TextStyle(
              fontFamily: FontColorUtil.fontPoppins, color: Colors.white, fontWeight: FontWeight.w600),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.blue.withOpacity(0.08),
                blurRadius: 15,
                spreadRadius: 2,
                offset: const Offset(0, 5)
              )
            ]
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.12),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.devices_rounded, color: Colors.blue.shade700, size: 28,),
                  ),
                  const SizedBox(width: 16,),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.mode == 1 ? 'Ubah Spesifikasi' : 'Data Perangkat',
                          style: const TextStyle(fontFamily: FontColorUtil.fontPoppins, color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        const SizedBox(height: 2,),
                        Text(
                          widget.mode == 1 ? 'Perbarui data perangkat listrik Anda' : 'Masukkan alat elektronik untuk dihitung',
                          style: const TextStyle(fontFamily: FontColorUtil.fontPoppins, color: Colors.grey, fontSize: 12, height: 1.3),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(height: 32,),
              const Text('Nama Perangkat', style: TextStyle(fontFamily: FontColorUtil.fontPoppins, fontWeight: FontWeight.w600, fontSize: 13, color: Colors.black87),),
              const SizedBox(height: 8,),
              TextFormField(
                controller: nameController,
                keyboardType: TextInputType.text,
                style: const TextStyle(fontFamily: FontColorUtil.fontPoppins, fontSize: 14),
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.label_outline_rounded, color: Colors.grey.shade400, size: 20,),
                    hintText: 'Misal: Kulkas Dapur',
                    hintStyle: const TextStyle(
                        fontFamily: FontColorUtil.fontPoppins,
                        fontSize: 14,
                        color: Colors.grey),
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade300)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colors.blue)),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12))),
              ),
              const SizedBox(height: 20,),
              const Text('Jenis Perangkat', style: TextStyle(fontFamily: FontColorUtil.fontPoppins, fontWeight: FontWeight.w600, fontSize: 13, color: Colors.black87),),
              const SizedBox(height: 8,),
              CustomDropdown(
                genders: jenis,
                onSelected: (v) {
                  setState(() {
                    selectedJenis = v;
                  });
                },
                value: selectedJenis,
                hint: 'Pilih Jenis Perangkat...',
                prefixIcon: Icons.category_rounded,
              ),
              const SizedBox(height: 20,),
              const Text('Daya Listrik (Watt)', style: TextStyle(fontFamily: FontColorUtil.fontPoppins, fontWeight: FontWeight.w600, fontSize: 13, color: Colors.black87),),
              const SizedBox(height: 8,),
              TextFormField(
                controller: dayaController,
                keyboardType: TextInputType.number,
                style: const TextStyle(fontFamily: FontColorUtil.fontPoppins, fontSize: 14),
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.bolt_rounded, color: Colors.grey.shade400, size: 20,),
                    hintText: 'Misal: 350',
                    hintStyle: const TextStyle(
                        fontFamily: FontColorUtil.fontPoppins,
                        fontSize: 14,
                        color: Colors.grey),
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade300)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colors.blue)),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12))),
              ),
              const SizedBox(height: 20,),
              const Text('Durasi Penggunaan (Jam/Hari)', style: TextStyle(fontFamily: FontColorUtil.fontPoppins, fontWeight: FontWeight.w600, fontSize: 13, color: Colors.black87),),
              const SizedBox(height: 8,),
              TextFormField(
                controller: durasiController,
                keyboardType: TextInputType.number,
                style: const TextStyle(fontFamily: FontColorUtil.fontPoppins, fontSize: 14),
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.schedule_rounded, color: Colors.grey.shade400, size: 20,),
                    hintText: 'Misal: 12',
                    hintStyle: const TextStyle(
                        fontFamily: FontColorUtil.fontPoppins,
                        fontSize: 14,
                        color: Colors.grey),
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade300)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colors.blue)),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12))),
              ),
              const SizedBox(height: 32,),
              ElevatedButton(
                onPressed: () {
                  if (widget.mode == 1) {
                    edit();
                  } else {
                    add();
                  }
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[700],
                    minimumSize: const Size(double.infinity, 54),
                    elevation: 4,
                    shadowColor: Colors.blue.withOpacity(0.4),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)
                    )
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(widget.mode == 1 ? Icons.save_rounded : Icons.add_circle_outline_rounded, color: Colors.white,),
                    const SizedBox(width: 8,),
                    Text(
                      widget.mode == 1 ? 'Simpan Perubahan' : 'Tambahkan Perangkat',
                      style: const TextStyle(
                        fontFamily: FontColorUtil.fontPoppins,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 16
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16,),
              widget.mode == 1 ? ElevatedButton(
                onPressed: () {
                  delete();
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade50,
                    minimumSize: const Size(double.infinity, 54),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)
                    )
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.delete_outline_rounded, color: Colors.red.shade700,),
                    const SizedBox(width: 8,),
                    Text(
                      'Hapus Perangkat',
                      style: TextStyle(
                        fontFamily: FontColorUtil.fontPoppins,
                        color: Colors.red.shade700,
                        fontWeight: FontWeight.w600,
                        fontSize: 16
                      ),
                    ),
                  ],
                ),
              ) : const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
