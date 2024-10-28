// lib/app/modules/admin_home/views/admin_home_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/admin_home_controller.dart';

class AdminHomeView extends StatelessWidget {
  final AdminHomeController controller = Get.put(AdminHomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Admin Home')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Welcome, Admin!'),
            ElevatedButton(
              onPressed: () => controller.logout(),
              child: Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}
