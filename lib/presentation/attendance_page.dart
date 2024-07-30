import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AttendancePage extends StatefulWidget {
  const AttendancePage({super.key});

  @override
  State<AttendancePage> createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  int _selectedPekerjaan = 2;

  bool _isLaptop = false;
  bool _isKomputer = false;
  bool _isHP = false;
  bool _isLainya = false;

  String _suasanaHati = "Senang";

  File? image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Attendance"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Deskripsi Pekerjaan',
                ),
              ),
              const SizedBox(height: 24),
              DropdownButtonFormField(
                decoration: const InputDecoration(
                  labelText: 'Pekerjaan',
                ),
                value: _selectedPekerjaan,
                items: const [
                  DropdownMenuItem(
                    value: 1,
                    child: Text("Pekerjaan 1"),
                  ),
                  DropdownMenuItem(
                    value: 2,
                    child: Text("Pekerjaan 2"),
                  ),
                  DropdownMenuItem(
                    value: 3,
                    child: Text("Pekerjaan 3"),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedPekerjaan = value as int;
                  });
                },
              ),
              const SizedBox(height: 24),
              const Text("Alat Kerja:"),
              const SizedBox(height: 8),
              Column(
                children: [
                  CheckboxListTile(
                      title: const Text("Laptop"),
                      value: _isLaptop,
                      onChanged: (value) {
                        setState(() {
                          _isLaptop = value ?? false;
                        });
                      }),
                  CheckboxListTile(
                      title: const Text("Komputer"),
                      value: _isKomputer,
                      onChanged: (value) {
                        setState(() {
                          _isKomputer = value ?? false;
                        });
                      }),
                  CheckboxListTile(
                      title: const Text("HP"),
                      value: _isHP,
                      onChanged: (value) {
                        setState(() {
                          _isHP = value ?? false;
                        });
                      }),
                  CheckboxListTile(
                    title: const Text("Lainya"),
                    value: _isLainya,
                    onChanged: (value) {
                      setState(() {
                        _isLainya = value ?? false;
                      });
                    },
                  ),
                ],
              ),
              const Text("Suasana Hati:"),
              const SizedBox(height: 8),
              Column(
                children: [
                  RadioListTile(
                    title: const Text("Senang"),
                    value: "Senang",
                    groupValue: _suasanaHati,
                    onChanged: (val) {
                      setState(() {
                        _suasanaHati = val!;
                      });
                    },
                  ),
                  RadioListTile(
                    title: const Text("Senang"),
                    value: "Sedih",
                    groupValue: _suasanaHati,
                    onChanged: (val) {
                      setState(() {
                        _suasanaHati = val!;
                      });
                    },
                  ),
                  RadioListTile(
                    title: const Text("Netral"),
                    value: "Netral",
                    groupValue: _suasanaHati,
                    onChanged: (val) {
                      setState(() {
                        _suasanaHati = val!;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: () async {
                  final ImagePicker picker = ImagePicker();

                  final result = await picker.pickImage(
                    source: ImageSource.camera,
                  );

                  setState(() {
                    image = File(result!.path);
                  });
                },
                style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(56),
                ),
                child: const Text("Ambil Selfie"),
              ),
              const SizedBox(height: 24),
              if (image != null) Image.file(image!)
            ],
          ),
        ),
      ),
    );
  }
}
