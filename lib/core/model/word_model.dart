class WordModel {
  final int id;
  final String english;
  final String type;
  final String transcript;
  final String uzbek;
  final String? countable;
  final int is_favourite;

  WordModel._(this.id, this.english, this.type, this.transcript, this.uzbek, this.countable, this.is_favourite);

  factory WordModel.fromJson(Map<String, dynamic> json) {
    return WordModel._(
        json["id"] ?? 0,
        json["english"] ?? "",
        json["type"] ?? "",
        json["transcript"] ?? "",
        json["uzbek"] ?? "",
        json["countable"] ?? "",
        json["is_favourite"] ?? "",
    );
  }
}
