import 'package:absen/app/modules/splash/bindings/splash_binding.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app/routes/app_pages.dart';
import 'package:get_storage/get_storage.dart';

void main() async {
  await GetStorage.init();
  await initializeDateFormatting('id_ID', null);
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
    apiKey: "AIzaSyD3YBfP0IaDD5j4PJnERxC-DnmqNEg0J6s",
    appId: "1:581003915596:android:b396864aa8c84ac4f91fe9",
    messagingSenderId: "581003915596",
    projectId: "absensi-1e338",
  ));

  runApp(GetMaterialApp(
    title: "Absensi",
    debugShowCheckedModeBanner: false,
    initialRoute: AppPages.INITIAL,
    getPages: AppPages.routes,
    initialBinding: SplashBinding(),
  ));
}
