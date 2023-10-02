import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/clas.dart';
import 'package:http/http.dart' as http;

String variable =
    'https://www.eschool2go.org/api/v1/project/ba7ea038-2e2d-4472-a7c2-5e4dad7744e3';

var data = {};
List<DataMap> dataMap = [];
Map<String, bool> offile = {};
Future<void> directoryContainsFiles() async {
  Directory directory = Directory(
      '/storage/emulated/0/Android/data/com.example.flutter_application_1/files/data/user/0/com.example.flutter_application_1/files/');

  if (directory.existsSync()) {
    List<FileSystemEntity> files = directory.listSync();

    for (var file in files) {
      if (file is File) {
        offile[file.uri.pathSegments.last.toString()] = true;
      }
    }
  }
}

void showSnackbar(BuildContext context, String message, Color abc) {
  // Close any existing snackbar
  ScaffoldMessenger.of(context).removeCurrentSnackBar();

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 2),
      backgroundColor: abc,
    ),
  );
}

class Servi {
  Future<void> fetchData(String link) async {
    try {
      final response = await http.get(
        Uri.parse(link),
      );
      if (response.statusCode == 200) {
        if (variable == link) {
          data = jsonDecode(response.body);
        } else {
          final gat = jsonDecode(response.body);
          if (gat != null) {
            final son = gat as List<dynamic>;
            dataMap.clear();
            dataMap = son.map((e) {
              return DataMap.fromMap(e);
            }).toList();
            dataMap.sort((a, b) => a.number.compareTo(b.number));
          } else {
            dataMap.clear();
          }
        }
      } else {
        throw Exception('HTTP Error: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
