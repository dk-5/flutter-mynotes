import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mynotes/extensions/list/filter.dart';
import 'package:mynotes/services/crud/crud_exceptions.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';

class NotesService{
  Database? _db;
  List<DataBaseNote> _notes=[];
  DataBaseUser? _user;
  static final NotesService _shared = NotesService._sharedInstance();
  NotesService._sharedInstance() {
    _notesStreamController = StreamController<List<DataBaseNote>>.broadcast(
      onListen: () {
        _notesStreamController.sink.add(_notes);
      },
    );
  }
  factory NotesService() => _shared;

  late final StreamController<List<DataBaseNote>> _notesStreamController;
  Stream<List<DataBaseNote>> get allNotes =>_notesStreamController.stream.
    filter((note){
    final currentUser=_user;
    if(currentUser != null)
    {
      return note.userid==currentUser.id;
    }
    else 
    {
      throw UserShouldBeSetBeforeReadingAllNotes();
    }
  }) ;
  

  
  Future<DataBaseUser> getOrCreateUser({required String email,
    bool setAsCurrentUser=true,  
  }) async{
    try 
    {
      final user=await getUser(email: email);
      if(setAsCurrentUser)
      {
        _user=user;
      }
      return user;
    }on CouldNotFindUser {
      final createdUser= await createUser(email: email);
      if(setAsCurrentUser)
      {
        _user=createdUser;
      }
      return createdUser;
    } catch (e)
    {
      rethrow;
    }

    

  }

  Future<void> _cacheNotes() async {
    final allNotes=await getAllNote();
    _notes=allNotes.toList();
    _notesStreamController.add(_notes);

  }

  Future<DataBaseNote> updateNote({required DataBaseNote note,required String text,})async {
    await _ensureDbIsOpen();
    final db=_getDatabaseorthrow();
    await getNote(id: note.id);
    final updateCount=db.update(noteTable,{textColumn:text,
    isSyncedWithCloudColumn:0,    
    },
    where: 'id = ?',
    whereArgs: [note.id],);
    if(updateCount==0)
    {
      throw CouldNotUpdateNote();
    }
    else 
    {
      final updatedNote=await getNote(id: note.id);
      _notes.removeWhere((note)=> note.id==updatedNote.id);
      _notes.add(updatedNote);
      _notesStreamController.add(_notes);
      return updatedNote;
    }



  }
  Future<Iterable<DataBaseNote>> getAllNote() async {
    await _ensureDbIsOpen();
    final db=_getDatabaseorthrow();
    final note= await db.query(noteTable);
    return note.map((noteRow)=>DataBaseNote.fromRow(noteRow));
    
  }
  Future<DataBaseNote> getNote({required int id}) async {
    await _ensureDbIsOpen();
    final db=_getDatabaseorthrow();
    final note= await db.query(noteTable,
    limit:1,
    where:'id=?',
    whereArgs:[id]);
    if(note.isEmpty)
    {
      throw CouldNotFindNote();
    }
    else 
    {
      final notes= DataBaseNote.fromRow(note.first);
      _notes.removeWhere((note)=> note.id==id);
      _notes.add(notes);
      _notesStreamController.add(_notes);
       return notes;
    }
  }
  Future <int> deleteAllNote() async {
    await _ensureDbIsOpen();
    final db =_getDatabaseorthrow();
    final deletionCount= await db.delete(noteTable);
    _notes=[];
    _notesStreamController.add(_notes);
    return deletionCount;
  }
  Future <void> deleteNote({required int id}) async{
    await _ensureDbIsOpen();
    final db=_getDatabaseorthrow();
    final deletedCount=await db.delete(noteTable,
    where:'id=?',
    whereArgs:[id]);
    if(deletedCount==0)
    {
      throw CouldNotDeleteNote();
    }
    else 
    {
      _notes.removeWhere((note)=>note.id==id);
      _notesStreamController.add(_notes);
    }

  }
  Future<DataBaseNote> createNote({required DataBaseUser owner}) async {
    await _ensureDbIsOpen();
    final db=_getDatabaseorthrow();
    final dbUser=await getUser(email: owner.email);
    if(dbUser!=owner)
    {
      throw CouldNotFindUser();
    }
    final noteId=await db.insert(noteTable,{
      useridColumn:owner.id,
      textColumn:'',
      isSyncedWithCloudColumn:1,
    });
    final note = DataBaseNote(
      id: noteId,
      userid: owner.id,
       text: '',      
       isSyncedWithCloud:true,
    );
    _notes.add(note);
    _notesStreamController.add(_notes);
    return note;
  

  }
  Future<DataBaseUser> getUser({required String email}) async {
    await _ensureDbIsOpen();
   final db = _getDatabaseorthrow();
   final result=await db.query(userTable,
    limit:1,
    where:'email=?',
    whereArgs:[email.toLowerCase()],);
    if(result.isEmpty)
    {
      throw CouldNotFindUser();
    }
    else 
    {
      return DataBaseUser.fromRow(result.first);
    }
   
   
  }
  Future<DataBaseUser> createUser({required String email}) async {
    await _ensureDbIsOpen();
    final db=_getDatabaseorthrow();
    final result=await db.query(userTable,
    limit:1,
    where:'email=?',
    whereArgs:[email.toLowerCase()],);
    if(result.isNotEmpty)
    {
      throw UserAlreadyExists();
    }
    final userId=await db.insert(userTable,{emailColumn:email.toLowerCase()});
    return DataBaseUser(email: email, id:userId);

  }
  Future<void> deleteUser({required String email}) async{
    await _ensureDbIsOpen();
    final  db= _getDatabaseorthrow();
    final deletedCount=await db.delete(userTable,where: 'email=?',whereArgs:[email.toLowerCase()]);
    if(deletedCount==0)
    {
      throw CouldNotDeleteUser();
    }

  }
  Database _getDatabaseorthrow () {
    final db=_db;
    if(db==null)
    {
      throw DatabaseIsNotOpen();
    }
    else 
    {
      return db;
    }
  }
  Future<void> close() async{
    final db= _db;
    if(db == null)
    {
      throw DatabaseIsNotOpen();
    }
    else 
    {
      await db.close();
      _db=null;

    }
  }
  Future<void> _ensureDbIsOpen() async {
    try {
      await open();
    }on DatabaseAlreadyOpenException{
      //empty 
    }
  }
  Future<void> open() async{
    if(_db!=null)
    {
      throw DatabaseAlreadyOpenException();
    }
    try 
    {
      final docsPath=await getApplicationDocumentsDirectory();
      final dbPath=join(docsPath.path,dbname);
      final db=await openDatabase(dbPath);
      _db=db;
      await db.execute(createUserTable);
      await db.execute(createNoteTable);
      // await db.execute(createNoteTable);
      await _cacheNotes();

    }on MissingPlatformDirectoryException {
          throw UnableToGetDocumentaryDirectory();
    }
  }

}
@immutable
class DataBaseUser 
{
  final String email;
  final int id;
  const DataBaseUser({required this.email, required this.id});

