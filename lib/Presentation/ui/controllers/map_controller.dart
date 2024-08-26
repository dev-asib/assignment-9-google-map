import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapController extends GetxController {
  Position? _currentPosition;
  final List<LatLng> _locationPositions = [];
  GoogleMapController? _mapController;

  Position? get currentPosition => _currentPosition;

  List<LatLng> get locationPositions => _locationPositions;

  GoogleMapController? get mapController => _mapController;

  @override
  void onInit() {
    super.onInit();
    _currentLocation();
    _currentLocationListener();
  }

  void onMapCreated(GoogleMapController googleMapController) {
    _mapController = googleMapController;
    update();
  }

  _animateToCurrentLocation() {
    if (_currentPosition != null && _mapController != null) {
      final currentLatLng = LatLng(
        _currentPosition!.latitude,
        _currentPosition!.longitude,
      );

      _mapController?.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: currentLatLng,
            zoom: 15,
          ),
        ),
      );
    }
  }

  Future<void> _currentLocation() async {
    try {
      await _locationPermissionHandler(
            () async {
          try {
            _currentPosition = await Geolocator.getCurrentPosition(
              locationSettings: const LocationSettings(
                accuracy: LocationAccuracy.best,
                distanceFilter: 1,
                timeLimit: Duration(seconds: 20),
              ),
            );

            if (_currentPosition != null) {
              _locationPositions.add(
                LatLng(
                  _currentPosition!.latitude,
                  _currentPosition!.longitude,
                ),
              );
              _animateToCurrentLocation();

              update();
            } else {
              debugPrint("No Positive retrieve.");
            }
          } catch (e) {
            debugPrint("Error getting current Position: $e");
          }
        },
      );
    } catch (e) {
      debugPrint('Error in location permission handler: $e');
    }
  }

  Future<void> _currentLocationListener() async {
    try {
      _locationPermissionHandler(
            () {
          Geolocator.getPositionStream(
            locationSettings: const LocationSettings(
              accuracy: LocationAccuracy.best,
              distanceFilter: 1,
              timeLimit: Duration(seconds: 10),
            ),
          ).listen(
                (position) {
              if (position != null) {
                _currentPosition = position;
                _locationPositions.add(
                  LatLng(
                    position.latitude,
                    position.longitude,
                  ),
                );

                _animateToCurrentLocation();

                update();
              }
            },
            onError: (e) {
              debugPrint('Error getting location permission: $e');
            },
          );
        },
      );
    } catch (e) {
      debugPrint("Error in location permission handler: $e");
    }
  }

  Future<void> _locationPermissionHandler(VoidCallback startService) async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.always ||
          permission == LocationPermission.whileInUse) {
        final bool isEnabled = await Geolocator.isLocationServiceEnabled();
        if (isEnabled) {
          startService();
        } else {
          Geolocator.openLocationSettings();
        }
      } else {
        if (permission == LocationPermission.deniedForever) {
          Geolocator.openAppSettings();
          return;
        }

        LocationPermission requestedPermission =
        await Geolocator.requestPermission();
        if (requestedPermission == LocationPermission.always ||
            requestedPermission == LocationPermission.whileInUse) {
          _locationPermissionHandler(startService);
        }
      }
    } catch (e) {
      debugPrint('Error handling location permissions: $e');
    }
  }

  @override
  void onClose() {
    _mapController?.dispose();
    super.onClose();
  }
}
