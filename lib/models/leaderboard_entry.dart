class LeaderboardEntry {
  final int score;
  final String? name;
  final DateTime? date;

  const LeaderboardEntry({
    required this.score,
    this.name,
    this.date,
  });

  Map<String, dynamic> toJson() => {
        'score': score,
        if (name != null) 'name': name,
        if (date != null) 'date': date!.toIso8601String(),
      };

  factory LeaderboardEntry.fromJson(Map<String, dynamic> json) {
    return LeaderboardEntry(
      score: json['score'] as int,
      name: json['name'] as String?,
      date: json['date'] != null
          ? DateTime.parse(json['date'] as String)
          : null,
    );
  }

  @override
  String toString() =>
      'LeaderboardEntry(score: $score, name: $name, date: $date)';
}
