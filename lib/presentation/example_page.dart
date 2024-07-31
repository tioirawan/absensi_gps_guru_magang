import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class ExamplePage extends StatefulWidget {
  const ExamplePage({super.key});

  @override
  State<ExamplePage> createState() => _ExamplePageState();
}

class _ExamplePageState extends State<ExamplePage> {
  final String token =
      'eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJodHRwczovL2Nsb3VkLmdvb2dsZS5jb20vd29ya3N0YXRpb25zIiwiYXVkIjoiaWR4LWFwaS1hYnNlbnNpLTE3MjIzMTM0NzQwMDguY2x1c3Rlci1hM2dyanplazY1Y3hleDc2MmU0bXdyemw0Ni5jbG91ZHdvcmtzdGF0aW9ucy5kZXYiLCJpYXQiOjE3MjIzOTQyMTksImV4cCI6MTcyMjM5NzgxOX0.Y4LCvzdQu2FxQw31JSwPg7RrCWY5-v3_nEB7i3RBhk_y3O-kQ7ILG67978AKKaZAWvN2PUK_fTSlY5Ki3dBfvbOeI05U7dZoyCxui3aGyxY6HuhMcb2yHaRnXWkeTlNj5pUt3teKNu6M3c-d4stCYL5erWnUvxcIGw92VRFJ3qF-T_zSxRZsv6VNOVYirmjbsRySMA0zdpluNG74Sh8Nk4bZqtYt7CQOA2I2txHeqtOOv0-zkvNrwutoUEE6Z2ocmhJslLqsJJ8QXrqtwEXMU4n0LHhQHb2yDfJnCu55_1uH8ZFlyN-oFUZSuzRoHr1XiipFQGfW9JZNLqGAbrhSsw';
  late final dio = Dio(
    BaseOptions(headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    }),
  );

  String? response;

  Future<String> getHttp() async {
    await Future.delayed(const Duration(seconds: 1));
    final result = await dio.get(
        'https://9000-idx-api-absensi-1722313474008.cluster-a3grjzek65cxex762e4mwrzl46.cloudworkstations.dev/api/attendances');

    return result.data.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: FutureBuilder(
                future: getHttp(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Text(snapshot.data.toString());
                  }
                  if (snapshot.hasError) {
                    return Text(snapshot.error.toString());
                  }
                  return const CircularProgressIndicator();
                }),
          ),
        ],
      ),
    );
  }
}
