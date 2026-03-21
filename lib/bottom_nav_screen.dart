
import 'package:flutter/material.dart';
import 'package:klik_hemat/font_color_util.dart';
import 'package:klik_hemat/home_screen.dart';
import 'package:klik_hemat/informasi_screen.dart';
import 'package:klik_hemat/kebutuhan_listrik_screen.dart';
import 'package:klik_hemat/daftar_perangkat_screen.dart';
import 'package:klik_hemat/laporan_screen.dart';
import 'package:klik_hemat/rekomendasi_screen.dart';

class BottomNavScreen extends StatefulWidget {
  const BottomNavScreen({super.key});

  @override
  State<BottomNavScreen> createState() => _BottomNavScreenState();
}

class _BottomNavScreenState extends State<BottomNavScreen> {

  int _navIndex = 2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true, // Let body flow behind the notch
      body: _navIndex == 0 ? const DaftarPerangkatScreen() 
          : _navIndex == 1 ? const LaporanScreen() 
          : _navIndex == 2 ? const HomeScreen() 
          : _navIndex == 3 ? const KebutuhanListrikScreen() 
          : const InformasiScreen(),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.only(left: 12, right: 12, bottom: 24),
        padding: const EdgeInsets.only(top: 8, bottom: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.blue.withOpacity(0.12),
              blurRadius: 15,
              spreadRadius: 2,
              offset: const Offset(0, 5),
            )
          ]
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: MediaQuery.removePadding(
            context: context,
            removeBottom: true,
            child: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.white,
            elevation: 0,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.list_alt),
                label: 'Perangkat',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.receipt_long), 
                label: 'Laporan',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.home_filled), 
                label: 'Utama',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.energy_savings_leaf), 
                label: 'Hitung',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person), 
                label: 'Profil',
              ),
            ],
            showUnselectedLabels: true,
            selectedItemColor: Colors.blue[700],
            unselectedItemColor: Colors.grey[400],
            selectedLabelStyle: const TextStyle(
              fontFamily: FontColorUtil.fontPoppins,
              fontSize: 10,
              fontWeight: FontWeight.bold
            ),
            unselectedLabelStyle: const TextStyle(
              fontFamily: FontColorUtil.fontPoppins,
              fontSize: 10
            ),
            onTap: (e) {
              setState(() {
                _navIndex = e;
              });
            },
            currentIndex: _navIndex,
          ),
          ),
        ),
      ),
    );
  }
}
