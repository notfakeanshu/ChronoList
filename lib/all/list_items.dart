import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
//import 'package:to_do_list/Providers/toDoProvider.dart';
import '../modals/to_do_item.dart';

class ListItems extends ConsumerWidget {
  ListItems({
    super.key,
    required this.items,
    required this.changestatus,
    required this.removeitem,
  });
  final List<ToDoItem> items;
  final Function(bool? status, ToDoItem item) changestatus;
  final void Function(ToDoItem item) removeitem;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // items.add(ToDoItem(title: 'first', status: false));
    Widget content = Center(
      child: Text(
        'No Items Found!',
        style: GoogleFonts.notoSansJavanese(
          color: Colors.black,
          fontSize: 30,
        ),
      ),
    );

    if (items.isNotEmpty) {
      content = ListView.builder(
        padding: const EdgeInsets.all(8.0),
        itemCount: items.length,
        itemBuilder: (ctx, index) {
          final item = items[index];
          return Dismissible(
            key: ValueKey(items[index].id),
            background: Container(
              color: Colors.black87,
              margin: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
              alignment: Alignment.centerLeft,
              child: const Padding(
                padding: EdgeInsets.only(right: 16),
                child: Icon(Icons.delete, size: 33, color: Colors.white),
              ),
            ),
            direction: DismissDirection.startToEnd,
            onDismissed: (direction) {
              //remove function
              removeitem(items[index]);
            },
            child: Card(
              elevation: 5,
              margin: const EdgeInsets.fromLTRB(0, 8, 0, 5), // Reduced margin
              color: Colors.blueGrey[800],
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(12), // Adjusted corner radius
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.fromLTRB(
                    8, 0, 8, 0), // Reduced content padding
                leading: IconButton(
                  icon: Icon(
                    item.status
                        ? Icons.check_circle
                        : Icons.radio_button_unchecked,
                    color: item.status
                        ? const Color.fromARGB(255, 60, 167, 255)
                        : Colors.white,
                  ),
                  onPressed: () {
                    changestatus(!item.status, item);
                  },
                ),
                title: Text(
                  item.title,
                  style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                      decoration:
                          item.status ? TextDecoration.lineThrough : null,
                      decorationThickness:
                          item.status ? 4.5 : null, // Adjust the thickness here
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      );
    }

    return content;
  }
}
