import 'package:collection/collection.dart';
import 'package:dating/misc/uuid.dart';

class Identifiable {
  Identifiable({String? id}) : id = id ?? uuid.v4();

  final String id;
}

extension IdentifiableList<T extends Identifiable> on List<T> {
  List<T> upsert(List<T> items, [bool start = false]) {
    var copy = this;

    for (final item in items) {
      final index = copy.indexWhere((cItem) => cItem.id == item.id);
      if (index != -1) {
        copy = copy.slice(0, index) + [item] + copy.slice(index + 1);
      } else {
        if (start) {
          copy = [item] + copy;
        } else {
          copy = copy + [item];
        }
      }
    }

    return copy;
  }

  List<T> update(T item) {
    final index = indexWhere((i) => i.id == item.id);

    if (index == -1) return this;

    return slice(0, index) + [item] + slice(index + 1);
  }

  List<T> exclude(String id) {
    return whereNot((element) => element.id == id).toList();
  }

  T? get(String id) => firstWhereOrNull((element) => element.id == id);
}
