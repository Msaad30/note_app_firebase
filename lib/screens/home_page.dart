import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:notes_app_complete_project/models/note_model.dart';
import 'package:notes_app_complete_project/provider/firebase_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();
  List<NoteModel> listNote = [];
  List weekDays = ["Mon", "Tues", "Wed", "Thus", "Fri", "Sat", "Sun"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notes App"),
        centerTitle: true,
        backgroundColor: Colors.pinkAccent.withOpacity(0.3),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseProvider.fetchAllNote(),
        builder: (context,snapshot) {
          listNote.clear();
          if(snapshot.connectionState == ConnectionState.waiting){
            return Center(child: CircularProgressIndicator());
          }
          for(QueryDocumentSnapshot<Map<String, dynamic>> eachNote in snapshot.data!.docs){
            listNote.add(NoteModel.fromDoc(eachNote.data()));
          }
          return listNote.isNotEmpty ? ListView.builder(
                    itemCount: listNote.length,
                    itemBuilder: (BuildContext context, int index){
                      var time = DateTime.fromMillisecondsSinceEpoch(listNote[index].createdAt);
                      var createdAtDate = time.day;
                      var createdAtWeekDay = time.weekday;
                      var createdAtTime = "${time.hour}:${time.minute}";
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          elevation: 5,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: Column(
                              children: [
                                InkWell(
                                  onTap: (){
                                    showModalBottomSheet(
                                        context: context,
                                        isScrollControlled: true,
                                        builder: (context){
                                          titleController.text = listNote[index].title;
                                          descController.text = listNote[index].desc;
                                          return bottomSheetContainer(mIndex: index);
                                        });
                                  },
                                  child: ListTile(
                                    leading: Card(
                                      color: Colors.pinkAccent.withOpacity(0.3),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical : 3),
                                        child: Column(
                                          children: [
                                            Expanded(child: Text(weekDays[createdAtWeekDay - 1].toString(), style: TextStyle(color: Colors.white))),
                                            Expanded(child: Text(createdAtDate.toString(), style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),)),
                                          ],
                                        ),
                                      ),
                                    ),
                                    title: Text(listNote[index].title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                    subtitle: Text(createdAtTime.toString(), style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400)),
                                    trailing: IconButton(onPressed: (){
                                      FirebaseProvider.DeleteNote(listNote[index]);
                                    }, icon: Icon(Icons.delete,  size: 18)),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 20),
                                  child: Text(
                                      listNote[index].desc,
                                      style: TextStyle(fontSize: 16)
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }
                ) : Center(child: Text("No Notes"));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (context){
            return bottomSheetContainer(isUpdate: false);
          });
        },
        child: Icon(Icons.add),
      ),
    );
  }
  
  /// Without DB note 

  /// listNote.isNotEmpty ? ListView.builder(
  //           itemCount: listNote.length,
  //           itemBuilder: (BuildContext context, int index){
  //             var time = DateTime.fromMillisecondsSinceEpoch(listNote[index].createdAt);
  //             var createdAtDate = time.day;
  //             var createdAtWeekDay = time.weekday;
  //             var createdAtTime = "${time.hour}:${time.minute}";
  //             return Padding(
  //               padding: const EdgeInsets.all(8.0),
  //               child: Card(
  //                 elevation: 5,
  //                 child: Padding(
  //                   padding: const EdgeInsets.symmetric(vertical: 5),
  //                   child: Column(
  //                     children: [
  //                       InkWell(
  //                         onTap: (){
  //                           showModalBottomSheet(
  //                               context: context,
  //                               isScrollControlled: true,
  //                               builder: (context){
  //                                 titleController.text = listNote[index].title;
  //                                 descController.text = listNote[index].desc;
  //                                 return bottomSheetContainer(mIndex: index);
  //                               });
  //                         },
  //                         child: ListTile(
  //                           leading: Card(
  //                             color: Colors.pinkAccent.withOpacity(0.3),
  //                             child: Padding(
  //                               padding: const EdgeInsets.symmetric(horizontal: 11),
  //                               child: Column(
  //                                 mainAxisAlignment: MainAxisAlignment.center,
  //                                 children: [
  //                                   Text(weekDays[createdAtWeekDay - 1].toString(), style: TextStyle(color: Colors.white)),
  //                                   Text(createdAtDate.toString(), style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),),
  //                                 ],
  //                               ),
  //                             ),
  //                           ),
  //                           title: Text(listNote[index].title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
  //                           subtitle: Text(createdAtTime.toString(), style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400)),
  //                           trailing: IconButton(onPressed: (){
  //                             listNote.removeAt(index);
  //                             setState(() {
  // 
  //                             });
  //                           }, icon: Icon(Icons.delete,  size: 18)),
  //                         ),
  //                       ),
  //                       Padding(
  //                         padding: const EdgeInsets.symmetric(horizontal: 20),
  //                         child: Row(
  //                           children: [
  //                             Text(listNote[index].desc, style: TextStyle(fontSize: 16)),
  //                           ],
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //               ),
  //             );
  //           }
  //       ) : Center(child: Text("No Notes")),
  
  Widget bottomSheetContainer({bool isUpdate = true, int mIndex = -1}){
    return Container(
      height: MediaQuery.of(context).size.height * 0.5 + MediaQuery.of(context).viewInsets.bottom,
      child: Padding(
        padding: EdgeInsets.only(left: 11, right: 11, bottom: 11 +  MediaQuery.of(context).viewInsets.bottom),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                  label: Text("Title"),
                  hintText: "Enter title",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(11),
                  )
              ),
            ),
            SizedBox(height: 11,),
            TextField(
              maxLines: 7,
              minLines: 4,
              controller: descController,
              decoration: InputDecoration(
                  label: Text("Description"),
                  hintText: "Enter description",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(11),
                  )
              ),
            ),
            SizedBox(height: 11,),
            FutureBuilder(
              future: null,
              builder: (context, snapshot) {
                if(snapshot.connectionState == ConnectionState.waiting){
                  return CircularProgressIndicator();
                }
                return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton( onPressed: (){
                        if(!isUpdate){
                          var mNote = NoteModel(
                            title: titleController.text,
                            desc: descController.text,
                            createdAt: DateTime.now().millisecondsSinceEpoch,
                          );
                          setState(() {

                          });
                          FirebaseProvider.add(mNote);
                          // listNote.add(mNote);
                        } else {
                          var mNote = NoteModel(
                            noteId : listNote[mIndex].noteId,
                            title: titleController.text,
                            desc: descController.text,
                            createdAt: DateTime.now().millisecondsSinceEpoch,
                          );
                          setState(() {

                          });
                          FirebaseProvider.UpdateNote(mNote);
                          // listNote[mIndex] = mNote;
                        }
                        titleController.text = "";
                        descController.text = "";
                        Navigator.pop(context);
                      }, child: !isUpdate ? Text("Add") : Text("Update")),
                      ElevatedButton(onPressed: (){Navigator.pop(context);}, child: Text("Cancle"))
                    ],
                  );
              },
            )
          ],
        ),
      ),
    );
  }
}
