import 'package:db_exp_422/db_helper.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DBHelper? dbHelper;
  List<Map<String, dynamic>> mNotes = [];
  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();

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
      appBar: AppBar(title: const Text('Home Page')),
      body: mNotes.isNotEmpty
          ? Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: ListView.builder(
            itemCount: mNotes.length,
            itemBuilder: (_, index) {
              return Card(
                child: ListTile(
                  title: Text(mNotes[index][DBHelper.columnNoteTitle]),
                  subtitle: Text(mNotes[index][DBHelper.columnNoteDesc]),
                  trailing: IconButton(onPressed: (){}, icon: Icon(Icons.delete, color: Colors.red,)),
                )

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
            }),
      )
          : Center(child: Text('No Notes Found')),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          showModalBottomSheet(context: context, builder: (c) {
            return Container(
              width: double.infinity,
              padding: EdgeInsets.all(11),
              child: Column(
                children: [
                  Text('Add Note', style: TextStyle(
                      fontSize: 21, fontWeight: FontWeight.bold),),
                  SizedBox(
                    height: 21,
                  ),
                  TextField(
                    controller: titleController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Title",
                        hintText: "Enter Note Title"
                    ),
                  ),
                  SizedBox(
                    height: 11,
                  ),
                  TextField(
                    maxLines: 4,
                    controller: descController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Desc",
                        hintText: "Enter Note Desc"
                    ),
                  ),
                  SizedBox(
                    height: 11,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      OutlinedButton(onPressed: () async{
                        bool isAdded =  await dbHelper!.insertNote(
                            title: titleController.text, desc: descController.text);

                        if(isAdded){
                          titleController.text = '';
                          descController.clear();
                          getAllNotes();
                          Navigator.pop(context);
                        }

                      }, child: Text('Add')),
                      SizedBox(
                        width: 11,
                      ),
                      OutlinedButton(onPressed: () {
                        Navigator.pop(context);
                      }, child: Text('Cancel')),
                    ],
                  )
                ],
              ),
            );
          });
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
