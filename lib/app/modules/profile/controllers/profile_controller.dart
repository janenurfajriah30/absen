import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Observables for user profile fields
  var name = ''.obs;
  var email = ''.obs;
  var phone = ''.obs;
  var unit = ''.obs;
  var status = ''.obs;
  var gender = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchUserProfile(); // Fetch user profile when the controller is initialized
  }

  // Fetch user profile from Firestore
  void fetchUserProfile() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        DocumentSnapshot snapshot =
            await _firestore.collection('users').doc(user.uid).get();

        if (snapshot.exists) {
          name.value = snapshot['name'] ?? '';
          email.value = snapshot['email'] ?? '';
          phone.value = snapshot['phone'] ?? '';
          unit.value = snapshot['unit'] ?? '';
          status.value = snapshot['status'] ?? '';
          gender.value = snapshot['gender'] ?? '';
        }
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch user profile: $e');
    }
  }
}
