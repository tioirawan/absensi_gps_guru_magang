import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class ExamplePage extends StatefulWidget {
  const ExamplePage({super.key});

  @override
  State<ExamplePage> createState() => _ExamplePageState();
}

class _ExamplePageState extends State<ExamplePage> {
  final dio = Dio(
    BaseOptions(
      baseUrl: 'https://jsonplaceholder.typicode.com/',
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );

  String? response;

  Future<String> getHttp() async {
    final result = await dio.get('/todos/1');

    return result.data.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: 100,
              height: 100,
              color: Colors.red,
            ),
            Positioned(
              top: -25,
              left: 0,
              right: 0,
              child: Container(
                width: 50,
                height: 50,
                color: Colors.blue,
              )
                  .animate(
                      onComplete: (controller) =>
                          controller.repeat(reverse: true))
                  .custom(
                builder: (context, val, child) {
                  val = (val - 0.5) * 2;

                  return Align(
                    alignment: Alignment(val, 0),
                    child: child,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
