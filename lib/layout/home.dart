import 'package:flutter/material.dart';
import 'package:noteapp/components/note.dart';
import 'package:noteapp/layout/edit_note.dart';
import 'package:noteapp/model/note.dart';
import 'package:noteapp/res/global.dart';
import 'package:sqflite/sqflite.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  /* Local Variables */
  late Database _db;
  List<Note> _notes = [];

  /* Close Db */
  _closeDB() => _db.close();

  /* Load Saved Notes */
  _loadNotes() async {
    /* Init DB */
    _db = await openDatabase(
      dbName,
      version: 1,
      onCreate: (Database db, int version) async {
        // When creating the db, create the table
        await db.execute(
          'CREATE TABLE $dbTableName (header TEXT, note TEXT, id TEXT, date TEXT)',
        );
      },
    );

    /* Get the Records */
    List<Map<String, dynamic>> records =
        await _db.rawQuery('SELECT * FROM $dbTableName');

    /* Convert each item to Note obj */
    List<Note> savedNotes = [];
    if (records.isNotEmpty) {
      for (var e in records) {
        savedNotes.add(Note.fromJson(e));
      }
    }

    /* Load Items on Interface */
    setState(() {
      _notes = savedNotes;
    });
  }

  /* Insert a new record */
  _insertToDB(Note note) async => await _db.transaction((txn) async {
        /* Transaction */
        await txn.rawInsert(
          'INSERT INTO $dbTableName (id, header, note, date) VALUES(?, ?, ?, ?)',
          note.toList(),
        );
      });

  /* Delete a record from table */
  _deleteRecord(Note note) async => await _db.rawDelete(
        'DELETE FROM $dbTableName WHERE id = ?',
        [note.id],
      );

  /* Update a record */
  _updateRecord(Note note) async => await _db.rawUpdate(
        'UPDATE $dbTableName SET header = ?, note = ?, date = ? WHERE id = ?',
        [note.header, note.note, generateUniqueNumber(), note.id],
      );

  /* Edit Note */
  _editNote(String id) {
    /* Create a new Note */
    Note note = Note(id: id, header: "", date: id, note: "");

    /* Check Note if Exist */
    int index = _notes.indexWhere((e) => e.id == id);

    /* Found smth */
    if (index != -1) {
      note = _notes.firstWhere((e) => e.id == id);
    }

    /* Go to Note Page */
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditNotePage(
          id: id,
          header: note.header,
          text: note.note,
        ),
      ),
    ).then((value) {
      if (mounted) {
        setState(() {
          if (index == -1) {
            /* Create a new Note */
            _notes.add(
              note
                ..header = value[0]
                ..note = value[1],
            );

            /* Save to Memory */
            _insertToDB(note);
          } else {
            /* Edit Existing Note */
            _notes[index].header = value[0];
            _notes[index].note = value[1];

            /* Save to Memory */
            _updateRecord(note);
          }
        });
      }
    }).catchError((err) {
      throw "No change detected";
    });
  }

  /* Remove Note */
  _removeNote(Note note) {
    /* Delete records from dB */
    _deleteRecord(note);

    /* Remove from State */
    setState(() {
      _notes.removeWhere((e) => e.id == note.id);
    });
  }

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  @override
  void dispose() {
    _closeDB();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Note APP'),
        actions: [
          /* Create Button */
          IconButton(
            onPressed: () => _editNote(generateUniqueNumber()),
            icon: const Icon(Icons.add_rounded),
            visualDensity: VisualDensity.compact,
            tooltip: "Oluştur",
          ),

          /* a little padding */
          const Padding(padding: EdgeInsets.only(right: 8)),
        ],
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            setState(() {
              _notes;
            });
          },
          child: SizedBox.expand(
            child: _notes.isEmpty
                ? Container(
                    margin: const EdgeInsets.all(8),
                    padding: const EdgeInsets.all(8),
                    child: const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          /* Help 1 */
                          SizedBox(
                            width: double.infinity,
                            child: Text(
                              '"+" butonuna basarak yeni not oluşturabilirsin.',
                              style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),

                          /* a little space */
                          SizedBox(height: 50),

                          /* Help 1 */
                          SizedBox(
                            width: double.infinity,
                            child: Text(
                              'Oluşturduğun notları ↸ kaydırarak silebilirsin',
                              style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: _notes.length,
                    itemBuilder: (context, index) {
                      return NoteWidget(
                        note: _notes[index],
                        onTap: (note) => _editNote(note.id),
                        dismiss: (note) => _removeNote(note),
                      );
                    },
                  ),
          ),
        ),
      ),
    );
  }
}
