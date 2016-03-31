# IOSLazyImage

[![CI Status](http://img.shields.io/travis/song jie kun/IOSLazyImage.svg?style=flat)](https://travis-ci.org/song jie kun/IOSLazyImage)
[![Version](https://img.shields.io/cocoapods/v/IOSLazyImage.svg?style=flat)](http://cocoapods.org/pods/IOSLazyImage)
[![License](https://img.shields.io/cocoapods/l/IOSLazyImage.svg?style=flat)](http://cocoapods.org/pods/IOSLazyImage)
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

//do't forget to import
#import <IOSLazyImage/IOSLIManager.h>

//获取IOSLIManager   get IOSLIManager refrence
IOSLIManager *liManager = [IOSLIManager getSharedManager];

//展示图片 display image
[liManager retrieveImage:imageurl defaultImageName:@"1.png" toImageView:cell.imageView];


/**
*  异步获取图片到指定的UIImageView
*
*  @param imageUrl         图片url（image url)
*  @param defaultImageName 默认图片（the name of the image inside main bundle which will play as default image while manager loading the real image）
*  @param imageView        展示图片的imageview (the UIImageView which will display the lazy loaded image)
*/
-(void)retrieveImage:(NSString*)imageUrl defaultImageName:(NSString*)defaultImageName toImageView:(UIImageView*)imageView;

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
