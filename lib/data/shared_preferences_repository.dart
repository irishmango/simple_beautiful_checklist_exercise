import 'package:shared_preferences/shared_preferences.dart';
import 'database_repository.dart';

class SharedPreferencesRepository implements DatabaseRepository {
  static const String itemsKey = 'checklistItems';

  @override
  Future<int> getItemCount() async {
    final prefs = await SharedPreferences.getInstance();
    final items = prefs.getStringList(itemsKey) ?? [];
    return items.length;
  }

  @override
  Future<List<String>> getItems() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(itemsKey) ?? [];
  }

  @override
  Future<void> addItem(String item) async {
    final prefs = await SharedPreferences.getInstance();
    final items = prefs.getStringList(itemsKey) ?? [];
    if (item.isNotEmpty && !items.contains(item)) {
      items.add(item);
      await prefs.setStringList(itemsKey, items);
    }
  }

  @override
  Future<void> deleteItem(int index) async {
    final prefs = await SharedPreferences.getInstance();
    final items = prefs.getStringList(itemsKey) ?? [];
    if (index >= 0 && index < items.length) {
      items.removeAt(index);
      await prefs.setStringList(itemsKey, items);
    }
  }

  @override
  Future<void> editItem(int index, String newItem) async {
    final prefs = await SharedPreferences.getInstance();
    final items = prefs.getStringList(itemsKey) ?? [];
    if (newItem.isNotEmpty && !items.contains(newItem) && index >= 0 && index < items.length) {
      items[index] = newItem;
      await prefs.setStringList(itemsKey, items);
    }
  }
}