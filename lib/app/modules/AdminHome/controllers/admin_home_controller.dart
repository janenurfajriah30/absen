// lib/app/modules/home/controllers/home_controller.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class AdminHomeController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void logout() async {
    await _auth.signOut();
    Get.offAllNamed('/login'); // Kembali ke halaman login
  }
}
