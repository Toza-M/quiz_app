def localProperties = new Properties()
def localPropertiesFile = rootProject.file('local.properties')
if (localPropertiesFile.exists()) {
    localPropertiesFile.withReader('UTF-8') { reader ->
        localProperties.load(reader)
    }
}

def flutterRoot = localProperties.getProperty('flutter.sdk')
if (flutterRoot == null) {
    throw new GradleException("Flutter SDK not found. Define location with flutter.sdk in the local.properties file.")
}

def flutterVersionCode = localProperties.getProperty('flutter.versionCode')
if (flutterVersionCode == null) {
    flutterVersionCode = '1'
}

def flutterVersionName = localProperties.getProperty('flutter.versionName')
if (flutterVersionName == null) {
    flutterVersionName = '1.0'
}

apply plugin: 'com.android.application'
apply plugin: 'kotlin-android'
apply from: "$flutterRoot/packages/flutter_tools/gradle/flutter.gradle"

android {
    // ⚠️ CHECK THIS: Your namespace/package name MUST match Firebase registration
    namespace "com.example.quiz_app"  // Change this to YOUR package name
    
    // If you don't have namespace, use this instead:
    // compileSdkVersion flutter.compileSdkVersion
    compileSdk 34  // Use 34 for latest Android
    
    compileOptions {
        sourceCompatibility JavaVersion.VERSION_1_8
        targetCompatibility JavaVersion.VERSION_1_8
    }

    kotlinOptions {
        jvmTarget = '1.8'
    }

    sourceSets {
        main.java.srcDirs += 'src/main/kotlin'
    }

    defaultConfig {
        // ⚠️ IMPORTANT: This MUST match exactly with Firebase Console package name!
        applicationId "com.example.quiz_app"  // Change to YOUR package name
        
        // You can find these in local.properties or use flutter defaults
        minSdkVersion flutter.minSdkVersion
        targetSdkVersion flutter.targetSdkVersion
        
        versionCode flutterVersionCode.toInteger()
        versionName flutterVersionName
        
        // For multidex support (if you have many Firebase dependencies)
        multiDexEnabled true
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig signingConfigs.debug
            
            // Minify and shrink resources for release
            minifyEnabled true
            shrinkResources true
            proguardFiles getDefaultProguardFile('proguard-android.txt'), 'proguard-rules.pro'
        }
        
        debug {
            // Enable debugging for debug builds
            debuggable true
            signingConfig signingConfigs.debug
        }
    }
    
    // Enable view binding if needed
    buildFeatures {
        viewBinding true
    }
}

flutter {
    source '../..'
}

dependencies {
    implementation "org.jetbrains.kotlin:kotlin-stdlib-jdk7:$kotlin_version"
    
    // 🔥 Firebase/Android dependencies
    implementation 'androidx.multidex:multidex:2.0.1'  // For multidex support
    
    // Platform required for Firebase
    implementation platform('com.google.firebase:firebase-bom:32.7.0')
    
    // Optional: Add these if you need specific Firebase services later
    // implementation 'com.google.firebase:firebase-analytics'
    // implementation 'com.google.firebase:firebase-crashlytics'
}

// 🔥 ADD THIS LINE AT THE VERY BOTTOM OF THE FILE
apply plugin: 'com.google.gms.google-services'