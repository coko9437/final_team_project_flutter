// lib/models/restaurant.dart
// 지도 화면에서 사용될 식당 정보 데이터 모델
/// 식당 정보 DTO
class Restaurant {
  final String name;
  final String address;
  final double latitude;
  final double longitude;
  final double rating;
  final String placeId;

  Restaurant({
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.rating,
    required this.placeId,
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) {
    return Restaurant(
      name: json['name'] as String,
      address: json['address'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      rating: (json['rating'] as num).toDouble(),
      placeId: json['placeId'] as String,
    );
  }
}