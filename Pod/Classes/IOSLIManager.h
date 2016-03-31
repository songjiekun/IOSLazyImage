//
//  IOSLIManager.h
//  Pods
//
//  Created by song jiekun on 16/3/30.
//
//

#import <Foundation/Foundation.h>

@interface IOSLIManager : NSObject
/**
 *  淡入淡出时间
 */
#define kFadeInAndOut 0.5

/**
 *  返回singlton对象
 *
 *  @return IOSLIManager 对象
 */
+(instancetype)getSharedManager;

/**
 *  io读取的多线程队列
 */
@property (nonatomic, strong) NSOperationQueue *ioQueue;

/**
 *  internet读取的多线程队列
 */
@property (nonatomic, strong) NSOperationQueue *internetQueue;

/**
 *  图片缓存
 */
@property (nonatomic, strong) NSCache *cache;

/**
 *  用来存放正在读取图片的imageView weak引用
 */
@property (nonatomic, strong) NSMapTable *imageViewTable;

/**
 *  异步获取图片到指定的UIImageView
 *
 *  @param imageUrl         图片url
 *  @param defaultImageName 默认图片
 *  @param imageView        展示图片的imageview
 */
-(void)retrieveImage:(NSString*)imageUrl defaultImageName:(NSString*)defaultImageName toImageView:(UIImageView*)imageView;

@end
