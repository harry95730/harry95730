import 'package:flutter_application_1/class.dart';

class DataMap {
  String title;
  String number;
  String uuid;
  String revisionId;
  String updated;
  String id;
  String downloadUrl;
  String categoryPath;
  String down;

  DataMap({
    required this.title,
    required this.number,
    required this.uuid,
    required this.revisionId,
    required this.updated,
    required this.id,
    required this.downloadUrl,
    required this.categoryPath,
    required this.down,
  });

  factory DataMap.fromMap(Map<String, dynamic> json) {
    final titleFromJson = json["title"] as String;
    final match = RegExp(r'^(\d+)\.\s+(.+)').firstMatch(titleFromJson);
    String abcd = (json["uuid"] + '.pdf');
    String de = '';
    if (offile.containsKey(abcd)) {
      de = abcd;
    }
    if (match != null && match.groupCount == 2) {
      final lessonNumber = match.group(1);
      final lessonTitle = match.group(2);

      return DataMap(
        title: lessonTitle.toString(),
        number: lessonNumber.toString(),
        uuid: json["uuid"],
        revisionId: json["revision_id"],
        updated: json["updated"],
        id: json["id"],
        downloadUrl: json["download_url"],
        categoryPath: json["category_path"],
        down: de,
      );
    } else {
      throw FormatException('Invalid title format: $titleFromJson');
    }
  }
}
