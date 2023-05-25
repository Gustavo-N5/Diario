import 'dart:convert';
import 'dart:io';
import 'package:diario/models/journal.dart';
import 'package:diario/services/web_client.dart';
import 'package:http/http.dart' as http;

// comando para rodar a service  npx json-server --watch --host 192.168.1.9 server/db.json
class JournalService {
  static const String resource = "journals/";
  http.Client client = WebClient().client;
  String url = WebClient.url;

  String getUrl() {
    return "$url$resource";
  }

  Future<bool> register(Journal journal, String token) async {
    String jsonJournal = journal.toJson();
    http.Response response = await client.post(
      Uri.parse(getUrl()),
      headers: {
        'Content-type': 'application/json',
        "Authorization": "Bearer $token",
      },
      body: jsonJournal,
    );
    if (response.statusCode != 201) {
      if (json.decode(response.body) == "jwt expired") {
        throw TokenNotValidException();
      }
      throw HttpException(response.body);
    }
    return true;
  }

  Future<bool> edit(String id, Journal journal, String token) async {
    journal.updatedAt = DateTime.now();
    String jsonJournal = journal.toJson();

    http.Response response = await client.put(
      Uri.parse("${getUrl()}$id"),
      headers: {
        'Content-type': 'application/json',
        "Authorization": "Bearer $token",
      },
      body: jsonJournal,
    );
    if (response.statusCode != 200) {
      if (json.decode(response.body) == "jwt expired") {
        throw TokenNotValidException();
      }
      throw HttpException(response.body);
    }
    return true;
  }

  Future<List<Journal>> getAll(
      {required String id, required String token}) async {
    http.Response response = await client.get(
      Uri.parse("${url}users/$id/journals"),
      headers: {"Authorization": "Bearer $token"},
    );

    if (response.statusCode != 200) {
      if (json.decode(response.body) == "jwt expired") {
        throw TokenNotValidException();
      }
      throw HttpException(response.body);
    }

    List<Journal> list = [];

    List<dynamic> listDynamic = json.decode(response.body);

    for (var jsonMap in listDynamic) {
      list.add(Journal.fromMap(jsonMap));
    }

    return list;
  }

  Future<bool> delete(String id, String token) async {
    http.Response response = await http.delete(Uri.parse("${getUrl()}$id"),
        headers: {"Authorization": "Bearer $token"});

    if (response.statusCode != 200) {
      if (json.decode(response.body) == "jwt expired") {
        throw TokenNotValidException();
      }
      throw HttpException(response.body);
    }
    return true;
  }
}

class TokenNotValidException implements Exception {}
