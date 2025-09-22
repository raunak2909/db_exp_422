import 'package:db_exp_422/db_helper.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DBHelper? dbHelper;
  String pageName = 'Home Page';
  List<Map<String, dynamic>> mNotes = [];
  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();
  DateFormat df = DateFormat.yMMMEd();


  @override
  void initState() {
    super.initState();
    dbHelper = DBHelper.instance;
    getAllNotes();
  }

  getAllNotes() async {
    mNotes = await dbHelper!.fetchAllNotes();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(pageName)),
      body: mNotes.isNotEmpty
          ? Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: ListView.builder(
                itemCount: mNotes.length,
                itemBuilder: (_, index) {
                  return Card(
                    child: ListTile(
                      leading: Text("${index + 1}"),
                      title: Text(mNotes[index][DBHelper.columnNoteTitle]),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(mNotes[index][DBHelper.columnNoteDesc]),
                          Text(df.format(DateTime.fromMillisecondsSinceEpoch(int.parse(mNotes[index][DBHelper.columnNoteCreatedAt])))),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () async {

                              titleController.text = mNotes[index][DBHelper.columnNoteTitle];
                              descController.text = mNotes[index][DBHelper.columnNoteDesc];
                              showModalBottomSheet(
                                  context: context, builder: (_){
                                    return myBottomSheet(isUpdate: true, mId: mNotes[index][DBHelper.columnNoteId]);
                              });
                            },
                            icon: Icon(Icons.edit),
                          ),
                          IconButton(
                            onPressed: () async{
                              bool isDeleted = await dbHelper!.deleteNote(id: mNotes[index][DBHelper.columnNoteId]);
                              if(isDeleted){
                                getAllNotes();
                              }
                            },
                            icon: Icon(Icons.delete, color: Colors.red),
                          ),
                        ],
                      ),
                    ),

                    /*Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(mNotes[index][DBHelper.columnNoteTitle],
                        style: TextStyle(fontSize: 16),),
                      Text(mNotes[index][DBHelper.columnNoteDesc],
                        style: TextStyle(color: Colors.grey),),
                    ],
                  ),
                ),*/
                  );
                },
              ),
            )
          : Center(child: Text('No Notes Found')),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          titleController.text = "";
          descController.clear();
          showModalBottomSheet(
            context: context,
            builder: (c) {
              return myBottomSheet();
            },
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget myBottomSheet({bool isUpdate = false, int mId = 0}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(11),
      child: Column(
        children: [
          Text(
            isUpdate ? 'Update Note' : 'Add Note',
            style: TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 21),
          TextField(
            controller: titleController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: "Title",
              hintText: "Enter Note Title",
            ),
          ),
          SizedBox(height: 11),
          TextField(
            maxLines: 4,
            controller: descController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: "Desc",
              hintText: "Enter Note Desc",
            ),
          ),
          SizedBox(height: 11),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              OutlinedButton(
                onPressed: () async {

                  bool isAddedOrUpdated = false;

                  if(isUpdate){
                    isAddedOrUpdated = await dbHelper!.updateNote(
                      title: titleController.text,
                      desc: descController.text,
                      id: mId,
                    );
                  } else {
                    isAddedOrUpdated = await dbHelper!.insertNote(
                      title: titleController.text,
                      desc: descController.text,
                    );
                  }

                  if(isAddedOrUpdated){
                    getAllNotes();
                    Navigator.pop(context);
                  }

                },
                child: Text('Save'),
              ),
              SizedBox(width: 11),
              OutlinedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Cancel'),
              ),
            ],
          ),
        ],
      ),
    );
  }

}
