import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:klik_hemat/model/kalkulasi_model.dart';
import 'package:klik_hemat/model/perangkat_model.dart';
import 'package:klik_hemat/model/rekomendasi_model.dart';
import 'package:klik_hemat/model/user_model.dart';

class FirebaseService {
  static Future<User?> register(UserModel model, String password)async {
    print("FirebaseService.register started for email: ${model.email}");
    try {
      print("Calling FirebaseAuth.createUserWithEmailAndPassword...");
      final user = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: model.email, password: password);
      print("FirebaseAuth user created: ${user.user?.uid}");
      if (user.user != null) {
        print("Adding user data to Realtime Database...");
        await FirebaseDatabase.instance.ref().child('Users').child(user.user!.uid.toString()).set(model.toMap());
        print("User data added successfully");
        return user.user;
      } else {
        print("FirebaseAuth user is null");
        return null;
      }
    } on FirebaseAuthException catch (e) {
      print("FirebaseAuthException in register: ${e.message}");
      return Future.error(e.message.toString());
    } catch (e) {
      print("Unknown error in FirebaseService.register: $e");
      return Future.error(e);
    }
  }

  static Future<User?> login(String email, String password) async {
    print("FirebaseService.login started for email: $email");
    try {
      final user = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
      print("FirebaseService.login success: ${user.user?.uid}");
      return user.user;
    } on FirebaseAuthException catch (e) {
      print("FirebaseAuthException in login: code=${e.code}, message=${e.message}, detail=${e.toString()}");
      return Future.error(e.message.toString());
    } catch (e) {
      print("Unknown error in FirebaseService.login: $e");
      return Future.error(e);
    }
  }

  static Future<List<PerangkatModel>> allPerangkat() async {
    List<PerangkatModel> list = [];
    final dataSnap = await FirebaseDatabase.instance.ref().child('Perangkat').child(FirebaseAuth.instance.currentUser!.uid).get();
    if (dataSnap.exists) {
      dataSnap.children.forEach((e) {
        final model = PerangkatModel.fromMap(e.value as Map<Object?, dynamic>);
        list.add(model);
      });
    }
    return list;
  }

  static Future<List<RekomendasiModel>> allRekomendasi() async {
    List<RekomendasiModel> list = [];
    final dataSnap = await FirebaseDatabase.instance.ref().child('Rekomendasi').get();
    if (dataSnap.exists) {
      dataSnap.children.forEach((e) {
        final model = RekomendasiModel.fromMap(e.value as Map<Object?, dynamic>);
        list.add(model);
      });
    }
    return list;
  }

  static Future<UserModel> user() async {
    final dataSnap = await FirebaseDatabase.instance.ref().child('Users').child(FirebaseAuth.instance.currentUser!.uid).get();
    final model = UserModel.fromMap(dataSnap.value as Map<Object?, dynamic>);
    return model;
  }

  static Future<void> addKalkulasi(KalkulasiModel model) async {
      await FirebaseDatabase.instance.ref().child('Kalkulasi').child(
          FirebaseAuth.instance.currentUser!.uid).child(model.time.toString()).set(model.toMap());
  }

  static Future<void> addPerangkat(PerangkatModel model) async {
    await FirebaseDatabase.instance.ref().child('Perangkat').child(
        FirebaseAuth.instance.currentUser!.uid).child(model.id.toString()).set(model.toMap());
  }

  static Future<void> updatePerangkat(PerangkatModel model) async {
    await FirebaseDatabase.instance.ref().child('Perangkat').child(
        FirebaseAuth.instance.currentUser!.uid).child(model.id.toString()).update(model.toMap());
  }

  static Future<void> deletePerangkat(String id) async {
    await FirebaseDatabase.instance.ref().child('Perangkat').child(
        FirebaseAuth.instance.currentUser!.uid).child(id.toString()).remove();
  }

  static Future<void> updateUser(File? file,String name, String address, String no) async{
    if (file != null) {
      try {
        final save = await FirebaseStorage.instance.ref().child('profile/${FirebaseAuth.instance.currentUser!.uid}').putFile(file,SettableMetadata(
          contentType: 'image/jpeg'
        ));
        if (save.state == TaskState.success) {
          var downUrl = await FirebaseStorage.instance.ref().child('profile/${FirebaseAuth.instance.currentUser!.uid}').getDownloadURL();
          await FirebaseDatabase.instance.ref().child('Users').child(FirebaseAuth.instance.currentUser!.uid.toString()).update(
              {
                'nama': name,
                'alamat': address,
                'nomor_telepon': int.parse(no),
                'profile_url':downUrl
              }
          );
        }
      } on FirebaseException catch(e) {
        return Future.error(e.message.toString());
      } catch(e) {
        return Future.error(e.toString());
      }

    } else {
      await FirebaseDatabase.instance.ref().child('Users').child(FirebaseAuth.instance.currentUser!.uid.toString()).update(
          {
            'nama': name,
            'alamat': address,
            'nomor_telepon': int.parse(no),
          }
      );
    }

  }

  static Future<void> changePassword(String currentPassword, String newPassword) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null || user.email == null) {
        return Future.error('Sesi pengguna tidak valid');
      }
      
      AuthCredential credential = EmailAuthProvider.credential(email: user.email!, password: currentPassword);
      await user.reauthenticateWithCredential(credential);
      await user.updatePassword(newPassword);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password') {
        return Future.error('Password lama salah');
      } else if (e.code == 'weak-password') {
        return Future.error('Password baru terlalu lemah');
      }
      return Future.error(e.message ?? 'Gagal mengganti password');
    } catch (e) {
      return Future.error('Terjadi kesalahan internal. Gagal mengganti password.');
    }
  }
}