import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DbHelper {

  /// Create a private constructor
  DbHelper._();

  /// Create a static global instance to this class
  // static final DbHelper instance = DbHelper._();

  static DbHelper getInstance() => DbHelper._();

  Database ? mDB;

  Future <Database> initDB() async {

    mDB =mDB ?? await openDB();
    print(" DB opened");
    return mDB!;
  }

   Future <Database> openDB () async{
      var dirPath =  await getApplicationDocumentsDirectory();
      var dbPath = join(dirPath.path, "noteDB.db");
      return openDatabase(dbPath, version: 1, onCreate: (db, version){
          print(" DB created");
       /// Create table
       
        db.execute("CREATE table note (n_id integer primary key autoincrement, n_title text, n_desc text)");
        
        
      });
  }
     /// Insert
     Future<bool>  addNote({required String title, required String desc}) async {
       Database db = await initDB();


       int rowsEffected = await db.insert("note", {
         "n_title": title,
         "n_desc": desc,
       });

          return rowsEffected > 0;
       /*if (rowsEffected > 0) {
         return true;
       } else {
         return false;
       } */
     }

       /// SELECT
         Future <List<Map<String, dynamic>>> fetchAllNotes() async{

            Database db = await initDB();
            
            List<Map<String, dynamic>> allnotes = await db.query("note");  /// Select * from note
            return allnotes;
        }

      /// UPDATE
          Future<bool> updateNote ({required String title, required String desc, required int id}) async{
             Database db = await initDB();
         int rowsEffected =   await db.update("note", {
               "n_title": title,
               "n_desc": desc,
             }, where:  "n_id = $id");

                 return rowsEffected>0;
          }

      /// DELETE
        Future<bool>  deleteNote ({ required int id}) async{
                Database db = await initDB();
                int rowsEffected =   await db.delete("note",
                    where: 'n_id = ?', whereArgs: ['$id']);

                return rowsEffected>0;
           }



     }
