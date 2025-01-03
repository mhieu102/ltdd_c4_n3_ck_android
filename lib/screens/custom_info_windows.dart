import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HutechMap extends StatefulWidget {
  const HutechMap({super.key});

  @override
  State<HutechMap> createState() => _HutechMapState();
}

class _HutechMapState extends State<HutechMap> {
  final Set<Marker> markers = {};
  final Set<Polyline> polylines = {};
  late GoogleMapController mapController;
  String nearestLocationName = '';
  double distanceToNearestLocation = 0.0;

  final List<Map<String, dynamic>> hutechLocations = [
    {
      "name": "Cơ sở 1 - Điện Biên Phủ",
      "position": const LatLng(10.8016, 106.7147),
      "details": "Địa chỉ: 475A Điện Biên Phủ, Phường 25, Quận Bình Thạnh, TP.HCM"
    },
    {
      "name": "Cơ sở 2 - Thủ Đức",
      "position": const LatLng(10.855668868800782, 106.78516958741625),
      "details": "Địa chỉ: Khu Công Nghệ Cao, Quận 9, TP.HCM"
    },
    {
      "name": "Cơ sở 3 - Ung Văn Khiêm",
      "position": const LatLng(10.8097, 106.7150),
      "details": "Địa chỉ: 31/36 Ung Văn Khiêm, Phường 25, Quận Bình Thạnh, TP.HCM"
    },
  ];

  @override
  void initState() {
    super.initState();
    _requestLocationPermission();
    _initializeMarkers();
    _addCurrentLocationMarker();
  }

  Future<void> _requestLocationPermission() async {
    var status = await Geolocator.checkPermission();
    if (status == LocationPermission.denied) {
      status = await Geolocator.requestPermission();
    }

    if (status == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Quyền truy cập vị trí bị từ chối vĩnh viễn."),
          backgroundColor: Colors.red,
        ),
      );
    } else if (status == LocationPermission.denied) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Quyền truy cập vị trí bị từ chối."),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _addCurrentLocationMarker() async {
    var permissionStatus = await Geolocator.checkPermission();
    if (permissionStatus == LocationPermission.denied ||
        permissionStatus == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Ứng dụng cần quyền truy cập vị trí để hoạt động."),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      Position currentPosition = await _getCurrentPosition();
      LatLng currentLatLng = LatLng(currentPosition.latitude, currentPosition.longitude);

      setState(() {
        markers.removeWhere((marker) => marker.markerId.value == 'user_selected_location');

        markers.add(
          Marker(
            markerId: const MarkerId("current_location"),
            position: currentLatLng,
            infoWindow: const InfoWindow(
              title: "Vị trí của bạn",
              snippet: "Bạn đang ở đây",
            ),
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          ),
        );

        mapController.animateCamera(
          CameraUpdate.newLatLngZoom(currentLatLng, 14),
        );

        int nearestIndex = _findNearestLocation(currentLatLng);
        nearestLocationName = hutechLocations[nearestIndex]["name"];
        distanceToNearestLocation = _calculateDistance(currentLatLng, hutechLocations[nearestIndex]["position"]);
        _drawRoute(currentLatLng, nearestIndex);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Không thể lấy vị trí hiện tại."),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<Position> _getCurrentPosition() async {
    return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }

  void _initializeMarkers() {
    for (var location in hutechLocations) {
      markers.add(
        Marker(
          markerId: MarkerId(location["name"]),
          position: location["position"],
          infoWindow: InfoWindow(
            title: location["name"],
            snippet: location["details"],
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        ),
      );
    }
    setState(() {});
  }

  double _calculateDistance(LatLng start, LatLng end) {
    return Geolocator.distanceBetween(
      start.latitude,
      start.longitude,
      end.latitude,
      end.longitude,
    );
  }

  int _findNearestLocation(LatLng userLocation) {
    double minDistance = double.infinity;
    int nearestIndex = 0;

    for (int i = 0; i < hutechLocations.length; i++) {
      double distance = _calculateDistance(userLocation, hutechLocations[i]["position"]);
      if (distance < minDistance) {
        minDistance = distance;
        nearestIndex = i;
      }
    }
    return nearestIndex;
  }

  void _drawRoute(LatLng userLocation, int nearestIndex) async {
    final String apiKey = 'AIzaSyDv21lwfCRNhCqaprdMQjoSjxcU226fxHA';
    final String url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=${userLocation.latitude},${userLocation.longitude}&destination=${hutechLocations[nearestIndex]["position"].latitude},${hutechLocations[nearestIndex]["position"].longitude}&key=$apiKey';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['routes'].isNotEmpty) {
          final route = data['routes'][0]['legs'][0]['steps'] as List;
          List<LatLng> polylineCoordinates = [];

          for (var step in route) {
            final lat = step['end_location']['lat'];
            final lng = step['end_location']['lng'];
            polylineCoordinates.add(LatLng(lat, lng));
          }

          setState(() {
            polylines.clear();
            polylines.add(
              Polyline(
                polylineId: PolylineId('route'),
                points: polylineCoordinates,
                color: Colors.blue,
                width: 5,
              ),
            );                            
          });
        } else {
          print('Không tìm thấy lộ trình.');
          final data = json.decode(response.body);
          print('Phản hồi API: $data');

        }
      } else {
        throw Exception('Không thể tải lộ trình');

      }
    } catch (e) {
      print('Lỗi khi lấy thông tin chỉ đường: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bản đồ '),
        backgroundColor: Colors.orange,
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: const CameraPosition(
              target: LatLng(10.8016, 106.7147),
              zoom: 12,
            ),
            markers: markers,
            polylines: polylines,
            onMapCreated: (controller) {
              mapController = controller;
            },
            onTap: (LatLng position) {
              setState(() {
                markers.removeWhere((marker) => marker.markerId.value == 'user_selected_location');
                markers.add(
                  Marker(
                    markerId: const MarkerId('user_selected_location'),
                    position: position,
                    infoWindow: const InfoWindow(
                      title: 'Vị trí đã chọn',
                      snippet: 'Vị trí bạn vừa nhấn',
                    ),
                    icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
                  ),
                );
              });

              int nearestIndex = _findNearestLocation(position);
              nearestLocationName = hutechLocations[nearestIndex]["name"];
              distanceToNearestLocation = _calculateDistance(position, hutechLocations[nearestIndex]["position"]);
              _drawRoute(position, nearestIndex);
            },
          ),
          Positioned(
            bottom: 16,
            left: 16,
            child: ElevatedButton(
              onPressed: () async {
                await _addCurrentLocationMarker();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
              ),
              child: const Text("Vị trí hiện tại"),
            ),
          ),
          Positioned(
            bottom: 100,
            left: 16,
            child: Card(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Cơ sở gần nhất: $nearestLocationName",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "Khoảng cách: ${(distanceToNearestLocation / 1000).toStringAsFixed(2)} km",
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
