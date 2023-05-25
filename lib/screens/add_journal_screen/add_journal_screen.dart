import 'dart:io';

import 'package:diario/helpers/weekday.dart';
import 'package:diario/models/journal.dart';
import 'package:diario/services/journal_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helpers/logout.dart';
import '../commom/exception_dialog.dart';

class AddJournalScreen extends StatelessWidget {
  final Journal journal;
  final bool isEditing;
  AddJournalScreen({super.key, required this.journal, required this.isEditing});
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _controller.text = journal.content;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          WeekDay(journal.createdAt).toString(),
        ),
        actions: [
          IconButton(
              onPressed: () {
                registerJournal(context);
              },
              icon: const Icon(Icons.check)),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          controller: _controller,
          keyboardType: TextInputType.multiline,
          style: const TextStyle(fontSize: 24),
          expands: true,
          maxLines: null,
          minLines: null,
        ),
      ),
    );
  }

  registerJournal(BuildContext context) {
    SharedPreferences.getInstance().then(
      (prefs) {
        String? token = prefs.getString("accessToken");

        if (token != null) {
          String content = _controller.text;
          journal.content = content;

          JournalService service = JournalService();

          if (isEditing) {
            service.register(journal, token).then(
              (value) {
                Navigator.pop(context, value);
              },
            ).catchError(
              (error) {
                logout(context);
              },
              test: (error) => error is TokenNotValidException,
            ).catchError(
              (error) {
                showExceptionDialog(context, content: error.message);
              },
              test: (error) => error is HttpException,
            );
          } else {
            service.edit(journal.id, journal, token).then(
              (value) {
                Navigator.pop(context, value);
              },
            ).catchError(
              (error) {
                logout(context);
              },
              test: (error) => error is TokenNotValidException,
            ).catchError(
              (error) {
                showExceptionDialog(context, content: error.message);
              },
              test: (error) => error is HttpException,
            );
          }
        }
      },
    );
  }
}
