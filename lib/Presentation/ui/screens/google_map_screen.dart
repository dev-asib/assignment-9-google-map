import 'package:asignment_9_google_map/Presentation/ui/themes/app_colors.dart';
import 'package:asignment_9_google_map/Presentation/ui/widgets/app_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapScreen extends StatefulWidget {
  const GoogleMapScreen({super.key});

  @override
  State<GoogleMapScreen> createState() => _GoogleMapScreenState();
}

class _GoogleMapScreenState extends State<GoogleMapScreen> {
  Position? _currentPosition;
  final List<LatLng> _locationPositions = [];

  GoogleMapController? _mapController;

  @override
  void initState() {
    super.initState();
    _currentLocation();
    _currentLocationListener();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(),
      body: GoogleMap(
        initialCameraPosition: const CameraPosition(
          zoom: 16,
          target: LatLng(23.86969098068808, 90.00041101362076),
        ),
        onMapCreated: (GoogleMapController controller) {
          _mapController = controller;
        },
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        polylines: <Polyline>{
          Polyline(
            polylineId: const PolylineId('polyLine-1'),
            color: AppColors.blueColor,
            width: 10,
            jointType: JointType.round,
            points: _locationPositions,
          ),
        },
        markers: _currentPosition != null
            ? <Marker>{
          Marker(
            markerId: const MarkerId('marker-1'),
            infoWindow: InfoWindow(
              title: "My Current Location",
              snippet:
              'Lat: ${_currentPosition!.latitude}, Lng: ${_currentPosition!.longitude}',
            ),
            position: LatLng(
              _currentPosition!.latitude,
              _currentPosition!.longitude,
            ),
          ),
        }
            : <Marker>{},
      ),
    );
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
            zoom: 16,
          ),
        ),
      );
    }
  }

  Future<void> _currentLocation() async {
    _locationPermissionHandler(
          () async {
        _currentPosition = await Geolocator.getCurrentPosition(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.best,
            distanceFilter: 1,
            timeLimit: Duration(seconds: 10),
          ),
        );

        if (mounted) {
          setState(
                () {
              _locationPositions.add(
                LatLng(
                  _currentPosition!.latitude,
                  _currentPosition!.longitude,
                ),
              );
            },
          );
          _animateToCurrentLocation();
        }
      },
    );
  }

  Future<void> _currentLocationListener() async {
    _locationPermissionHandler(
          () {
        Geolocator.getPositionStream(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.best,
            distanceFilter: 1,
            timeLimit: Duration(seconds: 5),
          ),
        ).listen(
              (position) {
            if (mounted && position != null) {
              setState(
                    () {
                  _locationPositions.add(
                    LatLng(
                      position.latitude,
                      position.longitude,
                    ),
                  );
                },
              );
              _animateToCurrentLocation();
            }
          },
        );
      },
    );
  }

  Future<void> _locationPermissionHandler(VoidCallback startService) async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse) {
      final bool isEnable = await Geolocator.isLocationServiceEnabled();
      if (isEnable) {
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
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }
}
