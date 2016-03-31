//
//  IOSLIViewController.h
//  IOSLazyImage
//
//  Created by song jie kun on 03/30/2016.
//  Copyright (c) 2016 song jie kun. All rights reserved.
//

@import UIKit;

@interface IOSLIViewController : UIViewController<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

/**
 *  淡入淡出时间
 */
#define ItemSpace 10

/**
 *  展示图片的collectionview
 */
@property (weak,nonatomic) IBOutlet UICollectionView *galleryCollectionView;

@property (strong,nonatomic) NSMutableArray<NSString *> *urlArray;

@end
