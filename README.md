# IOSLazyImage

[![CI Status](http://img.shields.io/travis/songjiekun/IOSLazyImage.svg?style=flat)](https://travis-ci.org/songjiekun/IOSLazyImage)
[![Version](https://img.shields.io/cocoapods/v/IOSLazyImage.svg?style=flat)](http://cocoapods.org/pods/IOSLazyImage)
[![GitHub license](https://img.shields.io/github/license/mashape/apistatus.svg)](https://github.com/songjiekun/IOSLazyImage)
[![Platform](https://img.shields.io/cocoapods/p/IOSLazyImage.svg?style=flat)](http://cocoapods.org/pods/IOSLazyImage)

An image manager library to help you lazily load image from remote url to your UIImageView with only two lines of code.
只需要两行代码，就能帮你的app实现图片lazy loading的功能。

## Feature

2 levels of cache.Memory cache,Disk cache

decompress image before loading into memory.

2层缓存，内存缓存，硬盘缓存

预解压缩图片

## Usage

(To run the example project, clone the repo, and run `pod install` from the Example directory first.)

Super easy to use. 

Only two lines of code.

简单易用

两行代码


don't forget to import IOSLazyImage/IOSLIManager.h

获取IOSLIManager

get IOSLIManager refrence

```objc
IOSLIManager *liManager = [IOSLIManager getSharedManager];
```

提供图片url 默认图片的名称 以及图片对应uiimageview

provide image url,default image file name and the imageview which will load the image
```objc
[liManager retrieveImage:imageurl defaultImageName:@"1.png" toImageView:cell.imageView];
```


## Requirements
>ios 7.1

## Installation

IOSLazyImage is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "IOSLazyImage"
```

## Author

宋介堃 (song jie kun), songjiekun@gmail.com

## License

IOSLazyImage is available under the MIT license. See the LICENSE file for more info.
