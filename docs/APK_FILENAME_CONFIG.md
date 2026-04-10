# 📦 APK 文件名配置说明

## ✅ 已完成的配置

### 1. 自定义 APK 文件名

已在 `app/build.gradle` 中配置自动生成文件名格式：

```gradle
applicationVariants.all { variant ->
    variant.outputs.all {
        def version = variant.versionName
        outputFileName = "wireless-adb-${version}.apk"
    }
}
```

### 2. 生成的文件名

#### Debug 版本
```
wireless-adb-1.3.apk
```
位置：`app/build/outputs/apk/debug/wireless-adb-1.3.apk`

#### Release 版本
```
wireless-adb-1.3.apk
```
位置：`app/build/outputs/apk/release/wireless-adb-1.3.apk`

---

## 🚀 GitHub Actions 自动构建

已创建 `.github/workflows/build.yml`，配置如下：

### 触发条件
- ✅ Push 到 main/master 分支
- ✅ Pull Request

### 构建任务
1. **设置 JDK 17**
2. **配置 Gradle**
3. **构建 Debug APK**
4. **构建 Release APK**

### 上传的 Artifact

| Artifact 名称 | 文件路径 | 保留时间 |
|--------------|----------|----------|
| `wireless-adb-debug` | `app/build/outputs/apk/debug/wireless-adb-*.apk` | 30 天 |
| `wireless-adb-release` | `app/build/outputs/apk/release/wireless-adb-*.apk` | 30 天 |

---

## 📊 文件名示例

### 当前版本（1.3）
```
wireless-adb-1.3.apk
```

### 未来版本
```
wireless-adb-1.4.apk
wireless-adb-2.0.apk
wireless-adb-2.0.1.apk
```

---

## 🔧 修改版本号

要修改生成的 APK 文件名，只需更新版本号：

**在 `app/build.gradle` 中**：
```gradle
defaultConfig {
    versionCode 5              // 版本号（整数，递增）
    versionName "1.4"          // 版本名称（会出现在文件名中）
}
```

**修改后重新构建**：
```bash
./gradlew assembleDebug
```

**生成的新文件名**：
```
wireless-adb-1.4.apk
```

---

## 📁 目录结构

```
app/build/outputs/apk/
├── debug/
│   └── wireless-adb-1.3.apk          ← Debug 版本
└── release/
    └── wireless-adb-1.3.apk          ← Release 版本
```

---

## 🎯 使用 GitHub Actions

### 1. Push 到 GitHub

```bash
git add .
git commit -m "配置 APK 文件名格式"
git push origin main
```

### 2. 查看构建进度

访问：`https://github.com/用户名/wireless-adb-switch/actions`

### 3. 下载 APK

1. 点击最近的构建
2. 在 "Artifacts" 部分下载
   - `wireless-adb-debug` (Debug 版本)
   - `wireless-adb-release` (Release 版本)

### 4. 解压

下载的 ZIP 文件解压后得到：
```
wireless-adb-1.3.apk
```

---

## 💡 高级配置

### 包含构建类型在文件名中

如果想要区分 debug/release，可以修改配置：

```gradle
applicationVariants.all { variant ->
    variant.outputs.all {
        def version = variant.versionName
        def buildType = variant.buildType.name
        outputFileName = "wireless-adb-${version}-${buildType}.apk"
    }
}
```

**生成的文件名**：
```
wireless-adb-1.3-debug.apk
wireless-adb-1.3-release.apk
```

### 包含 ABI（如果需要）

```gradle
applicationVariants.all { variant ->
    variant.outputs.all {
        def version = variant.versionName
        def abi = variant.getFilter(com.android.build.api.variant.FilterConfiguration.FilterType.ABI)?.identifier
        if (abi) {
            outputFileName = "wireless-adb-${version}-${abi}.apk"
        } else {
            outputFileName = "wireless-adb-${version}.apk"
        }
    }
}
```

---

## ✅ 总结

- ✅ **文件名格式**: `wireless-adb-${version}.apk`
- ✅ **版本号位置**: `app/build.gradle` → `versionName`
- ✅ **GitHub Actions**: 自动构建并上传
- ✅ **Artifact 名称**: `wireless-adb-debug` / `wireless-adb-release`

**配置完成！** 🎉
