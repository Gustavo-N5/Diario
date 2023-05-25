import 'package:flutter/material.dart';

Future<dynamic> showConfirmationDialog(
  BuildContext context, {
  String title = "Atenção",
  String content = "você realmente deseja executar essa operação?",
  String affirmationOption = "confirmar",
}) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text('Cancelar')),
          TextButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: Text(
                affirmationOption.toUpperCase(),
                style: const TextStyle(
                  color: Colors.brown,
                  fontWeight: FontWeight.bold,
                ),
              )),
        ],
      );
    },
  );
}
