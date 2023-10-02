import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/clas.dart';
import 'package:flutter_application_1/class.dart';
import 'package:flutter_application_1/page3.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';

class Subjectpage extends StatefulWidget {
  final String path;
  const Subjectpage({super.key, required this.path});

  @override
  State<Subjectpage> createState() => _SubjectpageState();
}

class _SubjectpageState extends State<Subjectpage> {
  bool kr = false;

  void b() async {
    await directoryContainsFiles();
  }

  void functio(String ab) async {
    try {
      String path = "$variable?path=$ab";
      await Servi().fetchData(path);
      setState(() {
        kr = true;
      });
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  void deleteFile(String filePath) {
    File fileToDelete = File(filePath);

    if (fileToDelete.existsSync()) {
      try {
        fileToDelete.deleteSync();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('FILE DELETED SUCCESSFULLY'),
          backgroundColor: Colors.green,
        ));
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Error deleting file: ${e.toString()}'),
          backgroundColor: Colors.red,
        ));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('File does not exist.'),
        backgroundColor: Colors.redAccent,
      ));
    }
  }

  void downloadPDF(DataMap box) async {
    File? file = await FileDownloader.downloadFile(
        url: box.downloadUrl,
        name: box.uuid,
        downloadDestination: DownloadDestinations.appFiles,
        onProgress: (String? fileName, double progress) {
          showSnackbar(
              context, 'DOWNLOADING ${progress.toString()}% ', Colors.green);
        },
        onDownloadCompleted: (String path) {
          showSnackbar(context, 'FILE DOWNLOADED TO PATH: $path', Colors.green);

          setState(() {});
        },
        onDownloadError: (String error) {
          showSnackbar(context, 'DOWNLOAD ERROR: $error', Colors.red);
        });

    print('FILE: ${file?.path}');

    FileDownloader.setLogEnabled(true);
    setState(() {
      box.down = '${box.uuid}.pdf';
    });
  }

  @override
  void initState() {
    super.initState();

    b();
    functio(widget.path);
  }

  @override
  Widget build(BuildContext context) {
    return kr
        ? ListView.builder(
            itemCount: dataMap.length,
            itemBuilder: (BuildContext context, int index) {
              return sub(dataMap[index]);
            })
        : const Center(
            heightFactor: BorderSide.strokeAlignCenter,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              backgroundColor: Colors.black,
            ),
          );
  }

  Widget sub(DataMap eachbox) {
    return Container(
      height: 90,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.8),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
        Row(
          children: [
            Expanded(
              flex: 9,
              child: Row(
                children: [
                  Text(
                    '  Unit ${eachbox.number}    ',
                    style: const TextStyle(color: Colors.black),
                  ),
                  Expanded(
                    child: Text(
                      eachbox.title,
                      softWrap: true,
                      style:
                          const TextStyle(color: Colors.black, fontSize: 15.0),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Center(
                child: IconButton(
                  onPressed: () async {
                    deleteFile(
                        '/storage/emulated/0/Android/data/com.example.flutter_application_1/files/data/user/0/com.example.flutter_application_1/files/${eachbox.uuid}.pdf');

                    setState(() {
                      eachbox.down = '';
                    });
                  },
                  icon: const Icon(
                    Icons.delete,
                    size: 20.0,
                  ),
                ),
              ),
            )
          ],
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(
                vertical: 5.0,
                horizontal: eachbox.down.isNotEmpty ? 15.0 : 0.0),
            child: eachbox.down.isNotEmpty && eachbox.down != '1'
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: ((context) => HomePage(
                                    linkforopening: eachbox.uuid,
                                    ofon: true))));
                      },
                      style: const ButtonStyle(
                          backgroundColor:
                              MaterialStatePropertyAll(Colors.lightGreen)),
                      child: const SizedBox(
                        width: double.infinity,
                        child: Center(
                          child: Text(
                            'Read Offline',
                          ),
                        ),
                      ),
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: ElevatedButton(
                          onPressed: () async {
                            if (eachbox.down.isEmpty) {
                              setState(() {
                                eachbox.down = '1';
                              });
                              downloadPDF(eachbox);
                              setState(() {});
                            }
                          },
                          style: ButtonStyle(
                              backgroundColor: eachbox.down.isEmpty
                                  ? const MaterialStatePropertyAll(Colors.green)
                                  : const MaterialStatePropertyAll(
                                      Colors.grey)),
                          child: const SizedBox(
                            width: 180,
                            child: Center(
                              child: Text(
                                'Download',
                              ),
                            ),
                          ),
                        ),
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: ((context) => HomePage(
                                        linkforopening: eachbox.id,
                                        ofon: false))));
                          },
                          style: const ButtonStyle(
                              backgroundColor:
                                  MaterialStatePropertyAll(Colors.grey)),
                          child: const SizedBox(
                            width: 120,
                            child: Center(
                              child: Text(
                                'Online',
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
          ),
        )
      ]),
    );
  }
}
