## Environment

| Component         | Version / Requirement   |
| ----------------- | ----------------------- |
| Android Studio    | Dolphin / Electric Eel+ |
| JDK               | 17 or 21                |
| Gradle            | 8.13 (wrapper)          |
| Kotlin            | 2.0.21                  |
| Emulator / Device | Android 12+ recommended |

---

## Quick Start

1. Clone repo:

```bash
git clone <repo-url>
```

2. Open in Android Studio and sync Gradle.
3. Build & run on emulator or device.

## FAQ / Troubleshooting
**Q: Gradle download times out or fails**

A:
1. Run in project root:

```bash
./gradlew --version
```

This downloads Gradle 8.13 automatically.

2. Or use a mirror in `gradle/wrapper/gradle-wrapper.properties`:

```properties
distributionUrl=https\://mirrors.tuna.tsinghua.edu.cn/gradle/gradle-8.13-bin.zip
```

3. Or manually download & unzip into:

```
~/.gradle/wrapper/dists/gradle-8.13-bin/<hash>/gradle-8.13/
```



