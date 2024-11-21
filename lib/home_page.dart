import 'package:database_integration/db_helper.dart';
import 'package:flutter/material.dart';

class home_page extends StatefulWidget{
  @override
  State<home_page> createState() => _home_pageState();
}

class _home_pageState extends State<home_page> {
    TextEditingController titleController = TextEditingController();
    TextEditingController  descController = TextEditingController();
    TextEditingController idController = TextEditingController();

  DbHelper dbHelper = DbHelper.getInstance();
  List<Map<String, dynamic>> mData =[];

  @override
  void initState() {
    super.initState();
    dbHelper.fetchAllNotes();
    getNotes();
  }

     void getNotes() async{
    mData = await dbHelper.fetchAllNotes();
    setState(() {

    });
     }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text("Notes App"),
      ),
      body:mData.isNotEmpty ? ListView.builder(itemCount: mData.length ,
          itemBuilder: (_, index){
           return ListTile(
             leading: Text(mData[index]['n_id'].toString(), style: TextStyle(fontSize: 18),),
             title: Text(mData[index]["n_title"]),
             subtitle: Text(mData[index]["n_desc"]),
             trailing: SizedBox(
               width: 100,
               child: Row(
                 children: [
                   IconButton(onPressed: () async{      /// UPDATE NOTE
                   /*  dbHelper.updateNote(title: "upDate", desc: "Updated description ", id: mData[index]["n_id"]); */
                     titleController.text = mData[index]["n_title"];
                     descController.text = mData[index]["n_desc"];
                     showModalBottomSheet(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(top: Radius.circular(25))
                        ),
                         enableDrag: false,
                         context: context, builder: (_){
                             return getBottomSheet( isUpdate: true, nId: mData[index]["n_id"]);
                        });
                   }, icon: Icon(Icons.edit, color: Colors.blue, )),
                   /// DELETE NOTE
                   IconButton(onPressed: () async {
                     bool check = await dbHelper.deleteNote(id: mData[index]["n_id"]);
                       if (check){
                         getNotes();
                       }
                   },
                     icon: Icon(Icons.delete, color: Colors.red),)
                 ],
               ),
             ),

           );
      }) : Center(child: Text("No notes yet"),),
    
      floatingActionButton: FloatingActionButton(onPressed: () async{

        /*titleController.clear();
        descController.clear(); */
        showModalBottomSheet(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(25))
          ),
          enableDrag: false,
          //  isDismissible: false, //
            context: context, builder: (_){
          return getBottomSheet();
        });
        },
        child: const Icon (Icons.add),),
    );
  }

     Widget getBottomSheet({ bool isUpdate = false, int nId = 0}){
    return Container(
      padding: EdgeInsets.all(16),
      height: 400,
      width: double.infinity,
      child: Column(
        children: [
          Text(
            isUpdate ? " Update Note"  : "Add Note", style: TextStyle(fontSize: 21),),
          SizedBox(
            height: 11,
          ),
          TextField(
            controller: titleController,
            decoration: InputDecoration(
              label: Text("Text*"),
              hintText: "Enter your title",
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(11)
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(11),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          TextField(
            controller: descController,
            minLines: 3,
            maxLines: 4,
            decoration: InputDecoration(
              label: Text("Description*"),
              hintText: " Enter the description",
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(11)
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(11),
              ),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              OutlinedButton(onPressed: () async{
                if(titleController.text.isNotEmpty && descController.text.isNotEmpty){

                  if(isUpdate){
                     bool check = await dbHelper.updateNote(title: titleController.text, desc: descController.text, id: nId);
                     if(check){
                       Navigator.pop(context);
                       getNotes();
                     }
                  } else {
                    bool check = await dbHelper.addNote(
                        title: titleController.text.toString(),
                        desc: descController.text.toString());

                    if (check) {
                      Navigator.pop(context);
                      getNotes();
                    }
                  }
       }
              },
                  child: Text( isUpdate ? "Update " : "Add")),
              SizedBox(width: 10,),
              OutlinedButton(onPressed: (){
                Navigator.pop(context);
              }, child: Text("Cancel"))
            ],
          )
        ],
      ),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: const Radius.circular(25))
      ),
    );
     }
}