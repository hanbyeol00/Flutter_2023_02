# flutter_040_naver_api

- naver OpenApi 를 사용하여 영화 검색 App 만들기
- `/lib/config/naver_api.dart` 파일에 NaverAPI 의 접속 정보를 설정
- `.gitignore` 파일에 `naver_api.*` 를 등록하여 `github` 에 업로드 금지 설정

## flutter 에서 외부 서버에 접속하기 위하여

- dependencies 설정

```
flutter pub add http
flutter pub add flutter_html
```

## naver API 에서 요구하는 안드로이드 패키지 설정

- `flutter pub add change_app_package_name`
- `flutter pub run change_app_package_name:main com.han.naver`
