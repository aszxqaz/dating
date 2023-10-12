part of 'service.dart';

mixin _ChannelService on _SupabaseService {
  RealtimeChannel createChannel(String name) {
    return supabaseClient.channel(name)
      ..onClose(() {
        debugPrint('RealtimeChannel [$name]: CLOSED');
      })
      ..onError((error) {
        debugPrint('RealtimeChannel [$name]: ERROR $error');
      });
  }
}

extension ShortOn on RealtimeChannel {
  on_({
    required String table,
    required String filter,
    required String event,
    String? endPath,
    required FutureOr<void> Function(dynamic) onData,
  }) {
    return on(
      RealtimeListenTypes.postgresChanges,
      ChannelFilter(
        event: event,
        schema: 'public',
        table: table,
        filter: filter,
      ),
      (payload, [ref]) async {
        if (payload.containsKey('new')) {
          await onData(payload['new']);
        }
      },
    );
  }
}
