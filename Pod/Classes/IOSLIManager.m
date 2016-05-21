//
//  IOSLIManager.m
//  Pods
//
//  Created by song jiekun on 16/3/30.
//
//

#import "IOSLIManager.h"
#import <CommonCrypto/CommonDigest.h>

@interface IOSLIManager ()

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
 *  用来存放正在读取图片的imageView weak引用和url的key-value对
 */
@property (nonatomic, strong) NSMapTable *imageViewTable;

/**
 *  用来正在读取中的图片url
 */
@property (nonatomic, strong) NSMutableSet *imageUrlSet;

@end

@implementation IOSLIManager


+ (instancetype)getSharedManager
{
    static IOSLIManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[IOSLIManager alloc] init];
        // Do any other initialisation stuff here
        
    });
    return sharedInstance;
}

-(instancetype)init{
    
    if (self = [super init]) {
        
        //多线程,图片缓存 初始化
        self.cache=[[NSCache alloc] init];
        
        self.ioQueue=[[NSOperationQueue alloc] init];
        self.ioQueue.maxConcurrentOperationCount=40;
        
        self.internetQueue=[[NSOperationQueue alloc] init];
        self.internetQueue.maxConcurrentOperationCount=20;
        
        //初始化imageview列表 key为弱引用 value为强引用
        self.imageViewTable=[NSMapTable weakToStrongObjectsMapTable];
        
    }
    
    return self;
    
    
}


#pragma mark - 缓存图片
-(void)retrieveImage:(NSString*)imageUrl defaultImageName:(NSString*)defaultImageName toImageView:(UIImageView*)imageView{
    
    /**
     *  图片url如果为空，则返回默认图片
     */
    if (imageUrl==nil || [imageUrl isEqualToString:@""]) {
        
        //先返回placeholder图片
        [imageView setImage:[UIImage imageNamed:defaultImageName]];
        
        return;
        
    }
    
    //将url转化为md5 作为文件名
    NSString *filename=[self md5:imageUrl];
    
    
    //首先尝试获取内存缓存中的图片
    UIImage *cachedImage = [self.cache objectForKey:filename];
    
    if (cachedImage) {

        /**
         *  如果内存缓存中已经存有此图片 就直接返回缓存中的图片
         */
        
        [imageView setImage:cachedImage];
        
        /**
         *  对于已经缓存的imageview从列表中删除//2016.5.21 错误图片刷新bug修复
         */
        if ([self.imageViewTable objectForKey:imageView]) {
            
            [self.imageViewTable removeObjectForKey:imageView];
            
        }
        
        if ([self.imageUrlSet containsObject:imageUrl]) {
            
            [self.imageUrlSet removeObject:imageUrl];
            
        }
        
        
        
        return;
        
    }
    else{
        
        /**
         *  将imageview和url加入NSMaptable中 并判断添加的url是否为新
         */
        BOOL isNewUrl = [self addImageView:imageView imageUrl:imageUrl];
        
        //如果不是新url 就不用进入下面所有的下载逻辑
        if (!isNewUrl) {
            
            //先返回placeholder图片
            [imageView setImage:[UIImage imageNamed:defaultImageName]];
            
            return;
            
        }
        
        /**
         *  检查图片是否存在磁盘中 如果存在磁盘中 就从磁盘异步读取
         */
        NSFileManager *fm=[NSFileManager defaultManager];
        NSArray   *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        NSString  *documentsDirectory = [paths objectAtIndex:0];
        NSString  *filePath = [documentsDirectory stringByAppendingPathComponent:filename];
        
        BOOL isImageExists=[fm fileExistsAtPath:filePath];
        
        //是否存在磁盘中
        if (isImageExists) {
            
            //如果图片存在于磁盘中 将文件读取以及解压的任务 加入io队列
            [self.ioQueue addOperationWithBlock:^{
                
                //从磁盘读取图片
                UIImage *diskedImage=[[UIImage alloc] initWithContentsOfFile:filePath];
                
                if (diskedImage) {
                    
                    /**
                     *  解压缩图片
                     */
                    UIGraphicsBeginImageContextWithOptions(diskedImage.size, NO, diskedImage.scale);
                    [diskedImage drawAtPoint:CGPointZero];
                    diskedImage = UIGraphicsGetImageFromCurrentImageContext();
                    UIGraphicsEndImageContext();
                    
                    //图片放到内存缓存中
                    [self.cache setObject:diskedImage forKey:filename];
                    
                    //更新ui imageview
                    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                        
                        //将image添加到imageview上
                        [self replaceImage:diskedImage withUrl:imageUrl];
                        
                        
                    }];
                    
                    
                }
                else{
                    
                    //从磁盘读取失败
                    
                }
                
            }];
            
            //先返回placeholder图片
            [imageView setImage:[UIImage imageNamed:defaultImageName]];
            
            return;
            
        }
        else {
            
            //下载图片 加入下载队列
            [self.internetQueue addOperationWithBlock:^{
                
                /**
                 *  从互联网获取图片的data(同步）
                 */
                NSURL *theImageUrl=[NSURL URLWithString:imageUrl];
                NSData *data=[NSData dataWithContentsOfURL:theImageUrl];
                
                if (data) {
                    
                    UIImage *internetImage=[UIImage imageWithData:data];
                    
                    //保存图片到磁盘
                    [data writeToFile:filePath atomically:YES];
                    
                    //图片放到内存缓存中
                    [self.cache setObject:internetImage forKey:filename];
                    
                    //设置图片状态为被下载
                    //wSelf.theState=ImageStateDownloaded;
                    
                    //更新ui
                    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                        
                        //将image添加到imageview上
                        [self replaceImage:internetImage withUrl:imageUrl];
                        
                    }];
                    
                }
                else{
                    
                    //从网络读取失败
                    
                }
                
            }];
            
            //先返回placeholder图片
            [imageView setImage:[UIImage imageNamed:defaultImageName]];
            
            return;
            
        }
        
    }
    
}

