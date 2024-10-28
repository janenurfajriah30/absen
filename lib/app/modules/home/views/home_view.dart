import 'package:absen/app/modules/presensi/views/presensi_view.dart';
import 'package:absen/app/modules/profile/views/profile_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';

class HomeView extends StatelessWidget {
  final HomeController controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text('User Home'),
          actions: [
            IconButton(
              icon: Icon(Icons.logout),
              onPressed: () => controller.logout(),
            ),
          ],
          bottom: TabBar(
            indicatorColor: const Color.fromARGB(255, 14, 1, 39),
            indicatorSize: TabBarIndicatorSize.tab,
            indicatorWeight: 5,
            labelColor: Color.fromARGB(255, 14, 1, 39),
            tabs: [
              Tab(
                child: Text(
                  'Branda',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
              Tab(
                child: Text(
                  'Presensi',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
              Tab(
                child: Text(
                  'Profile',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Replace the following line with the actual view for "Branda" when available
            Center(child: Text('Branda View')), // Placeholder for Branda View
            PresensiView(), // Displaying the Presensi View
            ProfileView(), // Displaying the Profile View
          ],
        ),
      ),
    );
  }
}
