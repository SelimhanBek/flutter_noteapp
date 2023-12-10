import 'package:flutter/material.dart';

class EditNotePage extends StatefulWidget {
  const EditNotePage({
    required this.id,
    this.header = "",
    this.text = "",
    super.key,
  });

  final String id;
  final String header;
  final String text;

  @override
  State<EditNotePage> createState() => _EditNotePageState();
}

class _EditNotePageState extends State<EditNotePage> {
  /* Local Variables */
  final GlobalKey _key = GlobalKey();
  final TextEditingController _ctHeader = TextEditingController();
  final TextEditingController _ctText = TextEditingController();
  var _header = "";
  var _text = "";

  @override
  void initState() {
    super.initState();

    /* Check Is old ? */
    if (widget.header.isNotEmpty) {
      _header = widget.header.trim();
      _ctHeader.text = widget.header.trim();
    } else {
      _header = "Başlık 1";
      _ctHeader.text = "Başlık 1";
    }

    /* Check Is old ? */
    if (widget.text.isNotEmpty) {
      _text = widget.text.trim();
      _ctText.text = widget.text.trim();
    }
  }

  /* Save Function */
  _save() {
    Navigator.of(context).pop([_header, _text]);
  }

  @override
  void dispose() {
    _ctHeader.dispose();
    _ctText.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Düzenle"),
          centerTitle: false,
          leading: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.arrow_back_rounded),
            visualDensity: VisualDensity.compact,
            tooltip: "Geri",
          ),
          actions: [
            /* Create Button */
            IconButton(
              onPressed: () => _save(),
              icon: const Icon(Icons.save_rounded),
              visualDensity: VisualDensity.compact,
              tooltip: "Kaydet",
            ),

            /* a little padding */
            const Padding(padding: EdgeInsets.only(right: 8)),
          ],
        ),
        body: SafeArea(
          child: SizedBox.expand(
            child: Form(
              key: _key,
              child: Column(
                children: [
                  /* Header Text */
                  SizedBox(
                    height: 60,
                    width: double.infinity,
                    child: TextFormField(
                      key: const Key("header"),
                      controller: _ctHeader,
                      onTap: () {
                        _ctHeader.selection = TextSelection(
                          baseOffset: 0,
                          extentOffset: _header.length,
                        );
                      },
                      onChanged: (val) {
                        setState(() {
                          _header = val.trim();
                        });
                      },
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                      decoration: const InputDecoration(
                        hintText: "Başlık",
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(8),
                      ),
                    ),
                  ),

                  /* Note Area */
                  Expanded(
                    child: TextFormField(
                      key: const Key("notearea"),
                      controller: _ctText,
                      expands: true,
                      maxLines: null,
                      minLines: null,
                      keyboardType: TextInputType.multiline,
                      onChanged: (val) {
                        setState(() {
                          _text = val.trim();
                        });
                      },
                      decoration: const InputDecoration(
                        hintText: "Bir şeyler yazın...",
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(8),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
