// lib/screens/nutrition_page.dart
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../core/config/api_config.dart';
import '../util/auth_helper.dart';

class NutritionPage extends StatefulWidget {
  const NutritionPage({super.key});

  @override
  State<NutritionPage> createState() => _NutritionPageState();
}

class _NutritionPageState extends State<NutritionPage> {
  final TextEditingController _searchController = TextEditingController();
  List<dynamic> _foodList = [];
  bool _isLoading = false;
  String? _errorMessage;
  String? _selectedFoodName;
  Map<String, dynamic>? _selectedNutrition;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // DB에서 음식 목록 가져오기
  Future<void> _loadFoodList() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final dio = Dio(BaseOptions(
        baseUrl: ApiConfig.baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: ApiConfig.ngrokHeaders,
      ));

      // 백엔드 API: GET /api/admin/food-references
      final response = await dio.get('/api/admin/food-references');

      if (response.statusCode == 200 && response.data != null) {
        setState(() {
          _foodList = response.data is List ? response.data : [];
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = '음식 목록을 불러올 수 없습니다.';
          _isLoading = false;
        });
      }
    } catch (e) {
      print('❌ 음식 목록 로드 실패: $e');
      setState(() {
        _errorMessage = '음식 목록을 불러오는 중 오류가 발생했습니다.';
        _isLoading = false;
      });
    }
  }

  // 음식 검색
  Future<void> _searchFood(String query) async {
    if (query.trim().isEmpty) {
      _loadFoodList();
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final dio = Dio(BaseOptions(
        baseUrl: ApiConfig.baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: ApiConfig.ngrokHeaders,
      ));

      // 백엔드 검색: 클라이언트 측에서 필터링
      final response = await dio.get('/api/admin/food-references');

      if (response.statusCode == 200 && response.data != null) {
        final allFoods = response.data is List ? response.data : [];
        // 클라이언트 측에서 검색어로 필터링
        final filtered = allFoods.where((food) {
          final name = (food['foodName'] ?? food['name'] ?? '').toString().toLowerCase();
          return name.contains(query.toLowerCase());
        }).toList();

        // 검색 결과가 있으면 첫 번째 결과를 선택된 음식으로 설정
        if (filtered.isNotEmpty) {
          final firstFood = filtered.first;
          final nutrition = firstFood['nutritionData'] ?? firstFood['nutritionInfo'] ?? firstFood['nutrition'] ?? {};

          setState(() {
            _foodList = filtered;
            _selectedFoodName = firstFood['foodName'] ?? firstFood['name'] ?? query;
            _selectedNutrition = nutrition;
            _isLoading = false;
            _errorMessage = null;
          });
        } else {
          setState(() {
            _foodList = [];
            _selectedFoodName = null;
            _selectedNutrition = null;
            _isLoading = false;
            _errorMessage = '검색 결과가 없습니다.';
          });
        }
      } else {
        setState(() {
          _errorMessage = '검색 결과를 찾을 수 없습니다.';
          _isLoading = false;
        });
      }
    } catch (e) {
      print('❌ 음식 검색 실패: $e');
      setState(() {
        _errorMessage = '검색 중 오류가 발생했습니다.';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // 화면 높이를 가져와 검색 결과 목록의 높이를 제한하는 데 사용
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text('영양소 정보'),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      // 🚨 [수정] 최상위 Column을 SingleChildScrollView로 감싸서 오버플로우 방지
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min, // 🚨 [추가] Column의 크기를 최소화
          children: [
            // 검색 바
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: '음식 이름을 검색하세요 (예: 양념치킨)',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _searchController.clear();
                      setState(() {
                        _foodList = [];
                        _selectedFoodName = null;
                        _selectedNutrition = null;
                        _errorMessage = null;
                      });
                    },
                  )
                      : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.grey[100],
                ),
                onSubmitted: (value) {
                  if (value.trim().isNotEmpty) {
                    _searchFood(value);
                  } else {
                    setState(() {
                      _foodList = [];
                      _selectedFoodName = null;
                      _selectedNutrition = null;
                      _errorMessage = null;
                    });
                  }
                },
                onChanged: (value) {
                  setState(() {});
                },
              ),
            ),
            // 영양소 정보 표시 영역
            // 🚨 [수정] Expanded 제거
            _isLoading
                ? const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 50.0),
                child: CircularProgressIndicator(),
              ),
            )
                : _errorMessage != null
                ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 48, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    _errorMessage!,
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
            )
                : Column(
              mainAxisSize: MainAxisSize.min, // 🚨 [추가] Column의 크기를 최소화
              children: [
                // 영양소 정보 카드 (항상 표시)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: _NutritionInfoCard(
                    foodName: _selectedFoodName,
                    nutrition: _selectedNutrition,
                  ),
                ),
                // 검색 결과 목록 (1개 이상일 때 표시)
                if (_foodList.length > 0) // 🚨 [수정] 0개 초과로 변경
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                        child: Text(
                          '검색 결과 (${_foodList.length}개)',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      // 🚨 [수정] Expanded를 제거하고 SizedBox로 높이를 제한
                      SizedBox(
                        height: screenHeight * 0.4, // 화면 높이의 40%로 제한
                        child: ListView.builder(
                          shrinkWrap: true, // 🚨 [추가]
                          physics: const AlwaysScrollableScrollPhysics(), // 🚨 [추가]
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: _foodList.length,
                          itemBuilder: (context, index) {
                            final food = _foodList[index];
                            return _FoodListItem(
                              food: food,
                              onTap: () {
                                // 리스트 아이템 클릭 시 해당 음식 정보 표시
                                final nutrition = food['nutritionData'] ?? food['nutritionInfo'] ?? food['nutrition'] ?? {};
                                setState(() {
                                  _selectedFoodName = food['foodName'] ?? food['name'] ?? '알 수 없음';
                                  _selectedNutrition = nutrition;
                                });
                              },
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 20), // 하단 여백 추가
                    ],
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// 영양소 정보 카드 위젯 (메인 표시 - 항상 표시됨)
class _NutritionInfoCard extends StatelessWidget {
  final String? foodName;
  final Map<String, dynamic>? nutrition;

  const _NutritionInfoCard({
    required this.foodName,
    required this.nutrition,
  });

  @override
  Widget build(BuildContext context) {
    final calories = nutrition?['calories'] ?? 0;
    final protein = nutrition?['protein'] ?? 0;
    final fat = nutrition?['fat'] ?? 0;
    final carbohydrate = nutrition?['carbohydrates'] ?? nutrition?['carbohydrate'] ?? 0;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        padding: const EdgeInsets.all(32.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.blue[50]!,
              Colors.white,
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 음식 이름
            Text(
              foodName ?? '음식 이름',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: foodName != null ? Colors.black : Colors.grey[400],
              ),
            ),
            if (foodName == null)
              const SizedBox(height: 12),
            if (foodName == null)
              Text(
                '검색창에 음식 이름을 입력하세요',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
            const SizedBox(height: 32),
            // 영양소 정보 그리드 (2x2 대각선 4등분)
            SizedBox(
              height: 300,
              child: Column(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: _NutritionItem(
                            label: '칼로리',
                            value: calories > 0 ? '${calories.toStringAsFixed(0)}kcal' : '-',
                            icon: Icons.local_fire_department,
                            color: Colors.orange,
                          ),
                        ),
                        Container(
                          width: 1,
                          color: Colors.grey[300],
                        ),
                        Expanded(
                          child: _NutritionItem(
                            label: '탄수화물',
                            value: carbohydrate > 0 ? '${carbohydrate.toStringAsFixed(1)}g' : '-',
                            icon: Icons.eco,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 1,
                    color: Colors.grey[300],
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: _NutritionItem(
                            label: '단백질',
                            value: protein > 0 ? '${protein.toStringAsFixed(1)}g' : '-',
                            icon: Icons.fitness_center,
                            color: Colors.blue,
                          ),
                        ),
                        Container(
                          width: 1,
                          color: Colors.grey[300],
                        ),
                        Expanded(
                          child: _NutritionItem(
                            label: '지방',
                            value: fat > 0 ? '${fat.toStringAsFixed(1)}g' : '-',
                            icon: Icons.water_drop,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// 검색 결과 리스트 아이템 (간단한 형태)
class _FoodListItem extends StatelessWidget {
  final dynamic food;
  final VoidCallback onTap;

  const _FoodListItem({
    required this.food,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final foodName = food['foodName'] ?? food['name'] ?? '알 수 없음';

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        title: Text(
          foodName,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}

// 영양소 아이템 위젯
class _NutritionItem extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _NutritionItem({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 40),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}