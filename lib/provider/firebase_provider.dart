import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:notes_app_complete_project/models/note_model.dart';

class FirebaseProvider{

  static FirebaseFirestore mFireStore = FirebaseFirestore.instance;
  static String mCollectionNote ="notes";

  // Add Note
  static add(NoteModel newNote){
    return mFireStore
        .collection(mCollectionNote)
        .add(newNote.toDoc())
        .then((value) {
          mFireStore
              .collection(mCollectionNote)
              .doc(value.id)
              .update({"noteId" : value.id});
    })
        .onError((error, stackTrace) => null);
  }

  // Update note
  static Future<void> UpdateNote(NoteModel Note){
    return mFireStore
        .collection(mCollectionNote)
        .doc(Note.noteId)
        .update(Note.toDoc());
  }

  // delete notes
  static Future<void> DeleteNote(NoteModel note){
    return mFireStore
        .collection(mCollectionNote)
        .doc(note.noteId)
        .delete();
  }

  // get all notes
  static Stream<QuerySnapshot<Map<String, dynamic>>> fetchAllNote(){
    return mFireStore
        .collection(mCollectionNote)
        .snapshots();
  }




}