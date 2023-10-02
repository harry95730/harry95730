import 'package:flutter/material.dart';
import 'package:flutter_application_1/downloadpage.dart';

class Classroom extends StatefulWidget {
  final String text;
  final String path;
  const Classroom({super.key, required this.text, required this.path});

  @override
  State<Classroom> createState() => ClassroomState();
}

class ClassroomState extends State<Classroom> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black,
            )),
        backgroundColor: Colors.white,
        title: Text(
          widget.text,
          style: const TextStyle(fontSize: 16, color: Colors.black),
        ),
      ),
      body: Subjectpage(path: widget.text),
    );
  }
}
