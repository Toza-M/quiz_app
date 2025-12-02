buildscript {
    ext.kotlin_version = '1.9.22' // Updated Kotlin version
    repositories {
        google()
        mavenCentral()
    }

    dependencies {
        classpath 'com.android.tools.build:gradle:7.4.2' // Updated Gradle plugin
        classpath "org.jetbrains.kotlin:kotlin-gradle-plugin:$kotlin_version"
        
        // 🔥 ADD THIS LINE: Firebase/Google services classpath
        classpath 'com.google.gms:google-services:4.4.0'
        
        // NOTE: In a new project, you might need to add this too:
        // classpath 'com.google.firebase:firebase-crashlytics-gradle:2.9.9'
    }
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

rootProject.buildDir = '../build'
subprojects {
    project.buildDir = "${rootProject.buildDir}/${project.name}"
}
subprojects {
    project.evaluationDependsOn(':app')
}

tasks.register("clean", Delete) {
    delete rootProject.buildDir
}