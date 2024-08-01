import 'dart:io';

import 'package:absensi_gps/dio_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:latlong2/latlong.dart';

class AttendancePage extends StatefulWidget {
  final Map<String, dynamic>? attendance;

  const AttendancePage({super.key, this.attendance});

  @override
  State<AttendancePage> createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  final MapController mapController = MapController();
  final TextEditingController _deskripsiPekerjaanController =
      TextEditingController();

  final List<String> _pekerjaan = [
    "Mengajar",
    "Penelitian",
    "Pengabdian",
  ];

  int _selectedPekerjaan = 2;

  bool _isLaptop = false;
  bool _isKomputer = false;
  bool _isHP = false;
  bool _isLainya = false;

  String _suasanaHati = "Senang";

  File? image;

  double? _latitude;
  double? _longitude;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    // AkAN DIJALANKAN KETIKA WIDGET PERTAMA KALI TAMPIL/DIBUKA

    if (widget.attendance != null) {
      _deskripsiPekerjaanController.text =
          widget.attendance!['work_description'];
      _selectedPekerjaan = _pekerjaan.indexOf(widget.attendance!['work']);

      if (_selectedPekerjaan == -1) {
        _selectedPekerjaan = 0;
      }

      _isLaptop = widget.attendance!['is_laptop'] == 1;
      _isKomputer = widget.attendance!['is_komputer'] == 1;
      _isHP = widget.attendance!['is_hp'] == 1;
      _isLainya = widget.attendance!['is_lainya'] == 1;
      _suasanaHati = widget.attendance!['mood'];
      _latitude = widget.attendance!['lat'];
      _longitude = widget.attendance!['long'];

      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await Future.delayed(const Duration(milliseconds: 500));
        mapController.move(
          LatLng(_latitude!, _longitude!),
          16,
        );
      });
    }
  }

  bool _isFormValid() {
    final isDeskripsiPekerjaanValid =
        _deskripsiPekerjaanController.text.isNotEmpty;
    final isAlatKerjaSelected = _isLaptop || _isKomputer || _isHP || _isLainya;
    // final isImageSelected = image != null;
    const isImageSelected = true;
    final isLocationSelected = _latitude != null && _longitude != null;

    return isDeskripsiPekerjaanValid &&
        isAlatKerjaSelected &&
        isImageSelected &&
        isLocationSelected;
  }

  void _submitForm() async {
    try {
      final data = FormData.fromMap(
        {
          'work_description': _deskripsiPekerjaanController.text,
          'work': _pekerjaan[_selectedPekerjaan],
          'is_laptop': _isLaptop ? 1 : 0,
          'is_komputer': _isKomputer ? 1 : 0,
          'is_hp': _isHP ? 1 : 0,
          'is_lainya': _isLainya ? 1 : 0,
          'mood': _suasanaHati,
          if (image != null) 'image': MultipartFile.fromFileSync(image!.path),
          'lat': _latitude,
          'long': _longitude,
        },
      );

      final Future<Response> request;

      if (widget.attendance != null) {
        request = dio.post(
          '/attendances/${widget.attendance!['id']}',
          data: data,
          queryParameters: {
            '_method': 'PUT',
          },
        );
      } else {
        request = dio.post(
          '/attendances',
          data: data,
        );
      }

      final response = await request;

      print(response.data);

      Navigator.of(context).pop();
    } on Exception catch (e) {
      print(e);
    }
  }

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
                controller: _deskripsiPekerjaanController,
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
                items: [
                  for (final (i, pekerjaan) in _pekerjaan.indexed)
                    DropdownMenuItem(
                      value: i,
                      child: Text(pekerjaan),
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
              if (image != null)
                if (kIsWeb) Image.network(image!.path) else Image.file(image!),
              const SizedBox(height: 24),
              if (_latitude != null && _longitude != null)
                Text(
                    "Lokasi: ${_latitude!.toString()}, ${_longitude!.toString()}"),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: () async {
                  setState(() {
                    _isLoading = true;
                  });

                  final Position position = await _determinePosition();

                  setState(() {
                    _isLoading = false;
                  });

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
                child: _isLoading
                    ? const CircularProgressIndicator(
                        color: Colors.white,
                      )
                    : const Text("Update Lokasi"),
              ),
              const SizedBox(height: 24),
              SizedBox(
                height: 300,
                child: FlutterMap(
                  mapController: mapController,
                  children: [
                    TileLayer(
                      urlTemplate:
                          "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                      subdomains: const ['a', 'b', 'c'],
                      minNativeZoom: 2,
                      maxNativeZoom: 18,
                    ),
                    // TileLayer(
                    //   urlTemplate:
                    //       "https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}",
                    //   subdomains: const ['server', 'services'],
                    //   minNativeZoom: 2,
                    //   maxNativeZoom: 18,
                    // ),
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
              const SizedBox(height: 24),
              FilledButton(
                onPressed: _isFormValid() ? _submitForm : null,
                style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(56),
                ),
                child: const Text("Kirim"),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
