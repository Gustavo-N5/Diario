// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:uuid/uuid.dart';

class Journal {
  String id;
  String content;
  DateTime createdAt;
  DateTime updatedAt;
  int userId;

  Journal({
    required this.id,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
    required this.userId,
  });

  @override
  String toString() {
    return "$content \ncreated_at: $createdAt\nupdated_at:$updatedAt\nuserId: $userId";
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'content': content,
      'createdAt': createdAt.toString(),
      'updatedAt': updatedAt.toString(),
      'userId': userId,
    };
  }

  Journal.empty({required int id})
      : id = const Uuid().v1(),
        content = "",
        createdAt = DateTime.now(),
        updatedAt = DateTime.now(),
        userId = id;

  factory Journal.fromMap(Map<String, dynamic> map) {
    return Journal(
      id: map['id'] as String,
      content: map['content'] as String,
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
      userId: map["userId"],
    );
  }

  String toJson() => json.encode(toMap());

  factory Journal.fromJson(String source) =>
      Journal.fromMap(json.decode(source) as Map<String, dynamic>);
}
