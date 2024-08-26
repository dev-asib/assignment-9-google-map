import 'package:asignment_9_google_map/Presentation/ui/controllers/map_controller.dart';
import 'package:asignment_9_google_map/Presentation/ui/themes/app_colors.dart';
import 'package:asignment_9_google_map/Presentation/ui/widgets/app_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapScreen extends StatefulWidget {
  const GoogleMapScreen({super.key});

  @override
  State<GoogleMapScreen> createState() => _GoogleMapScreenState();
}

class _GoogleMapScreenState extends State<GoogleMapScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(),
      body: GetBuilder<MapController>(
        init: MapController(),
        builder: (mapController) {
          return GoogleMap(
            initialCameraPosition: CameraPosition(
              zoom: 15,
                target: LatLng(23.86969098068808, 90.00041101362076),
            ),
            onMapCreated: (GoogleMapController controller) {
              mapController.onMapCreated(controller);
            },
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            polylines: <Polyline>{
              Polyline(
                polylineId: const PolylineId('polyLine-1'),
                color: AppColors.blueColor,
                width: 10,
                jointType: JointType.round,
                points: mapController.locationPositions,
              ),
            },
            markers: mapController.currentPosition != null
                ? <Marker>{
                    Marker(
                      markerId: const MarkerId('marker-1'),
                      infoWindow: InfoWindow(
                        title: "My Current Location",
                        snippet:
                            '${mapController.currentPosition!.latitude},${mapController.currentPosition!.longitude}',
                      ),
                      position: LatLng(
                        mapController.currentPosition!.latitude,
                        mapController.currentPosition!.longitude,
                      ),
                    ),
                  }
                : <Marker>{},
          );
        },
      ),
    );
  }
}
