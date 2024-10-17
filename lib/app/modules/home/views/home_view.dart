import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../doctor/views/doctor_view.dart';
import '../../patient/views/patient_view.dart';
import '../controllers/home_controller.dart';

class HomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Patient-Doctor Video Call")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => Get.to(() => PatientView()),
              child: const Text("Patient"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Get.to(() => DoctorView()),
              child: const Text("Doctor"),
            ),
          ],
        ),
      ),
    );
  }
}