  DataBaseUser.fromRow(Map<String,Object?> map):id = map[idColumn] as int,
                                               email=map[emailColumn] as String;
  @override
  String toString()=>'Person, id:$id,email:$email';

  @override
  bool operator==(covariant DataBaseUser other)=>id == other.id;

  @override  
   int get hashCode => id.hashCode;
}
class DataBaseNote{
  final int id;
  final int userid;
  final String text;
  final bool isSyncedWithCloud;

  DataBaseNote({required this.id, required this.userid, required this.text, required this.isSyncedWithCloud});
   
  DataBaseNote.fromRow(Map<String,Object?>map):id=map[idColumn] as int,
                                              userid=map[useridColumn] as int,
                                              text=map[textColumn] as String,
                                              isSyncedWithCloud=(map[isSyncedWithCloudColumn] as int)==1 ? true : false ; 
  
  @override
  String toString() => 'Note,id=$id,userid=$userid,isSyncedWithCloud=$isSyncedWithCloud,text=$text';
  
  @override 
  bool operator==(covariant DataBaseNote other)=> id==other.id;

  @override
  int get hashCode => id.hashCode;
}
const createUserTable='''CREATE TABLE IF NOT EXISTS "user" (
	"id"	INTEGER NOT NULL,
	"email"	TEXT NOT NULL UNIQUE,
	PRIMARY KEY("id" AUTOINCREMENT)
);''';
const createNoteTable='''CREATE TABLE IF NOT EXISTS "note" (
	"id"	INTEGER NOT NULL,
	"user_id"	INTEGER NOT NULL,
	"text"	TEXT,
	"is_synces_with_cloud"	INTEGER NOT NULL DEFAULT 0,
  FOREIGN KEY("user_id") REFERENCES "user"("id"),
	PRIMARY KEY("id" AUTOINCREMENT)
);''';
const dbname='note.db';
const noteTable='note';
const userTable='user';
const idColumn='id';
const emailColumn='email';
const useridColumn='user_id';
const textColumn='text';
const isSyncedWithCloudColumn='is_synces_with_cloud';