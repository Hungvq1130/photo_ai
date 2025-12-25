class PresetHistoryItem {
  final String sectionId;
  final String sectionName;
  final String itemId;
  final String imgPreview;
  final String imgOrigin;
  final String prompt;
  final DateTime usedAt;

  PresetHistoryItem({
    required this.sectionId,
    required this.sectionName,
    required this.itemId,
    required this.imgPreview,
    required this.imgOrigin,
    required this.prompt,
    required this.usedAt,
  });

  Map<String, dynamic> toJson() => {
    "sectionId": sectionId,
    "sectionName": sectionName,
    "itemId": itemId,
    "img_preview": imgPreview,
    'imgOrigin': imgOrigin,
    "prompt": prompt,
    "usedAt": usedAt.toIso8601String(),
  };

  factory PresetHistoryItem.fromJson(Map<String, dynamic> json) {
    return PresetHistoryItem(
      sectionId: json["sectionId"].toString(),
      sectionName: json["sectionName"] ?? '',
      itemId: json["itemId"].toString(),
      imgPreview: json["img_preview"],
      imgOrigin: json['imgOrigin'],
      prompt: json["prompt"] ?? '',
      usedAt: DateTime.parse(json["usedAt"]),
    );
  }
}
