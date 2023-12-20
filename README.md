# X50Pay

![Flutter Badge][Flutter badge]
![Dart badge][Dart badge]
[![Flutter CI][Build badge]](https://github.com/maple135790/x50pay/actions/workflows/flutter.yml)
[![GitHub issues by-label][Issue badge]](https://github.com/maple135790/x50pay/issues)

<p align=center> NEXT Generation of MUGPay </p>

<p align="center">
  <img  width="400" height="400" src="https://pay.x50.fun/static/50paylogo.png">
</p>

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
- 快速登入
- 接受許願中...

## Roadmap

- 增加 排隊等候 App 內推播通知
- 新增更多說明文件

## Installation

本專案使用 `Flutter ^3.16` 版本建構。請先[下載][Flutter SDK]合適的 SDK 版本。

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

Q: 我用的 1password 為甚麼沒辦法自動帶入(autofill)帳號密碼？

> A: 我也不知道，google autofill 和 apple autofill 可以填入。在找到問題之前看要不要先啟用原生的 autofill，或是直接 CopyPaste。

Q: 為甚麼不能用手機刷卡？為甚麼手機刷卡有點難觸發?

> A: 目前正在嘗試修復。由於手機的卡片模擬和 NFC tag 讀取[不能同時使用][nfc hce]，所以有新增了卡片模擬時間的選項 (於 設定 > X50Pay App 設定
> )。如果仍有問題，再和我連絡，

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
[Issue badge]: https://img.shields.io/github/issues/maple135790/x50pay?label=issues
[Kenneth Github]: https://github.com/maple135790
[Release Depolyment]: https://docs.flutter.dev/deployment
[Flutter SDK]: https://docs.flutter.dev/release/archive
[Flutter installation]: https://docs.flutter.dev/get-started/install
[Flutter badge]: https://img.shields.io/badge/dynamic/yaml?url=https%3A%2F%2Fraw.githubusercontent.com%2Fmaple135790%2Fx50pay%2Fmaster%2Fpubspec.yaml&query=%24.environment.flutter&logo=flutter&label=version
[Dart badge]: https://img.shields.io/badge/dynamic/yaml?url=https%3A%2F%2Fraw.githubusercontent.com%2Fmaple135790%2Fx50pay%2Fmaster%2Fpubspec.yaml&query=%24.environment.sdk&logo=dart&label=version
[Build badge]: https://github.com/maple135790/x50pay/actions/workflows/flutter.yml/badge.svg?branch=master&event=push
[nfc hce]: https://developer.android.com/reference/android/nfc/NfcAdapter#In%20this%20mode%20the%20NFC%20controller%20will%20only%20act%20as%20an%20NFC%20tag%20reader/writer,%20thus%20disabling%20any%20peer-to-peer%20(Android%20Beam)%20and%20card-emulation%20modes%20of%20the%20NFC%20adapter%20on%20this%20device.:~:text=In%20this%20mode%20the%20NFC%20controller%20will%20only%20act%20as%20an%20NFC%20tag%20reader/writer%2C%20thus%20disabling%20any%20peer%2Dto%2Dpeer%20(Android%20Beam)%20and%20card%2Demulation%20modes%20of%20the%20NFC%20adapter%20on%20this%20device.