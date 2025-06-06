import 'package:flutter/material.dart';
import 'package:simple_beautiful_checklist_exercise/data/database_repository.dart';
import 'package:simple_beautiful_checklist_exercise/src/features/task_list/widgets/empty_content.dart';
import 'package:simple_beautiful_checklist_exercise/src/features/task_list/widgets/item_list.dart';


class ListScreen extends StatefulWidget {
  const ListScreen({
    super.key,
    required this.repository,
    required this.toggleTheme,
    required this.isDarkMode,
  });

  final DatabaseRepository repository;
  final VoidCallback toggleTheme;
  final bool isDarkMode;


  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  final List<String> _items = [];
  bool isLoading = true;
  final TextEditingController _controller = TextEditingController();
  bool isDark = false;
   

  @override
  void initState() {
    super.initState();
    
    _updateList();
  }

  void _updateList() async {
    _items.clear();
    _items.addAll(await widget.repository.getItems());
    isLoading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meine Checkliste'),
        actions: [
              Padding(
                padding: const EdgeInsets.only(right: 20),
                child: Switch(
                  value: isDark,
                  onChanged: (value) {
                    setState(() {
                      widget.toggleTheme();
                      isDark = !isDark;
                    });
                    
                  },
                ),
              ),
            ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: _items.isEmpty
                      ? const EmptyContent()
                      : ItemList(
                          repository: widget.repository,
                          items: _items,
                          updateOnChange: _updateList,
                        ),
                ),
                Padding(
                  padding: const EdgeInsets.all(40.0),
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      labelText: 'Task Hinzufügen',
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () {
                          if (_controller.text.isNotEmpty) {
                            widget.repository.addItem(_controller.text);
                            _controller.clear();
                            _updateList();
                          }
                        },
                      ),
                    ),
                    onSubmitted: (value) {
                      if (value.isNotEmpty) {
                        widget.repository.addItem(value);
                        _controller.clear();
                        _updateList();
                      }
                    },
                  ),
                ),
              ],
            ),
    );
  }
}