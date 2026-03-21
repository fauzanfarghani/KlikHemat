import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:klik_hemat/font_color_util.dart';
import 'package:klik_hemat/login_screen.dart';
import 'package:klik_hemat/register_screen.dart';

import 'bottom_nav_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  startTimer() async {
    try {
      await Future.delayed(const Duration(seconds: 2));
      if (FirebaseAuth.instance.currentUser != null) {
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => BottomNavScreen()), (Route<dynamic> route) => false);
      } else {
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => LoginScreen()), (Route<dynamic> route) => false);
      }
    } catch (e) {
      debugPrint("Error in SplashScreen startTimer: $e");
    }
  }

  @override
  void initState() {
    startTimer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Prominent App Icon Box
            Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(32),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.2),
                    blurRadius: 25,
                    spreadRadius: 2,
                    offset: const Offset(0, 10),
                  )
                ],
                image: const DecorationImage(
                  image: AssetImage('asset/images/app_icon.png'),
                  fit: BoxFit.cover,
                )
              ),
            ),
            const SizedBox(height: 32,),
            // App Name Typography
            Text(
              'Klik Hemat',
              style: TextStyle(
                fontFamily: FontColorUtil.fontPoppins,
                fontSize: 34,
                fontWeight: FontWeight.bold,
                color: Colors.blue[800],
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 12,),
            // Subtitle Tagline
            Text(
              'Solusi Cerdas Kelola Energi',
              style: TextStyle(
                fontFamily: FontColorUtil.fontPoppins,
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
                letterSpacing: 0.5,
              ),
            )
          ],
        ),
      ),
    );
  }
}

