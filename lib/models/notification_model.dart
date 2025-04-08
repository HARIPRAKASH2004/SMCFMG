class FcmLogModel {
  final String title;
  final String body;
  final String time;

  FcmLogModel({
    required this.title,
    required this.body,
    required this.time,
  });

  Map<String, dynamic> toJson() => {
    'title': title,
    'body': body,
    'time': time,
  };

  factory FcmLogModel.fromJson(Map<String, dynamic> json) => FcmLogModel(
    title: json['title'] ?? '',
    body: json['body'] ?? '',
    time: json['time'] ?? '',
  );
}
