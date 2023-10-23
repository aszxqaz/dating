import 'package:dating/interfaces/identifiable.dart';
import 'package:flutter/foundation.dart';

enum LoadingStatus { loading, failure, loaded }

typedef LoadingStatusMap = Map<String, LoadingStatus>;

@immutable
class ItemsStore<T extends Identifiable> {
  const ItemsStore({
    required this.items,
    this.last = const [],
    this.loading = LoadingStatus.loading,
    this.statuses = const {},
  });

  final List<T> items;
  final List<T> last;
  final LoadingStatus loading;
  final LoadingStatusMap statuses;

  ItemsStore<T> copyWith({
    List<T>? items,
    List<T>? last,
    LoadingStatus? loading,
    LoadingStatusMap? statuses,
  }) =>
      ItemsStore(
        items: items ?? this.items,
        last: last ?? this.last,
        loading: loading ?? this.loading,
        statuses: statuses ?? this.statuses,
      );

  ItemsStore<T> upsert(List<T> items, [bool start = false]) => copyWith(
        items: this.items.upsert(items, start),
        last: items,
      );

  ItemsStore<T> setStatus(String id, LoadingStatus status) =>
      copyWith(statuses: {
        ...statuses,
        id: status,
      });
}
