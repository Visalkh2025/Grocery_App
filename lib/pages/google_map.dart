import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:grocery_app/constants/constant.dart';
import 'package:grocery_app/widget/pin_clipper.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:geocoding/geocoding.dart';

class GoogleMap extends StatefulWidget {
  const GoogleMap({super.key});

  @override
  State<GoogleMap> createState() => _GoogleMapState();
}

class _GoogleMapState extends State<GoogleMap> {
  final LatLng shopLocation = const LatLng(11.5465, 104.9403);
  LatLng? myLocation;
  String? shopAddress;
  final MapController _mapController = MapController();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeMap();
  }

  Future<void> _initializeMap() async {
    _getShopAddress();
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _showError("Location services are disabled. Please enable GPS.");
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        _showError("Location permissions are denied.");
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      _showError("Location permissions are permanently denied.");
      return;
    }

    Position pos = await Geolocator.getCurrentPosition();
    if (mounted) {
      setState(() {
        myLocation = LatLng(pos.latitude, pos.longitude);
        isLoading = false;
      });
    }
  }

  Future<void> _getShopAddress() async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        shopLocation.latitude,
        shopLocation.longitude,
      );
      if (placemarks.isNotEmpty) {
        final placemark = placemarks.first;
        setState(() {
          shopAddress = "${placemark.street}, ${placemark.locality}, ${placemark.country}";
        });
      } else {
        _showError("No address found for the given coordinates.");
      }
    } catch (e) {
      log(e.toString());
      _showError(
        "Could not get shop address. Please check your internet connection and try again.",
      );
    }
  }

  Future<void> _launchGoogleMaps() async {
    final url = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=${shopLocation.latitude},${shopLocation.longitude}',
    );
    try {
      if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
        _showError("Could not launch map app");
      }
    } catch (e) {
      _showError("Error opening map: $e");
    }
  }

  void _showError(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _buildMap(),
          _buildFloatingActionButtons(),
          _buildInfoCard(),
          _buildBackButton(),
          if (isLoading) _buildLoadingIndicator(),
        ],
      ),
    );
  }

  Widget _buildMap() {
    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(initialCenter: myLocation ?? shopLocation, initialZoom: 15.0),
      children: [
        TileLayer(
          urlTemplate: 'https://{s}.basemaps.cartocdn.com/rastertiles/voyager/{z}/{x}/{y}.png',
          subdomains: const ['a', 'b', 'c', 'd'],
          userAgentPackageName: 'com.example.grocery_app',
        ),
        MarkerLayer(
          markers: [
            Marker(
              point: shopLocation,
              width: 40,
              height: 40,
              // child: const Icon(Icons.location_pin, color: Colors.red, size: 40),
              child: shopPinMarker(),
            ),
            if (myLocation != null)
              Marker(point: myLocation!, width: 25, height: 25, child: userPinMarker()),
          ],
        ),
      ],
    );
  }

  Widget userPinMarker() {
    return Container(
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.blue, // user color
        boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2))],
      ),
      child: const Center(
        child: Icon(
          Icons.person, // optional: custom icon
          color: Colors.white,
          size: 16,
        ),
      ),
    );
  }

  Widget shopPinMarker() {
    return Container(
      decoration: const BoxDecoration(
        boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(0, 4))],
      ),
      child: ClipPath(
        clipper: PinClipper(),
        child: Container(
          width: 50,
          height: 50,
          color: Constant.primaryColor,
          padding: const EdgeInsets.all(2),
          child: ClipPath(
            clipper: PinClipper(),
            child: Image.asset('assets/images/logo/grocery.png', fit: BoxFit.cover),
          ),
        ),
      ),
    );
  }

  Widget _buildFloatingActionButtons() {
    return Positioned(
      bottom: 230,
      right: 20,
      child: Column(
        children: [
          FloatingActionButton(
            heroTag: "zoomIn",
            mini: true,
            backgroundColor: Colors.white,
            child: const Icon(Icons.add, color: Colors.black),
            onPressed: () {
              final zoom = _mapController.camera.zoom;
              _mapController.move(_mapController.camera.center, zoom + 1);
            },
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            heroTag: "zoomOut",
            mini: true,
            backgroundColor: Colors.white,
            child: const Icon(Icons.remove, color: Colors.black),
            onPressed: () {
              final zoom = _mapController.camera.zoom;
              _mapController.move(_mapController.camera.center, zoom - 1);
            },
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            heroTag: "recenter",
            backgroundColor: Constant.primaryColor,
            child: const Icon(Icons.my_location, color: Colors.white),
            onPressed: () {
              if (myLocation != null) {
                _mapController.move(myLocation!, 15.0);
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard() {
    return Positioned(
      bottom: 30,
      left: 20,
      right: 20,
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Constant.primaryColor,
                    child: Icon(Icons.store, color: Colors.white),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    "Grocery Store",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              if (shopAddress != null)
                Text(shopAddress!, style: const TextStyle(fontSize: 14, color: Colors.grey))
              else
                const Text(
                  'Loading address...',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Constant.primaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: _launchGoogleMaps,
                  child: const Text(
                    "Start Navigation",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBackButton() {
    return Positioned(
      top: 40,
      left: 20,
      child: FloatingActionButton(
        mini: true,
        backgroundColor: Colors.white,
        child: const Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () => Navigator.pop(context),
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Container(
      color: Colors.white,
      child: const Center(child: CircularProgressIndicator()),
    );
  }
}
