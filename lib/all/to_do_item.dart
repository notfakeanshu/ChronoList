import 'package:uuid/uuid.dart';

const uuid = Uuid();

class ToDoItem {
  ToDoItem({
    required this.title,
    required this.status,
    String? id,
  }) : id = id ?? uuid.v4();

  final String id;
  final String title;
  bool status;

  // Method to create a copy of the item with updated properties
  ToDoItem copyWith({String? id, String? title, bool? status}) {
    return ToDoItem(
      id: id ?? this.id,
      title: title ?? this.title,
      status: status ?? this.status,
    );
  }
}
