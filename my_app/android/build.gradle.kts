// ✅ Dành cho Flutter Gradle Plugin kiểu mới (Kotlin DSL)
plugins {
    id("com.google.gms.google-services") apply false
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// ✅ Cấu hình thư mục build (chuẩn Flutter 3.24)
val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}

subprojects {
    project.evaluationDependsOn(":app")
}

// ✅ Task clean build
tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
