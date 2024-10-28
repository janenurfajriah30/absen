import 'package:absen/app/routes/app_pages.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void login() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      Get.snackbar(
        'Gagal',
        'Email dan password harus diisi.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    try {
      // Attempt to sign in with email and password
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Check if the user's email is verified
      if (!userCredential.user!.emailVerified) {
        Get.snackbar(
          'Gagal',
          'Verifikasi email terlebih dahulu.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      // Fetch user data from Firestore
      DocumentSnapshot snapshot = await _firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .get();

      if (snapshot.exists) {
        // Check the 'status' field in the user's data
        String status = snapshot['status'] ?? 'user';

        // Navigate based on the user's status
        if (status == 'admin') {
          Get.offAllNamed(Routes.ADMIN_HOME); // Navigate to the admin home
        } else {
          Get.offAllNamed(Routes.HOME); // Navigate to the user home
        }
      } else {
        Get.snackbar(
          'Gagal',
          'Pengguna tidak ditemukan.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Terjadi kesalahan: ${e.toString()}',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
