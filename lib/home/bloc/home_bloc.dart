import 'dart:async';

import 'package:dating/misc/geocoding.dart';
import 'package:dating/misc/location_service.dart';
import 'package:dating/supabase/service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:location/location.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<_HomeEvent, HomeState> {
  HomeBloc() : super(HomeState.initial) {
    on<_HomeTabChanged>(_onTabChanged);
    on<_LocationChanged>(_onLocationChanged);
    on<_LocationSubscriptionRequested>(_onLocationSubscriptionRequested);
    on<_LastSeenSubscriptionRequested>(_onLastSeenSubscriptionRequested);
  }

  static HomeBloc of(BuildContext context) => context.read<HomeBloc>();

  late StreamSubscription<LocationData> _locationSubscription;
  late StreamSubscription _lastSeenUpdateSubscription;

  // ---
  // --- LIFECYCLE
  // ---

  @override
  Future<void> close() {
    _locationSubscription.cancel();
    _lastSeenUpdateSubscription.cancel();
    return super.close();
  }

  // ---
  // --- EVENT HANDLERS
  // ---

  FutureOr<void> _onTabChanged(_HomeTabChanged event, Emitter emit) {
    emit(state.copyWith(tab: event.tab));
  }

  FutureOr<void> _onLocationChanged(_LocationChanged event, Emitter emit) {
    emit(state.copyWith(location: event.location));
  }

  FutureOr<void> _onLocationSubscriptionRequested(
    _LocationSubscriptionRequested event,
    Emitter emit,
  ) async {
    final curCoords = await getLocationCoords();
    if (curCoords != null) {
      final location = await _fetchLocationIfCoordsChanged(curCoords);

      if (location != null) {
        emit(state.copyWith(location: location));
      }
    }
  }

  Future<void> _onLastSeenSubscriptionRequested(
    _LastSeenSubscriptionRequested _,
    Emitter emit,
  ) async {
    await supabaseService.updateLastSeen();
    debugPrint('Updated last seen');

    _lastSeenUpdateSubscription =
        Stream.periodic(const Duration(minutes: 1)).listen((_) async {
      debugPrint('Updating last seen');
      await supabaseService.updateLastSeen();
    });
  }

  // ---
  // --- MISC METHODS
  // ---

  void _startLocationSubscription() {
    if (defaultTargetPlatform == TargetPlatform.windows) return;
    Location().changeSettings(interval: 500000);

    _locationSubscription = Location().onLocationChanged.listen(
      (data) async {
        if (data.latitude != null && data.longitude != null) {
          final curCoords = CurrentCoords(
            latitude: data.latitude!,
            longitude: data.longitude!,
          );

          final location = await _fetchLocationIfCoordsChanged(curCoords);

          if (location != null) {
            add(_LocationChanged(location));
          }
        }
      },
    );
  }

  Future<UserLocation?> _fetchLocationIfCoordsChanged(
    CurrentCoords coords,
  ) async {
    final curLocation = await fetchLocation(coords);

    if (curLocation?.city != null && curLocation?.country != null) {
      if (curLocation!.country != state.location.country ||
          curLocation.city != state.location.city) {
        await supabaseService.updateLocation(
          latitude: coords.latitude,
          longitude: coords.longitude,
          country: curLocation.country,
          city: curLocation.city,
        );
        return state.location.copyWith(
          latitude: coords.latitude,
          longitude: coords.longitude,
          country: curLocation.country,
          city: curLocation.city,
        );
      }
    }

    return null;
  }

  // ---
  // --- PUBLIC API
  // ---

  void setTab(HomeTabs tab) {
    add(_HomeTabChanged(tab: tab));
  }

  void requestLocationSubscription() {
    add(const _LocationSubscriptionRequested());
  }

  void requestLastSeenSubscription() {
    add(const _LastSeenSubscriptionRequested());
  }

  void endLocationsSubscription() {
    add(const _LocationSubscriptionEnded());
  }

  void setLocation() {
    add(const _LocationRequested());
  }

  // ---
  // --- JSON SERIALIZATION
  // ---

  // @override
  // HomeState? fromJson(Map<String, dynamic> json) => HomeState(
  //       tab: HomeTabs.values[json['tab']],
  //       location: UserLocation.fromJson(json['location']),
  //     );

  // @override
  // Map<String, dynamic>? toJson(HomeState state) => {
  //       'tab': state.tab.index,
  //       'location': state.location.toJson(),
  //     };
}
