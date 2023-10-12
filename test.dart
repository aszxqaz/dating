import 'package:collection/collection.dart';

extension Upsert<T> on List<T> {
  List<T> updated(int index, T item, [bool panic = false]) {
    if (index < 0 || index >= length && !panic) {
      print('ERROR: List.updated() error: not found at index $index.');
      return this;
    }

    return slice(0, index) + [item] + slice(index + 1);
  }

  List<T> replaceWhere(
    T item,
    bool Function(T item) predicate, [
    bool panic = false,
  ]) {
    final index = indexWhere(predicate);
    if (index == -1 && !panic) {
      print('ERROR: List.updatedWhere() error: not found.');
      return this;
    }

    return updated(index, item, panic);
  }

  List<T> updateWhere(
    T Function(T item) updateFn,
    bool Function(T item) predicate, [
    bool panic = false,
  ]) {
    final index = indexWhere(predicate);
    if (index == -1 && !panic) {
      print('ERROR: List.updatedWhere() error: not found.');
      return this;
    }

    return updated(index, updateFn(this[index]), panic);
  }

  List<T> upsertWhere(
    T item,
    bool Function(T item) predicate, [
    bool atStart = false,
  ]) {
    final index = indexWhere(predicate);

    if (index != -1) {
      return updated(index, item);
    } else {
      return atStart ? [item, ...this] : [...this, item];
    }
  }
}

void main() {
  final list = [1, 2, 3, 4];

  final a = list.updateWhere((item) => item + 1, (item) => item == 4);
  print(a);
}
