pluginManagement {
    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
    }
}

val flutterSdkPath = run {
    val properties = java.util.Properties()
    val localPropertiesFile = file("android/local.properties") // android dizinini açıkça belirt
    if (!localPropertiesFile.exists()) {
        error("local.properties file not found in android directory. Please create it with flutter.sdk and sdk.dir properties.")
    }
    localPropertiesFile.inputStream().use { properties.load(it) }
    val flutterSdkPath = properties.getProperty("flutter.sdk")
    require(flutterSdkPath != null) { "flutter.sdk not set in local.properties" }
    flutterSdkPath
}

includeBuild("$flutterSdkPath/packages/flutter_tools/gradle")
include(":app")
apply(from: "$flutterSdkPath/packages/flutter_tools/gradle/app_plugin_loader.gradle")