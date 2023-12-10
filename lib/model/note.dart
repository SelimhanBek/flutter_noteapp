class Note {
  late String id = "";
  late String header = "";
  late String note = "";
  late String date = "";

  Note({
    required this.id,
    required this.header,
    required this.date,
    required this.note,
  });

  Note.fromJson(Map<String, dynamic> m) {
    id = m["id"];
    header = m["header"];
    note = m["note"];
    date = m["date"];
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "header": header,
        "note": note,
        "date": date,
      };

  List<String> toList() => [
        id,
        header,
        note,
        date,
      ];
}
