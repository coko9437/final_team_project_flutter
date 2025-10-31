# 🍽️ 칼로리 트래커 앱 (Flutter)

안드로이드 칼로리 트래킹 앱입니다.

## 📁 프로젝트 구조

```
calorie_tracker/
├── lib/
│   ├── main.dart                 # 앱 진입점
│   ├── screens/
│   │   ├── home_page.dart        # 홈 화면
│   │   ├── capture_page.dart     # 사진 촬영 화면
│   │   └── result_page.dart      # 결과 화면
│   └── widgets/
│       └── bottom_nav.dart       # 하단 네비게이션 바
├── pubspec.yaml                   # 프로젝트 설정 파일
└── README.md
```

## 🚀 시작하기

### 1. Flutter 설치 확인
```bash
flutter --version
```

Flutter가 설치되어 있지 않다면 [Flutter 공식 사이트](https://flutter.dev/docs/get-started/install)에서 설치하세요.

### 2. 프로젝트 생성
```bash
flutter create calorie_tracker
cd calorie_tracker
```

### 3. 파일 구조 생성
```bash
# screens 폴더 생성
mkdir lib/screens

# widgets 폴더 생성
mkdir lib/widgets
```

### 4. 파일 복사
다음 파일들을 해당 위치에 복사하세요:

- `lib/main.dart`
- `lib/screens/home_page.dart`
- `lib/screens/capture_page.dart`
- `lib/screens/result_page.dart`
- `lib/widgets/bottom_nav.dart`
- `pubspec.yaml`

### 5. 의존성 설치
```bash
flutter pub get
```

### 6. 앱 실행
```bash
# 안드로이드 에뮬레이터나 실제 기기에서 실행
flutter run
```

## 📱 주요 기능

### 홈 화면 (home_page.dart)
- ✅ 귀여운 펭귄 캐릭터 (CustomPainter로 그림)
- ✅ 칼로리 카운터 (0 / 1500)
- ✅ 소모 칼로리 표시
- ✅ 카메라 FAB 버튼

### 촬영 화면 (capture_page.dart)
- ✅ 카메라 프리뷰 (그라데이션 배경)
- ✅ 스캔 애니메이션 효과
- ✅ 사진 촬영/갤러리 선택 버튼
- ✅ 로딩 오버레이

### 결과 화면 (result_page.dart)
- ✅ 음식 이미지 표시
- ✅ 칼로리 및 영양 정보
- ✅ 건강도 점수 (7/10)
- ✅ 비슷한 음식 추천
- ✅ 확인 배너

### 하단 네비게이션 (bottom_nav.dart)
- ✅ 5개 탭 (홈, 단식, 캘츠코치, 체중, 웰니스)
- ✅ 활성/비활성 상태 표시
- ✅ 캘츠코치 뱃지 표시

## 🎨 디자인 특징

- Material Design 3 사용
- 커스텀 그라데이션 배경
- 부드러운 애니메이션 효과
- 반응형 레이아웃

## 🔧 커스터마이징

### 색상 변경
`lib/main.dart`의 `ThemeData`에서 색상을 변경할 수 있습니다:

```dart
theme: ThemeData(
  colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
  useMaterial3: true,
),
```

### 칼로리 목표 변경
`lib/screens/home_page.dart`에서 목표 칼로리를 변경할 수 있습니다:

```dart
TextSpan(
  text: ' / 1500',  // 여기서 변경
  style: TextStyle(color: Colors.grey[300]),
),
```

## 📦 추가 기능 구현 가이드

### 카메라 기능 추가
```yaml
# pubspec.yaml에 추가
dependencies:
  camera: ^0.10.0
  image_picker: ^1.0.0
```

### 데이터 저장
```yaml
# pubspec.yaml에 추가
dependencies:
  shared_preferences: ^2.2.0
  hive: ^2.2.0
```

### 서버 연동
```yaml
# pubspec.yaml에 추가
dependencies:
  http: ^1.0.0
  dio: ^5.0.0
```

## 🔨 빌드

### 안드로이드 APK 빌드
```bash
flutter build apk --release
```

APK 파일 위치: `build/app/outputs/flutter-apk/app-release.apk`

### 안드로이드 App Bundle 빌드 (Google Play 배포용)
```bash
flutter build appbundle --release
```

## 📱 테스트

```bash
# 위젯 테스트
flutter test

# 통합 테스트
flutter drive --target=test_driver/app.dart
```

## 🐛 문제 해결

### 의존성 문제
```bash
flutter clean
flutter pub get
```

### 캐시 문제
```bash
flutter pub cache repair
```

### 안드로이드 빌드 오류
```bash
cd android
./gradlew clean
cd ..
flutter build apk
```

## 📄 라이선스

MIT License

## 👨‍💻 개발자

Flutter 3.0+ 기반으로 개발되었습니다.

---

**참고**: 실제 음식 인식 기능을 구현하려면 TensorFlow Lite나 ML Kit를 사용하여 머신러닝 모델을 통합해야 합니다.