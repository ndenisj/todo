// To parse this JSON data, do
//
//     final todo = todoFromMap(jsonString);

import 'dart:convert';

Todo todoFromMap(String str) => Todo.fromMap(json.decode(str));

String todoToMap(Todo data) => json.encode(data.toMap());

class Todo {
  Todo({
    required this.id,
    required this.name,
    required this.description,
  });

  String id;
  String name;
  String description;

  factory Todo.fromMap(Map<String, dynamic> json) => Todo(
        id: json["id"],
        name: json["name"],
        description: json["description"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "description": description,
      };
}
