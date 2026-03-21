import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:klik_hemat/bottom_nav_screen.dart';
import 'package:klik_hemat/firebase_service.dart';
import 'package:klik_hemat/font_color_util.dart';
import 'package:klik_hemat/model/user_model.dart';
import 'package:klik_hemat/util.dart';

import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordConfController = TextEditingController();

  bool pwObscure = true;
  bool pwConfObscure = true;

  void register() {
    if (nameController.text.isEmpty || emailController.text.isEmpty || passwordController.text.isEmpty || passwordConfController.text.isEmpty) {
      _showToast('Data belum lengkap');
    } else if (passwordConfController.text != passwordController.text) {
      _showToast('Kata sandi tidak sama');
    } else {
      Util.showLoading(context);
      final model = UserModel(emailController.text, 0, nameController.text, '', '');
      FirebaseService.register(model, passwordController.text).then((e) {
        if (e !=null) {
          Navigator.pop(context);
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => BottomNavScreen()), (Route<dynamic> route) => false);
        } else {
          Navigator.pop(context);
        }
      }).catchError((e) {
        Navigator.pop(context);
        _showToast(e.toString());
      });
    }
  }

  void _showToast(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Custom Header Area
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(top: 80, bottom: 60, left: 24, right: 24),
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
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  )
                ]
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Daftar Akun',
                    style: TextStyle(
                      fontFamily: FontColorUtil.fontPoppins,
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Silakan lengkapi data diri Anda untuk memulai.',
                    style: TextStyle(
                      fontFamily: FontColorUtil.fontPoppins,
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 14,
                    ),
                  )
                ],
              ),
            ),
            
            // Register Card Form
            Padding(
              padding: const EdgeInsets.only(left: 24.0, right: 24.0, bottom: 40.0),
              child: Transform.translate(
                offset: const Offset(0, -30),
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.15),
                        blurRadius: 15,
                        spreadRadius: 2,
                        offset: const Offset(0, 8),
                      )
                    ]
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Nama Lengkap',
                        style: TextStyle(fontFamily: FontColorUtil.fontPoppins, fontWeight: FontWeight.w600, fontSize: 13, color: Colors.black87),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: nameController,
                        keyboardType: TextInputType.name,
                        style: const TextStyle(fontFamily: FontColorUtil.fontPoppins, fontSize: 14),
                        decoration: InputDecoration(
                            prefixIcon: Icon(Icons.person_outline_rounded, color: Colors.grey.shade400, size: 20,),
                            hintText: 'Misal: John Doe',
                            hintStyle: const TextStyle(fontFamily: FontColorUtil.fontPoppins, fontSize: 14, color: Colors.grey),
                            filled: true,
                            fillColor: Colors.grey.shade100,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)),
                            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.blue)),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
                      ),
                      
                      const SizedBox(height: 20,),
                      
                      const Text(
                        'Alamat Email',
                        style: TextStyle(fontFamily: FontColorUtil.fontPoppins, fontWeight: FontWeight.w600, fontSize: 13, color: Colors.black87),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        style: const TextStyle(fontFamily: FontColorUtil.fontPoppins, fontSize: 14),
                        decoration: InputDecoration(
                            prefixIcon: Icon(Icons.email_outlined, color: Colors.grey.shade400, size: 20,),
                            hintText: 'Misal: user@gmail.com',
                            hintStyle: const TextStyle(fontFamily: FontColorUtil.fontPoppins, fontSize: 14, color: Colors.grey),
                            filled: true,
                            fillColor: Colors.grey.shade100,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)),
                            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.blue)),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
                      ),
                      
                      const SizedBox(height: 20,),
                      
                      const Text(
                        'Kata Sandi',
                        style: TextStyle(fontFamily: FontColorUtil.fontPoppins, fontWeight: FontWeight.w600, fontSize: 13, color: Colors.black87),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: passwordController,
                        obscureText: pwObscure,
                        keyboardType: TextInputType.visiblePassword,
                        style: const TextStyle(fontFamily: FontColorUtil.fontPoppins, fontSize: 14),
                        decoration: InputDecoration(
                            prefixIcon: Icon(Icons.lock_outline_rounded, color: Colors.grey.shade400, size: 20,),
                            hintText: 'Minimal 6 karakter',
                            hintStyle: const TextStyle(fontFamily: FontColorUtil.fontPoppins, fontSize: 14, color: Colors.grey),
                            filled: true,
                            fillColor: Colors.grey.shade100,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)),
                            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.blue)),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                            suffixIcon: GestureDetector(
                            child: Icon(pwObscure ? Icons.visibility_off : Icons.visibility, color: Colors.grey.shade600,),
                            onTap: () {
                              setState(() {
                                pwObscure = !pwObscure;
                              });
                            },
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 20,),
                      
                      const Text(
                        'Konfirmasi Kata Sandi',
                        style: TextStyle(fontFamily: FontColorUtil.fontPoppins, fontWeight: FontWeight.w600, fontSize: 13, color: Colors.black87),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: passwordConfController,
                        obscureText: pwConfObscure,
                        keyboardType: TextInputType.visiblePassword,
                        style: const TextStyle(fontFamily: FontColorUtil.fontPoppins, fontSize: 14),
                        decoration: InputDecoration(
                            prefixIcon: Icon(Icons.lock_reset_rounded, color: Colors.grey.shade400, size: 20,),
                            hintText: 'Ketik ulang kata sandi',
                            hintStyle: const TextStyle(fontFamily: FontColorUtil.fontPoppins, fontSize: 14, color: Colors.grey),
                            filled: true,
                            fillColor: Colors.grey.shade100,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)),
                            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.blue)),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                            suffixIcon: GestureDetector(
                            child: Icon(pwConfObscure ? Icons.visibility_off : Icons.visibility, color: Colors.grey.shade600,),
                            onTap: () {
                              setState(() {
                                pwConfObscure = !pwConfObscure;
                              });
                            },
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 32,),
                      
                      ElevatedButton(
                        onPressed: () {
                          register();
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
                        child: const Text(
                          'Mendaftar',
                          style: TextStyle(
                            fontFamily: FontColorUtil.fontPoppins,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 16
                          ),
                        ),
                      ),
                      const SizedBox(height: 24,),
                      
                      Center(
                        child: RichText(
                          text: TextSpan(
                          children: [
                            const TextSpan(text: 'Sudah memiliki akun? ', style: TextStyle(
                              fontFamily: FontColorUtil.fontPoppins,
                              color: Colors.black54,
                              fontSize: 13
                            )),
                            TextSpan(text: 'Masuk di sini', style: TextStyle(
                              fontFamily: FontColorUtil.fontPoppins,
                              color: Colors.blue.shade700,
                              fontWeight: FontWeight.w600,
                              fontSize: 13
                            ), recognizer: TapGestureRecognizer()..onTap = () {
                              Navigator.pop(context);
                            }),
                          ]
                        )),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
