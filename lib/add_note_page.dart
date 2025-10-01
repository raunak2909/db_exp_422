import 'package:flutter/material.dart';

import 'db_helper.dart';

class AddNotePage extends StatelessWidget {
  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();

  bool isUpdate;
  int mId;
  String mTitle, mDesc;
  DBHelper? dbHelper;

  AddNotePage({this.isUpdate = false, this.mId = 0, this.mTitle = "", this.mDesc = ""});

  @override
  Widget build(BuildContext context) {

    if(isUpdate){
      titleController.text = mTitle;
      descController.text = mDesc;
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(isUpdate ? 'Update Note' : 'Add Note'),
      ),
      body:  Container(
        width: double.infinity,
        padding: EdgeInsets.all(11),
        child: Column(
          children: [
           /* Text(
              isUpdate ? 'Update Note' : 'Add Note',
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 21),*/
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
                    dbHelper = DBHelper.instance;
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
      ),
    );
  }
}
