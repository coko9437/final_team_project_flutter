// lib/ui/screens/map/restaurant_map_screen.dart

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

// 핵심 로직 및 모델 Import
import '../../../core/services/map_service.dart';
import '../../../models/restaurant.dart';

class RestaurantMapScreen extends StatefulWidget {
  // 이전 화면(ResultScreen)으로부터 음식 이름을 전달받음
  final String foodName;

  const RestaurantMapScreen({
    super.key,
    required this.foodName,
  });

  @override
  State<RestaurantMapScreen> createState() => _RestaurantMapScreenState();
}

class _RestaurantMapScreenState extends State<RestaurantMapScreen> {
  final MapService _mapService = MapService();
  GoogleMapController? _mapController;

  // 상태 변수들
  bool _isLoading = true;
  String? _errorMessage;
  Position? _currentPosition;
  final Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _loadMapData();
  }

  /// 지도에 필요한 모든 데이터(현재 위치, 식당 정보)를 불러오는 메인 함수
  Future<void> _loadMapData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _markers.clear();
    });

    try {
      // 1. 현재 위치 가져오기 (MapService 사용)
      _currentPosition = await _mapService.getCurrentLocation();
      _addMarker(
        id: 'my_location',
        position: LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
        title: '내 위치',
        isMyLocation: true,
      );

      // 2. 주변 식당 검색 (MapService 사용)
      final restaurants = await _mapService.findNearbyRestaurants(
        foodName: widget.foodName,
        latitude: _currentPosition!.latitude,
        longitude: _currentPosition!.longitude,
      );

      if (restaurants.isEmpty && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('주변에서 "${widget.foodName}" 식당을 찾지 못했습니다.')),
        );
      }

      // 3. 식당 위치를 마커로 추가
      for (final restaurant in restaurants) {
        _addMarker(
          id: restaurant.placeId,
          position: LatLng(restaurant.latitude, restaurant.longitude),
          title: restaurant.name,
          snippet: restaurant.address,
        );
      }

      // 4. 로딩 완료 후, 카메라를 현재 위치로 이동
      _moveCameraToCurrentLocation();

    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  /// 지도에 마커를 추가하는 헬퍼 함수
  void _addMarker({
    required String id,
    required LatLng position,
    required String title,
    String? snippet,
    bool isMyLocation = false,
  }) {
    _markers.add(
      Marker(
        markerId: MarkerId(id),
        position: position,
        infoWindow: InfoWindow(title: title, snippet: snippet),
        icon: isMyLocation
            ? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure)
            : BitmapDescriptor.defaultMarker,
      ),
    );
  }

  /// 지도 카메라를 현재 위치로 부드럽게 이동
  void _moveCameraToCurrentLocation() {
    if (_currentPosition != null && _mapController != null) {
      _mapController!.animateCamera(
        CameraUpdate.newLatLngZoom(
          LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
          14.0, // 줌 레벨 (14~15가 적당)
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('"${widget.foodName}" 주변 식당'),
        actions: [
          // 새로고침 버튼
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _isLoading ? null : _loadMapData,
          ),
        ],
      ),
      body: Stack(
        children: [
          // 구글 지도
          GoogleMap(
            onMapCreated: (controller) {
              _mapController = controller;
              // 지도가 생성된 직후에 카메라 이동
              _moveCameraToCurrentLocation();
            },
            initialCameraPosition: CameraPosition(
              // 초기 위치는 서울 시청, 데이터 로드 후 현재 위치로 이동됨
              target: const LatLng(37.5665, 126.9780),
              zoom: 14.0,
            ),
            markers: _markers,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
          ),

          // 로딩 중 오버레이
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: Colors.white),
                    SizedBox(height: 16),
                    Text(
                      '주변 식당을 찾고 있습니다...',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),

          // 에러 발생 시 오버레이
          if (_errorMessage != null)
            Container(
              color: Colors.white.withOpacity(0.9),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline, color: Colors.red, size: 50),
                      const SizedBox(height: 16),
                      Text(
                        '오류 발생',
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _errorMessage!,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _loadMapData,
                        child: const Text('다시 시도'),
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