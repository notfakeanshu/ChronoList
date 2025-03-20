import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:to_do_list/Providers/toDoProvider.dart';
import 'package:to_do_list/Screens/list_items.dart';
import 'package:to_do_list/modals/to_do_item.dart';
import '../widgets/Adddialousebox.dart';

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  late Future<void> futureitems;

  @override
  void initState() {
    futureitems = ref.read(ToDoProvider.notifier).loadItems();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<ToDoItem> items = ref.watch(ToDoProvider);
    // items.add(ToDoItem(title: 'First', status: false));
    void changeStatus(ToDoItem item, bool? status) {
      setState(() {
        // item.status = status!;
        ref.read(ToDoProvider.notifier).changeStatus(item, status!);
      });
    }

    void removeitem(ToDoItem item) {
      setState(() {
        ref.read(ToDoProvider.notifier).removeItem(item);
      });
    }

    void addItem(BuildContext context) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return const AddDialogBox();
        },
      );
    }

    return Scaffold(
      backgroundColor: Colors.white60,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.blueGrey[900],
        title: Text(
          'To-do list',
          style: GoogleFonts.pacifico(
            fontWeight: FontWeight.w300,
            color: Colors.white,
            fontSize: 30,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder(
            future: futureitems,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              return ListItems(
                items: items,
                changestatus: (status, item) {
                  changeStatus(item, status);
                },
                removeitem: removeitem,
              );
            }),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueGrey[900],
        onPressed: () {
          addItem(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