#pragma mark - help函数

-(void)replaceImage:(UIImage*)newImage withUrl:(NSString*)imageUrl{
    
    /**
     *  url相同的 imageview 进行 uiimage替换
     */
    //记录需要被删掉的imageview
    NSMutableArray *keysToDelete = [NSMutableArray array];
    
    for (UIImageView *imageView in self.imageViewTable) {
        
        NSString *url = [self.imageViewTable objectForKey:imageView];
        
        if ([url isEqualToString:imageUrl]) {
            
            //将imageView 加入keysToDelete
            [keysToDelete addObject:imageView];
            
            //将新载入的uiimage加到图片上
            [imageView setImage:newImage];
            
            imageView.alpha=0;
            
            //图片淡入淡出
            [UIView animateWithDuration:kFadeInAndOut animations:^{
                
                imageView.alpha=1;
                
            }];
            
        }
        
    }
    
    //key不能用imageview
    
    /**
     *  将处理好的imageview从列表删除
     */
    for (UIImageView *imageView in keysToDelete) {
        
        [self.imageViewTable removeObjectForKey:imageView];
        
    }
    
    /**
     *  删除url
     */
    if ([self.imageUrlSet containsObject:imageUrl]) {
        
        [self.imageUrlSet removeObject:imageUrl];
        
    }
    
    
}

/**
 *  将imageview和url加入NSMaptable中 并判断添加的url是否为新
 *
 *  @param newImageView 新imageview
 *  @param newImageUrl  新url
 *
 *  @return 新url返回true
 */
-(BOOL)addImageView:(UIImageView*)newImageView imageUrl:(NSString*)newImageUrl{
    
    
    
    //是否为新url的标记
    BOOL isNewURL = true;
    
    //标记是否为新imageview
    BOOL isNewImageView = true;
    
    /**
     *  判断newImageUrl 是否为新url
     *  判断newImageView 是否为新uiimageview
     */
    for (NSString *imageUrl in self.imageUrlSet ) {
        
        if ([imageUrl isEqualToString:newImageUrl]) {
            
            isNewURL = false;
            
        }
        
    }
    
    for (UIImageView *imageView in self.imageViewTable) {
        
        if ([imageView isEqual:newImageView]) {
            
            isNewImageView = false;
            
        }
        
    }

    /**
     *  新url添加入imageUrlSet列表
     */
    if (isNewURL) {
        
        [self.imageUrlSet addObject:newImageUrl];
        
    }
    
    
    /**
     *  将新的UIImageView 和 URL 存入NSMapTable中，
     *  如果imageview 相同 则会替换掉url，如果imageview 不同 就新添加url
     */
    if (isNewImageView) {
        
        [self.imageViewTable setObject:newImageUrl forKey:newImageView];
        
    }
    else{
        
        [self.imageViewTable removeObjectForKey:newImageView];
        
        [self.imageViewTable setObject:newImageUrl forKey:newImageView];
        
    }
    
    
    
    return isNewURL;
    
}

/**
 *  将输入字符串进行md5编码
 *
 *  @param input 输入字符串
 *
 *  @return md5编码后的字符串
 */
-(NSString *) md5:(NSString *) input
{
    const char *cStr = [input UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, (CC_LONG)strlen(cStr), digest ); // This is the md5 call
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return  output;
    
}



@end
