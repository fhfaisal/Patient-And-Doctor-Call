import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitled1/app/modules/doctor/views/doctor_view.dart';
import 'package:untitled1/app/modules/patient/views/patient_view.dart';
class DoctorListScreen extends StatelessWidget {
  final bool isPatient;

  DoctorListScreen({required this.isPatient});

  final List<Map<String, String>> doctors = [
    {'uid': 'doctor1', 'name': 'Dr. John'},
    {'uid': 'doctor2', 'name': 'Dr. Sarah'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Select a Doctor")),
      body: ListView.builder(
        itemCount: doctors.length,
        itemBuilder: (context, index) {
          final doctor = doctors[index];
          return ListTile(
            title: Text(doctor['name']!),
            onTap: () {
              final channelName = "test";
              if (isPatient) {
                Get.to(() => PatientVideoCallScreen(channelName: channelName));
              } else {
                Get.to(() => DoctorVideoCallScreen(),arguments: channelName);
              }
            },
          );
        },
      ),
    );
  }
}