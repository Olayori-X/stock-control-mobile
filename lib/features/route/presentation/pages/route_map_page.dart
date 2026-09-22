import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:stock_control_app/features/route/presentation/provider/route_provider.dart';

class RouteMapPage extends ConsumerWidget {
  const RouteMapPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final plan = ref.watch(routePlanProvider);

    if (plan == null || plan.stops.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text("Route Map")),
        body: const Center(child: Text("No outlets planned for today.")),
      );
    }

    final markers = plan.stops
        .map((stop) => Marker(
              markerId: MarkerId(stop.outletId),
              position: LatLng(stop.latitude, stop.longitude),
              infoWindow: InfoWindow(title: "${stop.sequence}. ${stop.outletName}", snippet: stop.address),
            ))
        .toSet();

    // Draws the planned visit order as a single connected line, matching
    // route_plans.sequence — this is a straight-line path between stops,
    // not a road-following route (that would need the Directions/Routes
    // API, a separate, metered dependency the brief flags as a cost to
    // control deliberately — not pulled in here).
    final polyline = Polyline(
      polylineId: const PolylineId("planned-route"),
      color: Colors.blue,
      width: 4,
      points: plan.stops.map((s) => LatLng(s.latitude, s.longitude)).toList(),
    );

    final firstStop = plan.stops.first;

    return Scaffold(
      appBar: AppBar(title: Text("Route Map — ${plan.routeDay}")),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(firstStop.latitude, firstStop.longitude),
          zoom: 12,
        ),
        markers: markers,
        polylines: {polyline},
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
      ),
    );
  }
}