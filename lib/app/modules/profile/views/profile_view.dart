import 'package:absen/app/modules/profile/controllers/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileView extends StatelessWidget {
  final ProfileController profileController = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(() {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Menampilkan ikon berdasarkan jenis kelamin di bagian atas
              Container(
                alignment: Alignment.center,
                child: Image.asset(
                  profileController.gender.value == 'Wanita'
                      ? 'assets/images/woman.png'
                      : 'assets/images/man.png',
                  width: 200, // Ukuran gambar
                  height: 200,
                ),
              ),
              SizedBox(height: 16), // Jarak di bawah ikon

              // Informasi pengguna lainnya
              Text("Nama: ${profileController.name.value}",
                  style: TextStyle(fontSize: 20)),
              SizedBox(height: 8),
              Text("Email: ${profileController.email.value}",
                  style: TextStyle(fontSize: 20)),
              SizedBox(height: 8),
              Text("No HP: ${profileController.phone.value}",
                  style: TextStyle(fontSize: 20)),
              SizedBox(height: 8),
              Text("Unit: ${profileController.unit.value}",
                  style: TextStyle(fontSize: 20)),
              SizedBox(height: 8),
              Text("Status: ${profileController.status.value}",
                  style: TextStyle(fontSize: 20)),
              Text(
                "Jenis kelamin: ${profileController.gender.value}",
                style: TextStyle(fontSize: 20),
              ),
            ],
          );
        }),
      ),
    );
  }
}
