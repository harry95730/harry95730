import 'package:flutter_application_1/class.dart';
import 'package:flutter_application_1/page2.dart';
import 'package:flutter/material.dart';

class Listpage extends StatefulWidget {
  const Listpage({super.key});

  @override
  State<Listpage> createState() => _ListpageState();
}

class _ListpageState extends State<Listpage> {
  bool kr = false;
  void someAsyncFunction() async {
    try {
      await Servi().fetchData(variable);
      setState(() {
        kr = true;
      });
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      someAsyncFunction();
    });
  }

  @override
  Widget build(BuildContext context) {
    return kr
        ? ListView.builder(
            itemCount: (data.length / 2).ceil(),
            itemBuilder: (BuildContext context, int index) {
              int startIndex = index * 2;
              List keys = data.keys.toList();
              if (startIndex < keys.length) {
                String key1 = keys[startIndex];

                if (startIndex + 1 < keys.length) {
                  String key2 = keys[startIndex + 1];

                  return box(data[key1], data[key2]);
                } else {
                  return box(data[key1], '');
                }
              } else {
                return Container();
              }
            },
          )
        : const Center(
            heightFactor: BorderSide.strokeAlignCenter,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              backgroundColor: Colors.black,
            ),
          );
  }

  Widget box(var name, var name1) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(child: buildColoredBox(name['name'].toString(), name['path'])),
        Expanded(
          child: name1 != ''
              ? buildColoredBox(name1['name'].toString(), name1['path'])
              : const SizedBox(
                  height: 80,
                  width: 185,
                ),
        ),
      ],
    );
  }

  Widget buildColoredBox(String text, String path) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Classroom(text: text, path: path)));
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          height: 80,
          width: 185,
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: Colors.transparent,
                child: ClipOval(
                  child: Image.network(
                    'https://images.pexels.com/photos/268533/pexels-photo-268533.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
                    loadingBuilder: (BuildContext context, Widget child,
                        ImageChunkEvent? loadingProgress) {
                      if (loadingProgress == null) {
                        return child;
                      } else {
                        return CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                              : null,
                        );
                      }
                    },
                    errorBuilder: (BuildContext context, Object exception,
                        StackTrace? stackTrace) {
                      return const Text('Failed to load image');
                    },
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  text,
                  softWrap: true,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
