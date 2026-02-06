import java.util.Properties
import java.io.File
import java.io.FileInputStream

plugins {
    id("com.android.application")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}
val keystoreKeyAlias = keystoreProperties.getProperty("keyAlias")
val keystoreKeyPassword = keystoreProperties.getProperty("keyPassword")
val keystoreStoreFilePath = keystoreProperties.getProperty("storeFile")
val keystoreStorePassword = keystoreProperties.getProperty("storePassword")
val keystoreStoreFile: File? = keystoreStoreFilePath?.let { path ->
    val file = File(path)
    if (file.isAbsolute) file else rootProject.file("app/$path")
}
val isSigningConfigured = listOf(
    keystoreKeyAlias,
    keystoreKeyPassword,
    keystoreStorePassword
).all { !it.isNullOrBlank() } && keystoreStoreFile?.exists() == true

android {
    namespace = "com.ismaeldev.ngonipay"
    compileSdk = 36
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
        // Enable core library desugaring for flutter_local_notifications
        isCoreLibraryDesugaringEnabled = true
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.ismaeldev.ngonipay"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = 36
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        if (isSigningConfigured) {
            create("release") {
                keyAlias = keystoreKeyAlias
                keyPassword = keystoreKeyPassword
                storeFile = keystoreStoreFile
                storePassword = keystoreStorePassword
                storeType = "JKS"
            }
        }
    }

    buildTypes {
        release {
            if (isSigningConfigured) {
                signingConfig = signingConfigs.getByName("release")
            }
        }
    }
}

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.0.4")
}

flutter {
    source = "../.."
}
