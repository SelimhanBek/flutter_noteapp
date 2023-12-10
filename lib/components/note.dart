import 'package:flutter/material.dart';
import 'package:noteapp/model/note.dart';
import 'package:noteapp/res/global.dart';

class NoteWidget extends StatelessWidget {
  const NoteWidget({
    required this.note,
    required this.onTap,
    required this.dismiss,
    super.key,
  });

  final Note note;
  final Function onTap;
  final Function dismiss;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(note.id),
      direction: DismissDirection.endToStart,
      background: Container(
        margin: const EdgeInsets.all(8),
        padding: const EdgeInsets.all(8),
        color: Colors.red,
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Icon(Icons.delete_forever, color: Colors.white, size: 30),
            Text("Sil", style: TextStyle(color: Colors.white)),
            Padding(padding: EdgeInsets.only(right: 17.5)),
          ],
        ),
      ),
      confirmDismiss: (direction) async {
        await dismiss(note);
        return false;
      },
      child: Material(
        color: Colors.transparent,
        child: Container(
          margin: const EdgeInsets.all(8),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(16)),
            gradient: RadialGradient(
              radius: 10,
              center: Alignment.bottomLeft,
              colors: [
                randomColor(),
                randomColor(),
                randomColor(),
                randomColor(),
                randomColor(),
                randomColor(),
              ],
            ),
          ),
          child: InkWell(
            onTap: () => onTap(note),
            borderRadius: const BorderRadius.all(Radius.circular(16)),
            child: Column(
              children: [
                /* Header */
                Container(
                  margin: const EdgeInsets.all(4),
                  padding: const EdgeInsets.all(4),
                  width: double.infinity,
                  child: Text(
                    note.header,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),

                /* a little sapace */
                const SizedBox(height: 2.5),

                /* Text */
                Container(
                  margin: const EdgeInsets.all(4),
                  padding: const EdgeInsets.all(4),
                  width: double.infinity,
                  child: Text(
                    note.note,
                    style: const TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 14.8,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
