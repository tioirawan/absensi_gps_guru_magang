import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:latlong2/latlong.dart';

class AttendancePage extends StatefulWidget {
  const AttendancePage({super.key});

  @override
  State<AttendancePage> createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  final MapController mapController = MapController();

  int _selectedPekerjaan = 2;

  bool _isLaptop = false;
  bool _isKomputer = false;
  bool _isHP = false;
  bool _isLainya = false;

  String _suasanaHati = "Senang";

  File? image;

  double? _latitude;
  double? _longitude;

  /// Determine the current position of the device.
  ///
  /// When the location services are not enabled or permissions
  /// are denied the `Future` will return an error.
  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

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
              if (image != null) Image.file(image!),
              const SizedBox(height: 24),
              if (_latitude != null && _longitude != null)
                Text(
                    "Lokasi: ${_latitude!.toString()}, ${_longitude!.toString()}"),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: () async {
                  final Position position = await _determinePosition();

                  mapController.move(
                    LatLng(position.latitude, position.longitude),
                    16,
                  );

                  print("Fake GPS: ${position.isMocked}");
                  setState(() {
                    _latitude = position.latitude;
                    _longitude = position.longitude;
                  });
                },
                style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(56),
                ),
                child: const Text("Update Lokasi"),
              ),
              SizedBox(
                height: 300,
                child: FlutterMap(
                  mapController: mapController,
                  children: [
                    // open street map
                    TileLayer(
                      urlTemplate:
                          "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                      subdomains: const ['a', 'b', 'c'],
                      minNativeZoom: 2,
                      maxNativeZoom: 18,
                    ),
                    MarkerLayer(markers: [
                      if (_latitude != null && _longitude != null)
                        Marker(
                          point: LatLng(_latitude!, _longitude!),
                          child: const Icon(
                            Icons.location_on,
                            color: Colors.red,
                          ),
                        ),
                    ]),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
