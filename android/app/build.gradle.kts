// 言語はKotlinで記述
// flutterアプリのaabファイルを生成するためのファイル

import java.util.Properties

plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.gm_reviews_search_doctor_app"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    // Androidのバージョンを指定
    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    // Kotlinのバージョンを指定
    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        // アプリケーションIDを指定
        applicationId = "com.nyanyacyan.gmreviews"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    // リリースビルド用の署名設定
    signingConfigs {
        create("release") {
            // リリースビルド用の署名設定
            // debugビルド用の署名設定は、デフォルトで設定されているため、特に指定する必要はない
            // .applyは、Kotlinの拡張関数で、オブジェクトを初期化するために使用される
            // 署名設定を取得するためのプロパティファイルを読み込む
            val keystoreProperties = Properties().apply {
                load(rootProject.file("key.properties").inputStream())
            }

            // keystorePropertiesの値を取得
            storeFile = rootProject.file(keystoreProperties["storeFile"] as String) // keyBoxのイメージ
            storePassword = keystoreProperties["storePassword"] as String
            keyAlias = keystoreProperties["keyAlias"] as String  // keyBoxの中にある鍵の名称（ラベル）
            keyPassword = keystoreProperties["keyPassword"] as String
        }
    }

    buildTypes {
        release {
            // リリースモード
            signingConfig = signingConfigs.getByName("release")

            // debugモード
            // signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}
