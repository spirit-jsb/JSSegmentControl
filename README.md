# JSSegmentControl

<p align="center">
<a href="https://github.com/apple/swift"><img src="https://img.shields.io/badge/language-swift-red.svg"></a>
<a href="https://github.com/apple/swift"><img src="https://img.shields.io/badge/swift%20version-5.0-orange.svg"></a>
<a href="https://github.com/spirit-jsb/JSSegmentControl"><img src="https://img.shields.io/cocoapods/v/JSSegmentControl.svg?style=flat"></a>
<a href="https://github.com/spirit-jsb/JSSegmentControl/blob/master/LICENSE"><img src="https://img.shields.io/cocoapods/l/JSSegmentControl.svg?style=flat"></a>
<a href="https://cocoapods.org/pods/JSSegmentControl"><img src="https://img.shields.io/cocoapods/p/JSSegmentControl.svg?style=flat"></a>
</p>

## 示例代码

如需要运行示例项目，请 `clone` 当前 `repo` 到本地，从根目录下运行 `JSSegmentControl.xcodeproj`，打开项目后切换 `Scheme` 至 `JSSegmentControl-Demo` 即可。

## 注意事项

⚠️ **请确保重写 `Parent View Controller` 的 `shouldAutomaticallyForwardAppearanceMethods` 参数并返回 `false`，否则会抛出异常信息！** ⚠️

⚠️ **已经完全移除对于 RxSegmentControl 的支持** ⚠️

## Swift 版本依赖
|Swift Version|JSSegmentControl|
|-------------|----------------|
|5.0          |>=2.0.0         |

## 限制条件
* **iOS 9.0** and Up
* **Xcode 10.0** and Up
* **Swift Version** = 5.0

## 安装

`JSSegmentControl` 可以通过 [CocoaPods](https://cocoapods.org) 获得。安装只需要在你项目的 `Podfile` 中添加如下字段：

```ruby
pod 'JSSegmentControl', '~> 2.0.0'
```

## 待解决

- [ ] Zoomed 效果导致 Badge 被遮盖。
- [ ] 在设置 isForceEqualContainerSize 为 true 时，会触发显示异常。

## 作者

spirit-jsb, sibo_jian_29903549@163.com

## 许可文件

`JSSegmentControl` 可在 `MIT` 许可下使用，更多详情请参阅许可文件。

