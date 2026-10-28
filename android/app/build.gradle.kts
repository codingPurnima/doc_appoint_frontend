import java.io.FileInputStream
import java.util.Properties
plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.doc_appoint_frontend"
    compileSdk = 37
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    val keyPropertiesFile = rootProject.file("android/key.properties")
    val useReleaseKeystore = keyPropertiesFile.exists()
    val keyProperties = Properties()

    if (useReleaseKeystore) {
        keyProperties.load(FileInputStream(keyPropertiesFile))
    }

    signingConfigs {
        if (useReleaseKeystore) {
            create("release") {
                keyAlias = keyProperties.getProperty("keyAlias") ?: ""
                keyPassword = keyProperties.getProperty("keyPassword") ?: ""
                storeFile = if (keyProperties.getProperty("storeFile") != null) {
                    file(keyProperties.getProperty("storeFile"))
                } else {
                    null
                }
                storePassword = keyProperties.getProperty("storePassword") ?: ""
            }
        }
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.example.doc_appoint_frontend"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            signingConfig = if (useReleaseKeystore) {
                signingConfigs.getByName("release")
            } else {
                signingConfigs.getByName("debug")
            }
            isMinifyEnabled = false
            isShrinkResources = false
            proguardFiles(getDefaultProguardFile("proguard-android-optimize.txt"), "proguard-rules.pro")
        }
    }
}

flutter {
    source = "../.."
}
