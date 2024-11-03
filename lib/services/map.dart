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
    'Nabigation Night': 'navigation-night-v1',
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
              ? const Center(
                  child: CircularProgressIndicator(
                  color: Colors.redAccent,
                ))
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
                  elevation: 12,
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
                  backgroundColor: Colors.transparent,
                  elevation: 12,
                  shape: CircleBorder(
                    side: BorderSide(
                      color: Colors.redAccent.withOpacity(0.5),
                      width: 1,
                    ),
                  ),
                  onPressed: () {
                    if (initialPosition != null) {
                      _mapController.move(initialPosition!, 16);
                    }
                  },
                  child: const Icon(
                    Icons.my_location,
                    color: Colors.redAccent,
                  ),
                ),
                // const SizedBox(height: 10),
                // FloatingActionButton(
                //   backgroundColor: Colors.transparent,
                //   elevation: 12,
                //   shape: CircleBorder(
                //     side: BorderSide(
                //       color: Colors.redAccent.withOpacity(0.5),
                //       width: 1,
                //     ),
                //   ),
                //   onPressed: () {
                //     Navigator.push(
                //       context,
                //       MaterialPageRoute(
                //           builder: (context) => const MapviewNavigation()),
                //     );
                //   },
                //   child: const Icon(
                //     Icons.navigation_outlined,
                //     color: Colors.redAccent,
                //   ),
                // ),
              ],
            ),
          ),
          SlidingUpPanel(
            controller: _panelController,
            minHeight: 0,
            maxHeight: 200,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            panel: _buildMapStyleSelector(),
            color: Theme.of(context).brightness == Brightness.light
                ? const Color.fromARGB(255, 225, 225, 225)
                : const Color.fromARGB(255, 15, 15, 15),
            panelSnapping: true,
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

  // Add this method to get the appropriate image path for each style
  String _getStyleImage(String styleKey) {
    switch (styleKey) {
      case 'Streets':
        return 'assets/images/mapstyle/Mapbox-streets.png';
      case 'Outdoors':
        return 'assets/images/mapstyle/Mapbox-outdoors.png';
      case 'Light':
        return 'assets/images/mapstyle/Mapbox-Light.png';
      case 'Dark':
        return 'assets/images/mapstyle/Mapbox-dark.png';
      case 'Satellite':
        return 'assets/images/mapstyle/Mapbox-Satellite.png';
      case 'Satellite Streets':
        return 'assets/images/mapstyle/Mapbox-Satellite.png';
      default:
        return 'assets/images/mapstyle/Mapbox-streets.png'; // fallback image
    }
  }

// In your build method, update the SingleChildScrollView content
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
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: selectedStyle == style.value
                            ? Colors.redAccent
                            : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                        _getStyleImage(style.key),
                        fit: BoxFit.cover,
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
}
