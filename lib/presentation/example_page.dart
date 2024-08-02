import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ExamplePage extends StatelessWidget {
  const ExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: StreamBuilder(
          stream:
              FirebaseFirestore.instance.collection('attendances').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData == false) return const Text('No data');

            final data = snapshot.data as QuerySnapshot;
            final list = data.docs;

            return ListView.builder(
              itemCount: list.length,
              itemBuilder: (context, index) {
                final data = list[index];

                return Text(data.data().toString());
              },
            );
          },
        ),
      ),
    );
  }
}
