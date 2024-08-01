import 'package:absensi_gps/dio_service.dart';
import 'package:absensi_gps/presentation/attendance_page.dart';
import 'package:absensi_gps/presentation/widgets/attendance_item.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final controller = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: controller,
                children: const [
                  HomePage1(
                    scrollKey: "home_page_1",
                  ),
                  HomePage1(
                    scrollKey: "home_page_2",
                  ),
                  HomePage1(
                    scrollKey: "home_page_3",
                  ),
                ],
              ),
            ),
            BottomNavigation(
              onItemSelected: (index) {
                controller.animateToPage(
                  index,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class HomePage1 extends StatefulWidget {
  final String scrollKey;

  const HomePage1({
    super.key,
    required this.scrollKey,
  });

  @override
  State<HomePage1> createState() => _HomePage1State();
}

class _HomePage1State extends State<HomePage1> {
  Future<Response>? _future;

  @override
  void initState() {
    super.initState();

    loadAttendances();
  }

  Future<void> loadAttendances() async {
    _future = Future.value(await dio.get('/attendances'));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.notifications),
                  ),
                  IconButton.filled(
                    onPressed: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const AttendancePage(),
                        ),
                      );

                      loadAttendances();
                    },
                    style: IconButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    icon: const Icon(Icons.add),
                  ),
                ],
              ),
              Text(
                "Absensi",
                style: GoogleFonts.openSans(
                  color: const Color.fromARGB(255, 0, 24, 44),
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 30),
              const Text(
                "December 2020",
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
        Expanded(
          child: Center(
            child: FutureBuilder(
              future: _future,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final response = snapshot.data?.data as Map<String, dynamic>;
                  final attendances = response['data'] as List<dynamic>;

                  return RefreshIndicator(
                    onRefresh: loadAttendances,
                    child: ListView.builder(
                      key: PageStorageKey(widget.scrollKey),
                      padding: const EdgeInsets.all(16),
                      itemCount: attendances.length,
                      itemBuilder: (context, index) {
                        final attendance = attendances[index];

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: Dismissible(
                            key: Key(attendance['id'].toString()), // id unik untuk setiap attendance
                            onDismissed: (direction) { // fungsi yang akan dijalankan ketika item dihapus
                              final id = attendance['id']; // mendapatkan id dari attendance

                              dio.delete('/attendances/$id'); // menghapus data dari server
                            },
                            child: AttendenceItem(
                              title: attendance['work_description'],
                              imageUrl: attendance['image'],
                              description: attendance['work'],
                              isLaptop: attendance['is_laptop'] == 1,
                              isKomputer: attendance['is_komputer'] == 1,
                              isHp: attendance['is_hp'] == 1,
                              isLainya: attendance['is_lainya'] == 1,
                              mood: attendance['mood'],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }
                if (snapshot.hasError) {
                  return Text(snapshot.error.toString());
                }

                return const CircularProgressIndicator();
              },
            ),
          ),
        ),
      ],
    );
  }
}

class BottomNavigation extends StatefulWidget {
  final Function(int) onItemSelected;

  const BottomNavigation({
    super.key,
    required this.onItemSelected,
  });

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            onPressed: () {
              setState(() {
                _selectedIndex = 0;
              });
              widget.onItemSelected(0);
            },
            icon: const FaIcon(FontAwesomeIcons.house),
            color: _selectedIndex == 0 ? Colors.purple : null,
          ),
          IconButton(
            onPressed: () {
              setState(() {
                _selectedIndex = 1;
              });
              widget.onItemSelected(1);
            },
            icon: const FaIcon(FontAwesomeIcons.solidUser),
            color: _selectedIndex == 1 ? Colors.purple : null,
          ),
          IconButton(
            onPressed: () {
              setState(() {
                _selectedIndex = 2;
              });
              widget.onItemSelected(2);
            },
            icon: const FaIcon(FontAwesomeIcons.gear),
            color: _selectedIndex == 2 ? Colors.purple : null,
          ),
        ],
      ),
    );
  }
}
