import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../modals/to_do_item.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';
import 'package:path/path.dart' as path;

// Helper function to get the database
Future<Database> getDatabase() async {
  final dbPath = await sql.getDatabasesPath();
  return await sql.openDatabase(
    path.join(dbPath, 'todoitems2.db'),
    onCreate: (db, version) {
      return db.execute(
        'CREATE TABLE todoitems2(id TEXT PRIMARY KEY, title TEXT, status INTEGER)',
      );
    },
    version: 1,
  );
}

// State Notifier for ToDo items
class ToDoNotifier extends StateNotifier<List<ToDoItem>> {
  ToDoNotifier() : super([]);

  // Load items from the database
  Future<void> loadItems() async {
    final database = await getDatabase();
    final data = await database.query('todoitems2');
    List<ToDoItem> dbItems = data.map((row) {
      return ToDoItem(
        id: row['id'] as String,
        title: row['title'] as String,
        status: (row['status'] as int) == 1,
      );
    }).toList();
    state = dbItems;
  }

  // Add a new item to the database and state
  Future<void> addToDoItem(String name, bool currentStatus) async {
    final newItem = ToDoItem(title: name, status: currentStatus);
    final database = await getDatabase();
    await database.insert('todoitems2', {
      'id': newItem.id,
      'title': newItem.title,
      'status': newItem.status ? 1 : 0,
    });
    state = [...state, newItem];
  }

  // Change the status of an item in the database and state
  Future<void> changeStatus(ToDoItem item, bool status) async {
    final database = await getDatabase();
    await database.update(
      'todoitems2',
      {'status': status ? 1 : 0},
      where: 'id = ?',
      whereArgs: [item.id],
    );
    state = state
        .map((e) => e.id == item.id ? e.copyWith(status: status) : e)
        .toList();
  }

  // Remove an item from the database and state
  Future<void> removeItem(ToDoItem item) async {
    state = state.where((e) => e.id != item.id).toList();
    final database = await getDatabase();
    await database.delete(
      'todoitems2',
      where: 'id = ?',
      whereArgs: [item.id],
    );
  }
}

// Provider for ToDo items
final ToDoProvider = StateNotifierProvider<ToDoNotifier, List<ToDoItem>>((ref) {
  return ToDoNotifier();
});
