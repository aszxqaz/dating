import 'dart:async';

import 'package:dating/misc/geocoding.dart';
import 'package:dating/misc/location_service.dart';
import 'package:dating/supabase/models/location.dart';
import 'package:dating/supabase/service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:location/location.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends HydratedBloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeState.initial) {
    on<HomeTabChanged>((event, emit) {
      emit(state.copyWith(tab: event.tab));
    });

    on<LocationSubscriptionEnded>((event, emit) {});

    on<LocationChanged>((event, emit) {
      emit(state.copyWith(location: event.location));
    });

    on<LocationSubscriptionStarted>((_, emit) async {
      final curCoords = await getLocationCoords();
      if (curCoords != null) {
        final location = await _fetchLocationIfCoordsChanged(curCoords);

        if (location != null) {
          emit(state.copyWith(location: location));
        }
      }
    });

    on<LocationRequested>((_, emit) async {});

    if (defaultTargetPlatform != TargetPlatform.windows) {
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
              add(LocationChanged(location));
            }
          }
        },
      );
    }
  }

  void setTab(HomeTabs tab) {
    add(HomeTabChanged(tab: tab));
  }

  void startLocationSubscription() {
    add(const LocationSubscriptionStarted());
  }

  void endLocationsSubscription() {
    add(const LocationSubscriptionEnded());
  }

  void setLocation() {
    add(const LocationRequested());
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

  @override
  Future<void> close() {
    _locationSubscription.cancel();
    return super.close();
  }

  // final SupabaseService supabaseService;
  late StreamSubscription<LocationData> _locationSubscription;

  dispose() {}

  @override
  HomeState? fromJson(Map<String, dynamic> json) => HomeState(
        tab: HomeTabs.values[json['tab']],
        location: UserLocation.fromJson(json['location']),
      );

  @override
  Map<String, dynamic>? toJson(HomeState state) => {
        'tab': state.tab.index,
        'location': state.location.toJson(),
      };
}
