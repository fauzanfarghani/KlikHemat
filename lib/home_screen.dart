import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:klik_hemat/firebase_service.dart';
import 'package:klik_hemat/font_color_util.dart';
import 'package:klik_hemat/informasi_screen.dart';
import 'package:klik_hemat/kebutuhan_listrik_screen.dart';
import 'package:klik_hemat/laporan_screen.dart';
import 'package:klik_hemat/login_screen.dart';
import 'package:klik_hemat/model/user_model.dart';
import 'package:klik_hemat/rekomendasi_screen.dart';
import 'package:klik_hemat/tbh_perangkat_screen.dart';
import 'package:klik_hemat/daftar_perangkat_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  var name = '';
  var profileUrl = '';

  @override
  void initState() {
    FirebaseDatabase.instance.ref().child('Users').child(FirebaseAuth.instance.currentUser!.uid).onValue.listen((e) {
      final data = UserModel.fromMap(e.snapshot.value as Map<Object?, dynamic>);
      if (mounted) {
        setState(() {
          name = data.nama;
          profileUrl = data.profileUrl;
        });
      }
    });

    FirebaseService.user().then((e) {
    });

    super.initState();
  }

  Widget _buildActionCard(BuildContext context, String title, IconData icon, Widget destination) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => destination)),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.blue.withOpacity(0.12),
              blurRadius: 15,
              spreadRadius: 2,
              offset: const Offset(0, 8),
            )
          ]
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.lightBlue.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: Colors.blue[700], size: 36,),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: FontColorUtil.fontPoppins,
                color: Colors.blue[900],
                fontWeight: FontWeight.w600,
                fontSize: 13
              ),
            )
          ]
        )
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(top: 60, bottom: 40, left: 24, right: 16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue[700]!, Colors.lightBlue],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(35),
                bottomRight: Radius.circular(35),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Welcome Back,',
                        style: TextStyle(
                            fontFamily: FontColorUtil.fontPoppins,
                            color: Colors.white70,
                            fontSize: 14),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        name,
                        style: const TextStyle(
                            fontFamily: FontColorUtil.fontPoppins,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 22),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                    Container(
                      height: 56,
                      width: 56,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 4)
                            )
                          ]),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: CachedNetworkImage(
                          imageUrl: profileUrl,
                          fit: BoxFit.cover,
                          placeholder: (_, __) => Image.asset('asset/images/p_placeholder.png'),
                          errorWidget: (_,__,___) => Image.asset('asset/images/p_placeholder.png'),
                        ),
                      ),
                    ),
              ],
            ),
          ),
          Expanded(
            child: GridView.count(
              shrinkWrap: true,
              crossAxisCount: 2,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
              padding: const EdgeInsets.all(24),
              children: [
                _buildActionCard(context, 'Hitung\nListrik', Icons.energy_savings_leaf, const KebutuhanListrikScreen()),
                _buildActionCard(context, 'Laporan\nPenggunaan', Icons.receipt_long, const LaporanScreen()),
                _buildActionCard(context, 'Tambah\nPerangkat', Icons.add_circle_outline, const TbhPerangkatScreen(mode: 0, model: null)),
                _buildActionCard(context, 'Daftar\nPerangkat', Icons.list_alt, const DaftarPerangkatScreen()),
                _buildActionCard(context, 'Rekomendasi\nPenghematan', Icons.recommend, const RekomendasiScreen()),
                _buildActionCard(context, 'Informasi\nPribadi', Icons.person_outline, const InformasiScreen()),
              ]
            )
          )
        ],
      ),
    );
  }
}
