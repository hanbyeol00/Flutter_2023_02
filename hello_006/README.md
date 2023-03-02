# hello_006

- 로컬디스크 `C:\Program Files\Java\jdk-15.0.2\bin` 이동
- git bash, 또는 윈도우 cmd 창 열기
- ./keytool -genkey -keystore ~/key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias key

## 배포준비

- 프로젝트 ID 변경하기
  `flutter pub add change_app_package_name`
- package 이름 변경하기
  `flutter pub run change_app_package_name:main com.han.hello`

- android/key.properties 파일 생성

```
storePassword=123123
keyPassword=123123
keyAlias=key
storeFile=C:/Users/KS50517/key.jks
```

- 안드로이드 App build
  `flutter build apk --split-per-abi`
