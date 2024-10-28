import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController unitController = TextEditingController();
  final TextEditingController statusController = TextEditingController();
  final TextEditingController genderController = TextEditingController();

  final List<String> units = [
    'Deputi 1',
    'Deputi 2',
    'Deputi 3',
    'Deputi 4',
    'Deputi 5',
    'Deputi 6',
    'Biro',
    'sipd'
  ];
  final List<String> gender = ['Wanita', 'Laki Laki'];

  final List<String> status = ['Penggawai', 'admin'];

  void register() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    String name = nameController.text.trim();
    String phone = phoneController.text.trim();
    String unit = unitController.text.trim();
    String status = statusController.text.trim();
    String gender = genderController.text.trim();

    if (email.isEmpty ||
        password.isEmpty ||
        name.isEmpty ||
        phone.isEmpty ||
        unit.isEmpty ||
        status.isEmpty ||
        gender.isEmpty) {
      Get.snackbar(
        'Error',
        'Isi semua kolom.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return;
    }

    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await userCredential.user!.sendEmailVerification();
      String uid = userCredential.user!.uid;

      await _firestore.collection('users').doc(uid).set({
        'name': name,
        'email': email,
        'phone': phone,
        'unit': unit,
        'status': status,
        'gender': gender,
      });

      Get.snackbar(
        'Berhasil',
        'Verifikasi akun anda melalui email',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      Get.offAllNamed('/login');
    } catch (e) {
      Get.snackbar(
        'Gagal',
        e.toString(),
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    phoneController.dispose();
    unitController.dispose();
    statusController.dispose();
    genderController.dispose();
    super.dispose();
  }
}
