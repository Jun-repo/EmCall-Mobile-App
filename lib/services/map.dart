import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  MapPageState createState() => MapPageState();
}

class MapPageState extends State<MapPage> with SingleTickerProviderStateMixin {
  static const accessToken =
      'pk.eyJ1IjoiYnVkZHlhcHAwMSIsImEiOiJjbHlkbmQwM3IwN29lMmhzY2xlaHB5cGdlIn0._lyRkBeBqxS-Cr6gpYYRMQ';

  final MapController _mapController = MapController(); // Add MapController
  String selectedStyle = 'streets-v11';
  final Map<String, String> mapboxStyles = {
    'Streets': 'streets-v11',
    'Outdoors': 'outdoors-v11',
    'Light': 'light-v10',
    'Dark': 'dark-v10',
    'Satellite': 'satellite-v9',
    'Satellite Streets': 'satellite-streets-v11',
  };

  final PanelController _panelController = PanelController();
  double _fabBottomPosition = 120;
  Location location = Location();
  LatLng? initialPosition;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _initLocation();

    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();

    _animation = Tween<double>(begin: 0.2, end: 1.5).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _initLocation() async {
    bool serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) return;
    }

    PermissionStatus permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) return;
    }

    location.changeSettings(
      accuracy: LocationAccuracy.high,
      interval: 1000,
      distanceFilter: 0,
    );

    LocationData locationData = await location.getLocation();
    setState(() {
      initialPosition = LatLng(locationData.latitude!, locationData.longitude!);
    });

    location.enableBackgroundMode(enable: true);
    location.onLocationChanged.listen((LocationData currentLocation) {
      setState(() {
        initialPosition =
            LatLng(currentLocation.latitude!, currentLocation.longitude!);
      });
      // Print the updated coordinates to the terminal
      if (kDebugMode) {
        print(
            'Updated Location: Latitude: ${currentLocation.latitude}, Longitude: ${currentLocation.longitude}');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          initialPosition == null
              ? const Center(child: CircularProgressIndicator())
              : FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    initialCenter: initialPosition!,
                    initialZoom: 16,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          "https://api.mapbox.com/styles/v1/mapbox/$selectedStyle/tiles/{z}/{x}/{y}?access_token=$accessToken",
                      additionalOptions: {
                        'accessToken': accessToken,
                        'id': 'mapbox.$selectedStyle',
                      },
                    ),
                    MarkerLayer(
                      markers: initialPosition != null
                          ? [
                              Marker(
                                point: initialPosition!,
                                width: 100,
                                height: 100,
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    FadeTransition(
                                      opacity:
                                          Tween<double>(begin: 1.0, end: 0.0)
                                              .animate(_controller),
                                      child: ScaleTransition(
                                        scale: _animation,
                                        child: Container(
                                          width: 100,
                                          height: 100,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.redAccent
                                                .withOpacity(0.5),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const Icon(
                                      Icons.circle_rounded,
                                      color: Colors.red,
                                      size: 30,
                                    ),
                                  ],
                                ),
                              ),
                            ]
                          : [],
                    ),
                  ],
                ),
          Positioned(
            bottom: _fabBottomPosition,
            right: 20,
            child: Column(
              children: [
                FloatingActionButton(
                  backgroundColor: Colors.transparent,
                  shape: CircleBorder(
                    side: BorderSide(
                      color: Colors.redAccent.withOpacity(0.5),
                      width: 1,
                    ),
                  ),
                  onPressed: () {
                    _panelController.isPanelClosed
                        ? _panelController.open()
                        : _panelController.close();
                  },
                  child: const Icon(
                    Icons.map,
                    color: Colors.redAccent,
                  ),
                ),
                const SizedBox(height: 10),
                FloatingActionButton(
                  backgroundColor: Colors.white,
                  onPressed: () {
                    if (initialPosition != null) {
                      _mapController.move(initialPosition!, 16);
                    }
                  },
                  child: const Icon(
                    Icons.my_location,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
          ),
          SlidingUpPanel(
            controller: _panelController,
            minHeight: 0,
            maxHeight: 200,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            panel: _buildMapStyleSelector(),
            panelSnapping: false,
            isDraggable: true,
            onPanelSlide: (position) {
              setState(() {
                _fabBottomPosition = 120 + (100 * position);
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMapStyleSelector() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          const Text(
            "Map Styles",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: mapboxStyles.entries.map((style) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedStyle = style.value;
                    });
                    _panelController.close();
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: _getStyleColor(style.key),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: selectedStyle == style.value
                            ? Colors.blue
                            : Colors.transparent,
                        width: 2,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Color _getStyleColor(String styleKey) {
    switch (styleKey) {
      case 'Streets':
        return Colors.orange;
      case 'Outdoors':
        return Colors.green;
      case 'Light':
        return Colors.grey;
      case 'Dark':
        return Colors.black;
      case 'Satellite':
        return Colors.brown;
      case 'Satellite Streets':
        return Colors.purple;
      default:
        return Colors.blue;
    }
  }
}
