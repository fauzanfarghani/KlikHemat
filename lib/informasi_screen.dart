import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:klik_hemat/firebase_service.dart';
import 'package:klik_hemat/font_color_util.dart';
import 'package:klik_hemat/model/perangkat_model.dart';
import 'package:klik_hemat/tbh_perangkat_screen.dart';
import 'package:klik_hemat/util.dart';
import 'package:klik_hemat/widget/perangkat_item.dart';
import 'package:klik_hemat/bottom_nav_screen.dart';
import 'package:klik_hemat/login_screen.dart';


class InformasiScreen extends StatefulWidget {
  const InformasiScreen({super.key});

  @override
  State<InformasiScreen> createState() => _InformasiScreenState();
}

class _InformasiScreenState extends State<InformasiScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final addressController = TextEditingController();
  final noController = TextEditingController();

  File? file = null;
  String imageUrl = '';

  void updateUser() {
    if (nameController.text.isEmpty || emailController.text.isEmpty) {
      Fluttertoast.showToast(msg: 'Data Belum Lengkap');
      return;
    }
    Util.showLoading(context);
    FirebaseService.updateUser(file, nameController.text, addressController.text, noController.text).whenComplete(() {
      Fluttertoast.showToast(msg: 'Update Berhasil');
      Navigator.pop(context);
    }).catchError((e) {
      Navigator.pop(context);
      Fluttertoast.showToast(msg: e);
    });
  }

  void showChangePasswordDialog() {
    final oldPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24))
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
            left: 24,
            right: 24,
            top: 32
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text('Ubah Password', style: TextStyle(fontFamily: FontColorUtil.fontPoppins, fontWeight: FontWeight.bold, fontSize: 18),),
              const SizedBox(height: 8,),
              const Text('Silakan masukkan password lama dan password baru Anda.', style: TextStyle(fontFamily: FontColorUtil.fontPoppins, fontSize: 13, color: Colors.black54),),
              const SizedBox(height: 24,),
              
              TextFormField(
                controller: oldPasswordController,
                obscureText: true,
                style: const TextStyle(fontFamily: FontColorUtil.fontPoppins, fontSize: 14),
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.lock_outline_rounded, color: Colors.grey.shade400, size: 20,),
                    hintText: 'Password Lama',
                    hintStyle: const TextStyle(fontFamily: FontColorUtil.fontPoppins, fontSize: 14, color: Colors.grey),
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)),
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.blue)),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
              ),
              const SizedBox(height: 16,),
              
              TextFormField(
                controller: newPasswordController,
                obscureText: true,
                style: const TextStyle(fontFamily: FontColorUtil.fontPoppins, fontSize: 14),
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.lock_reset_rounded, color: Colors.grey.shade400, size: 20,),
                    hintText: 'Password Baru',
                    hintStyle: const TextStyle(fontFamily: FontColorUtil.fontPoppins, fontSize: 14, color: Colors.grey),
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)),
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.blue)),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
              ),
              const SizedBox(height: 16,),
              
              TextFormField(
                controller: confirmPasswordController,
                obscureText: true,
                style: const TextStyle(fontFamily: FontColorUtil.fontPoppins, fontSize: 14),
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.lock_reset_rounded, color: Colors.grey.shade400, size: 20,),
                    hintText: 'Konfirmasi Password Baru',
                    hintStyle: const TextStyle(fontFamily: FontColorUtil.fontPoppins, fontSize: 14, color: Colors.grey),
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)),
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.blue)),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
              ),
              const SizedBox(height: 24,),
              
              ElevatedButton(
                onPressed: () {
                  if (newPasswordController.text != confirmPasswordController.text) {
                    Fluttertoast.showToast(msg: 'Konfirmasi password tidak cocok');
                    return;
                  }
                  if (newPasswordController.text.length < 6) {
                    Fluttertoast.showToast(msg: 'Password minimal 6 karakter');
                    return;
                  }
                  Util.showLoading(context);
                  FirebaseService.changePassword(oldPasswordController.text, newPasswordController.text).then((_) {
                    Fluttertoast.showToast(msg: 'Password berhasil diganti');
                    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const BottomNavScreen()), (route) => false);
                  }).catchError((e) {
                    Navigator.pop(context); // pop the loading dialog
                    Fluttertoast.showToast(msg: e);
                  });
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[700],
                    minimumSize: const Size(double.infinity, 54),
                    elevation: 4,
                    shadowColor: Colors.blue.withOpacity(0.4),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))
                ),
                child: const Text('Simpan Password Baru', style: TextStyle(fontFamily: FontColorUtil.fontPoppins, color: Colors.white, fontWeight: FontWeight.w600, fontSize: 16),),
              ),
            ],
          )
        );
      }
    );
  }

  @override
  void initState() {
    FirebaseService.user().then((e) {
      nameController.text = e.nama;
      emailController.text = e.email;
      addressController.text = e.alamat;
      noController.text = e.nomorTelepon.toString();
      setState(() {
        imageUrl = e.profileUrl;
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
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Informasi Pribadi',
          style: TextStyle(
              fontFamily: FontColorUtil.fontPoppins, 
              color: Colors.white, 
              fontWeight: FontWeight.w600),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 24.0, left: 24.0, right: 24.0, bottom: 90.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // CARD 1: Profil Pribadi
              Container(
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
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(
                      child: GestureDetector(
                        onTap: () async {
                          final ImagePicker picker = ImagePicker();
                          final XFile? image = await picker.pickImage(source: ImageSource.gallery);
                          if (image != null) {
                            setState(() {
                              file = File(image.path);
                            });
                          }
                        },
                        child: Stack(
                          children: [
                            Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.blue.shade100, width: 3),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: file != null ? Image.file(file!, fit: BoxFit.cover,) : CachedNetworkImage(
                                  imageUrl: imageUrl,
                                  fit: BoxFit.cover,
                                  placeholder: (_, __) => Image.asset(
                                    'asset/images/p_placeholder.png',
                                    fit: BoxFit.cover,
                                  ),
                                  errorWidget: (_, __, ___) => Image.asset(
                                    'asset/images/p_placeholder.png',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: Colors.blue.shade600,
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.white, width: 2),
                                ),
                                child: const Icon(
                                  Icons.camera_alt_rounded,
                                  color: Colors.white,
                                  size: 16,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 32,),

                    const Text('Nama Lengkap', style: TextStyle(fontFamily: FontColorUtil.fontPoppins, fontWeight: FontWeight.w600, fontSize: 13, color: Colors.black87),),
                    const SizedBox(height: 8,),
                    TextFormField(
                      controller: nameController,
                      keyboardType: TextInputType.text,
                      style: const TextStyle(fontFamily: FontColorUtil.fontPoppins, fontSize: 14),
                      decoration: InputDecoration(
                          prefixIcon: Icon(Icons.person_outline_rounded, color: Colors.grey.shade400, size: 20,),
                          hintText: 'Misal: John Doe',
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

                    const Text('Alamat Email', style: TextStyle(fontFamily: FontColorUtil.fontPoppins, fontWeight: FontWeight.w600, fontSize: 13, color: Colors.black87),),
                    const SizedBox(height: 8,),
                    TextFormField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      style: const TextStyle(fontFamily: FontColorUtil.fontPoppins, fontSize: 14, color: Colors.black45),
                      readOnly: true,
                      decoration: InputDecoration(
                          prefixIcon: Icon(Icons.email_outlined, color: Colors.grey.shade400, size: 20,),
                          hintText: 'Email Anda',
                          hintStyle: const TextStyle(
                              fontFamily: FontColorUtil.fontPoppins,
                              fontSize: 14,
                              color: Colors.grey),
                          filled: true,
                          fillColor: Colors.grey.shade50,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.grey.shade200)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.grey.shade200)),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12))),
                    ),
                    const SizedBox(height: 20,),

                    const Text('Alamat Domisili', style: TextStyle(fontFamily: FontColorUtil.fontPoppins, fontWeight: FontWeight.w600, fontSize: 13, color: Colors.black87),),
                    const SizedBox(height: 8,),
                    TextFormField(
                      controller: addressController,
                      keyboardType: TextInputType.text,
                      style: const TextStyle(fontFamily: FontColorUtil.fontPoppins, fontSize: 14),
                      decoration: InputDecoration(
                          prefixIcon: Icon(Icons.location_on_outlined, color: Colors.grey.shade400, size: 20,),
                          hintText: 'Misal: Jl. Mawar No. 10',
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

                    const Text('Nomor Telepon', style: TextStyle(fontFamily: FontColorUtil.fontPoppins, fontWeight: FontWeight.w600, fontSize: 13, color: Colors.black87),),
                    const SizedBox(height: 8,),
                    TextFormField(
                      controller: noController,
                      keyboardType: TextInputType.phone,
                      style: const TextStyle(fontFamily: FontColorUtil.fontPoppins, fontSize: 14),
                      decoration: InputDecoration(
                          prefixIcon: Icon(Icons.phone_android_rounded, color: Colors.grey.shade400, size: 20,),
                          hintText: 'Misal: 08123456789',
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
                        updateUser();
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
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.save_rounded, color: Colors.white,),
                          SizedBox(width: 8,),
                          Text(
                            'Simpan Profil',
                            style: TextStyle(
                              fontFamily: FontColorUtil.fontPoppins,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 16
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 24,),
              
              // CARD 2: Pengaturan Akun
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      blurRadius: 15,
                      spreadRadius: 2,
                      offset: const Offset(0, 5)
                    )
                  ]
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Pengaturan Akun',
                      style: TextStyle(fontFamily: FontColorUtil.fontPoppins, fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black87),
                    ),
                    const SizedBox(height: 16,),
                    
                    OutlinedButton(
                      onPressed: () {
                        showChangePasswordDialog();
                      },
                      style: OutlinedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 54),
                          side: BorderSide(color: Colors.blue.shade700, width: 2),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16)
                          )
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.password_rounded, color: Colors.blue.shade700,),
                          const SizedBox(width: 8,),
                          Text(
                            'Ubah Password',
                            style: TextStyle(
                              fontFamily: FontColorUtil.fontPoppins,
                              color: Colors.blue.shade700,
                              fontWeight: FontWeight.w600,
                              fontSize: 16
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16,),
                    
                    OutlinedButton(
                      onPressed: () {
                        FirebaseAuth.instance.signOut();
                        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const LoginScreen()), (Route<dynamic> route) => false);
                      },
                      style: OutlinedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 54),
                          side: BorderSide(color: Colors.red.shade400, width: 2),
                          backgroundColor: Colors.red.shade50,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16)
                          )
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.logout_rounded, color: Colors.red.shade600,),
                          const SizedBox(width: 8,),
                          Text(
                            'Keluar Akun',
                            style: TextStyle(
                              fontFamily: FontColorUtil.fontPoppins,
                              color: Colors.red.shade600,
                              fontWeight: FontWeight.w600,
                              fontSize: 16
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
