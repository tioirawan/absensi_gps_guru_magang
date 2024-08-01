import 'package:absensi_gps/dio_service.dart';
import 'package:flutter/material.dart';

class AttendenceItem extends StatelessWidget {
  final Function()? onTap;
  final Map<String, dynamic> attendance;

  final String title;
  final String? imageUrl;
  final String description;
  final String mood;

  final bool isLaptop;
  final bool isKomputer;
  final bool isHp;
  final bool isLainya;

  const AttendenceItem({
    super.key,
    this.onTap,
    required this.attendance,
    required this.title,
    required this.imageUrl,
    required this.description,
    required this.isLaptop,
    required this.isKomputer,
    required this.isHp,
    required this.isLainya,
    required this.mood,
  });

  Color getMoodColor(String mood) {
    switch (mood) {
      case "Senang":
        return Colors.green;
      case "Netral":
        return Colors.blue;
      case "Sedih":
        return Colors.orange;
      default:
        return Colors.purple;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.grey.shade200,
          width: 2,
        ),
      ),
      padding: const EdgeInsets.all(16),
      child: IntrinsicHeight(
        child: Row(
          children: [
            if (imageUrl != null)
              Image.network(
                headers: const {
                  'Authorization': 'Bearer $token',
                },
                "https://9000-idx-api-absensi-1722313474008.cluster-a3grjzek65cxex762e4mwrzl46.cloudworkstations.dev/storage/$imageUrl",
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    description,
                    style: const TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    title,
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      if (isLaptop)
                        const Icon(
                          Icons.laptop_mac_rounded,
                          color: Colors.blue,
                          size: 16,
                        ),
                      if (isKomputer)
                        const Icon(
                          Icons.window_sharp,
                          color: Colors.green,
                          size: 16,
                        ),
                      if (isHp)
                        const Icon(
                          Icons.desktop_windows_rounded,
                          color: Colors.orange,
                          size: 16,
                        ),
                      if (isLainya)
                        const Icon(
                          Icons.laptop_chromebook_rounded,
                          color: Colors.purple,
                          size: 16,
                        ),
                    ],
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: getMoodColor(mood).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.all(8),
                  child: Text(
                    mood,
                    style: TextStyle(
                      color: getMoodColor(mood),
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
                const Spacer(),
                IconButton.filled(
                  onPressed: onTap,
                  icon: const Icon(Icons.edit_rounded),
                  style: IconButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      backgroundColor: Colors.grey.shade200),
                  color: Colors.grey,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
