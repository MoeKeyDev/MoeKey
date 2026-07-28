class HashtagTrendModel {
  const HashtagTrendModel({
    required this.tag,
    required this.chart,
    required this.usersCount,
  });

  factory HashtagTrendModel.fromJson(Map<String, dynamic> json) {
    return HashtagTrendModel(
      tag: json['tag'] as String,
      chart: [
        for (final value in json['chart'] as List? ?? const [])
          (value as num).toDouble(),
      ],
      usersCount: (json['usersCount'] as num).toInt(),
    );
  }

  final String tag;
  final List<double> chart;
  final int usersCount;
}
