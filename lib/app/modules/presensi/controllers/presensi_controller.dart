import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class PresensiController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Rx<DateTime?> selectedDate = Rx<DateTime?>(null);
  RxInt selectedMonth = RxInt(0);
  RxInt selectedYear = RxInt(0);
  var name = ''.obs;
  var unit = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchUserProfile();
  }

  void resetFilter() {
    selectedDate.value = null;
    selectedMonth.value = 0;
    selectedYear.value = 0;
  }

  Future<void> filterDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null) {
      selectedDate.value = picked;
      selectedMonth.value = picked.month;
      selectedYear.value = picked.year;
    }
  }

  Future<void> fetchUserProfile() async {
    try {
      User? user = _auth.currentUser;

      if (user != null) {
        DocumentSnapshot snapshot =
            await _firestore.collection('users').doc(user.uid).get();

        if (snapshot.exists) {
          name.value = snapshot['name'] ?? '';
          unit.value = snapshot['unit'] ?? '';
        } else {
          Get.snackbar('Gagal', 'User profile not found.');
        }
      } else {
        Get.snackbar('Gagal', 'User not authenticated.');
      }
    } catch (e) {
      Get.snackbar('Gagal', 'Failed to fetch user profile: $e');
    }
  }

  Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Cek apakah layanan lokasi diaktifkan
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Layanan lokasi tidak diaktifkan.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Izin lokasi ditolak.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception(
        'Izin lokasi secara permanen ditolak. Mohon ubah pengaturan lokasi Anda.',
      );
    }

    // Ambil posisi terbaru setelah semua izin diberikan
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  Future<String> getLocationName(Position position) async {
    List<Placemark> placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );
    Placemark place = placemarks[0];
    return '${place.name}, ${place.locality}, ${place.country}'; // Customize as needed
  }

  Future<List<Map<String, dynamic>>> fetchAttendanceRecords() async {
    try {
      QuerySnapshot querySnapshot =
          await _firestore.collection('presensi').get();
      return querySnapshot.docs.map((doc) {
        var data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id; // Store the document ID
        return data;
      }).toList();
    } catch (e) {
      Get.snackbar('Gagal', 'Failed to fetch attendance records: $e');
      return [];
    }
  }

  void addPresensi(String description, DateTime timestamp, Position position,
      String locationName) async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        print(
            'Latitude: ${position.latitude}, Longitude: ${position.longitude}');
        await _firestore.collection('presensi').add({
          'userId': user.uid,
          'name': name.value,
          'unit': unit.value,
          'date': timestamp,
          'description': description,
          'location': {
            'latitude': position.latitude,
            'longitude': position.longitude,
          },
          'locationName': locationName,
          'isUpdated': false,
        });

        Get.snackbar(
          'Berhasil',
          'Attendance added successfully.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar('Gagal', 'User not authenticated.');
      }
    } catch (e) {
      Get.snackbar(
        "Gagal",
        "Failed to add attendance: $e",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> updatePresensi(String docID, String newDescription) async {
    try {
      DocumentReference docRef = _firestore.collection('presensi').doc(docID);
      DocumentSnapshot docSnapshot = await docRef.get();

      if (docSnapshot.exists && docSnapshot.data() != null) {
        Map<String, dynamic> data = docSnapshot.data() as Map<String, dynamic>;
        bool isUpdated =
            data.containsKey('isUpdated') ? data['isUpdated'] as bool : false;

        if (isUpdated) {
          Get.snackbar('Info', 'Kamu hanya bisa rubah deskripsi.');
          return;
        }

        await docRef.update({
          'description': newDescription,
          'isUpdated': true,
        });

        Get.snackbar(
          'Berhasil',
          'Presensi berhasil di update',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          'Gagal',
          'Presensi tidak ditemukan.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Gagal',
        'Presensi tidak berhasil di update: $e',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Stream<List<Map<String, dynamic>>> fetchAttendanceRecordsStream(
      [DateTime? date]) {
    User? user = _auth.currentUser;
    if (user == null) {
      return Stream.value([]);
    }

    Query query = _firestore
        .collection('presensi')
        .where('userId', isEqualTo: user.uid); // Filter by userId

    // Filter by selected date if provided
    if (date != null) {
      DateTime startDate = DateTime(date.year, date.month, date.day);
      DateTime endDate = DateTime(date.year, date.month, date.day, 23, 59, 59);
      query = query
          .where('date', isGreaterThanOrEqualTo: startDate)
          .where('date', isLessThanOrEqualTo: endDate);
    }

    return query.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        var data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id; // Store the document ID
        return data;
      }).toList();
    });
  }

  Future<void> deletePresensi(String docID) async {
    try {
      await _firestore.collection('presensi').doc(docID).delete();
      Get.snackbar(
        'Berhasil',
        'Presensi berhasil di hapus',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Gagal',
        'Presensi tidak berhasil di hapus: $e',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
