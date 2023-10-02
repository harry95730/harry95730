import 'package:flutter/material.dart';
import 'package:flutter_application_1/listofsub.dart';

class Custompage extends StatelessWidget {
  const Custompage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        toolbarHeight: 80.0,
        title: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Class 12',
                style: TextStyle(fontSize: 16),
              ),
              Text(
                'Books',
                style: TextStyle(fontSize: 16),
              )
            ],
          ),
        ),
      ),
      body: const Listpage(),
    );
  }
}
