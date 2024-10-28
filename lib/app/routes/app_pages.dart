import 'package:get/get.dart';

import 'package:absen/app/modules/AdminHome/bindings/admin_home_binding.dart';
import 'package:absen/app/modules/AdminHome/views/admin_home_view.dart';
import 'package:absen/app/modules/home/bindings/home_binding.dart';
import 'package:absen/app/modules/home/views/home_view.dart';
import 'package:absen/app/modules/login/bindings/login_binding.dart';
import 'package:absen/app/modules/login/views/login_view.dart';
import 'package:absen/app/modules/presensi/bindings/presensi_binding.dart';
import 'package:absen/app/modules/presensi/views/presensi_view.dart';
import 'package:absen/app/modules/profile/bindings/profile_binding.dart';
import 'package:absen/app/modules/profile/views/profile_view.dart';
import 'package:absen/app/modules/register/bindings/register_binding.dart';
import 'package:absen/app/modules/register/views/register_view.dart';
import 'package:absen/app/modules/splash/bindings/splash_binding.dart';
import 'package:absen/app/modules/splash/views/splash_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();
  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.REGISTER,
      page: () => RegisterView(),
      binding: RegisterBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.SPLASH,
      page: () => SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: _Paths.ADMIN_HOME,
      page: () => AdminHomeView(),
      binding: AdminHomeBinding(),
    ),
    GetPage(
      name: _Paths.PROFILE,
      page: () => ProfileView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: _Paths.PRESENSI,
      page: () => PresensiView(),
      binding: PresensiBinding(),
    ),
  ];
}
