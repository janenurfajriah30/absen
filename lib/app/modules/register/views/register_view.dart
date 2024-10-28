import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/register_controller.dart';

class RegisterView extends StatelessWidget {
  final RegisterController controller = Get.put(RegisterController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 0, 0, 0),
              Color.fromARGB(184, 241, 235, 234),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 24.0, vertical: 60.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.white,
                  child: const Icon(
                    Icons.person_add,
                    color: Color.fromARGB(255, 95, 16, 1),
                    size: 50,
                  ),
                ),
                const SizedBox(height: 15),
                const Text(
                  'Create an Account',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                _buildTextField(
                  controller: controller.nameController,
                  labelText: 'Name',
                  icon: Icons.person,
                ),
                const SizedBox(height: 15),
                _buildTextField(
                  controller: controller.emailController,
                  labelText: 'Email',
                  icon: Icons.email,
                ),
                const SizedBox(height: 15),
                _buildTextField(
                  controller: controller.passwordController,
                  labelText: 'Password',
                  icon: Icons.lock,
                  obscureText: true,
                ),
                const SizedBox(height: 15),
                _buildTextField(
                  controller: controller.phoneController,
                  labelText: 'Phone',
                  icon: Icons.phone,
                ),
                const SizedBox(height: 15),
                _buildDropdown(
                  controller: controller.unitController,
                  items: controller.units,
                  labelText: 'Unit',
                  icon: Icons.home,
                ),
                const SizedBox(height: 15),
                _buildDropdown(
                  controller: controller.statusController,
                  items: controller.status,
                  labelText: 'Status',
                  icon: Icons.work,
                ),
                const SizedBox(height: 15),
                _buildDropdown(
                  controller: controller.genderController,
                  items: controller.gender,
                  labelText: 'Jenis kelamin',
                  icon: Icons.person,
                ),
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: controller.register,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: const Color.fromARGB(255, 95, 16, 1),
                    backgroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text(
                    'Register',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                TextButton(
                  onPressed: () => Get.back(),
                  child: const Text(
                    'Already have an account? Login here',
                    style: TextStyle(
                      color: Color.fromARGB(255, 95, 16, 1),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required IconData icon,
    bool obscureText = false,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: const TextStyle(color: Colors.white),
        filled: true,
        fillColor: const Color.fromARGB(255, 95, 16, 1),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none,
        ),
        prefixIcon: Icon(icon, color: Colors.white),
      ),
      obscureText: obscureText,
      style: const TextStyle(color: Colors.white),
    );
  }

  Widget _buildDropdown({
    required TextEditingController controller,
    required List<String> items,
    required String labelText,
    required IconData icon,
  }) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: const TextStyle(color: Colors.white),
        filled: true,
        fillColor: const Color.fromARGB(255, 95, 16, 1),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none,
        ),
        prefixIcon: Icon(icon, color: Colors.white),
      ),
      items: items.map((String item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(item, style: const TextStyle(color: Colors.white)),
        );
      }).toList(),
      onChanged: (String? newValue) {
        controller.text = newValue ?? '';
      },
      dropdownColor: const Color.fromARGB(255, 95, 16, 1),
    );
  }
}
