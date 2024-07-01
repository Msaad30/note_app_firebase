class NoteModel{
  String? noteId;
  String title;
  String desc;
  int createdAt;

  NoteModel({this.noteId, required this.title, required this.desc, required this.createdAt});

  factory NoteModel.fromDoc(Map<String, dynamic> doc){
    return NoteModel(
        noteId: doc["noteId"],
        title: doc["title"],
        desc: doc["desc"],
        createdAt: doc["createdAt"]
    );
  }

  Map<String, dynamic>toDoc(){
    return {
      "noteId": noteId,
      "title": title,
      "desc": desc,
      "createdAt": createdAt
    };
  }

}