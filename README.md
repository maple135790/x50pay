# X50Pay

![Flutter Badge][Flutter badge]
![Dart badge][Dart badge]
[![GitHub issues by-label][Issue badge]](https://github.com/maple135790/x50pay/issues)

![image](https://pay.x50.fun/static/50paylogo.png)

NEXT Generation of MUGPay

- [X50Pay](#x50pay)
  - [Features](#features)
  - [Roadmap](#roadmap)
  - [Installation](#installation)
    - [Debug mode](#debug-mode)
    - [Release mode](#release-mode)
  - [FAQ](#faq)
  - [Authors](#authors)
  - [Contributors](#contributors)
  - [Contributing](#contributing)

## Features

- 支援雙平台 (iOS 及 Android)
- 更流暢的體驗

## Roadmap

- 增加 ScanPay 流程
- 增加 NFCPay 流程
- 增加 排隊等候 App 內推播通知
- 新增更多說明文件

## Installation

本專案使用 `Flutter ^3.10` 版本建構。請先[下載][Flutter SDK]合適的 SDK 版本。

Flutter SDK 的安裝流程請參考[這裡][Flutter installation]。

將本專案 `git clone` 到本機後，於專案的根目錄下執行

```
flutter pub get
```

### Debug mode

建構本機除錯版本，依平台使用以下其一指令

```
# For iOS
flutter run ios --no-enable-impeller

# For Android
flutter run android
```

### Release mode

建構 release 版本可以參考 [Depolyment][Release Depolyment]

## FAQ

募集中

## Authors

[@KennethHung][Kenneth Github]

## Contributors

<a href="https://github.com/maple135790/x50pay/graphs/contributors">
  <img src="https://contrib.rocks/image?repo=maple135790/x50pay"/>
</a>

## Contributing

歡迎所有形式的貢獻者 !

在貢獻之前，請先閱讀 [Guidelines][Guideline file] 和 [貢獻者公約][Code of Conduct file]。

[Guideline file]: CONTRIBUTING.md
[Code of Conduct file]: CODE_OF_CONDUCT.md
[Issue badge]: https://img.shields.io/github/issues/GeekyAnts/infinite-carousel-flutter?label=issues
[Kenneth Github]: https://github.com/maple135790
[Release Depolyment]: https://docs.flutter.dev/deployment
[Flutter SDK]: https://docs.flutter.dev/release/archive
[Flutter installation]: https://docs.flutter.dev/get-started/install
[Flutter badge]: https://img.shields.io/badge/version-3.10-brightgreen?logo=flutter
[Dart badge]: https://img.shields.io/badge/dynamic/yaml?url=https%3A%2F%2Fraw.githubusercontent.com%2Fmaple135790%2Fx50pay%2Fmaster%2Fpubspec.yaml&query=%24.environment.sdk&logo=dart&label=version
