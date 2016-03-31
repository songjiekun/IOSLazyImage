//
//  IOSLIViewController.m
//  IOSLazyImage
//
//  Created by song jie kun on 03/30/2016.
//  Copyright (c) 2016 song jie kun. All rights reserved.
//

#import "IOSLIViewController.h"
#import "IOSLICollectionViewCell.h"
#import <IOSLazyImage/IOSLIManager.h>


@interface IOSLIViewController ()

@end

@implementation IOSLIViewController

- (id)initWithCoder:(NSCoder *)aDecoder{
    
    if((self=[super initWithCoder:aDecoder])){
        
        //初始化数据
        self.urlArray = [[NSMutableArray alloc] init];
        [self.urlArray addObject:@"http://www.sportsnet.ca/wp-content/uploads/2013/10/Close-Up-SML.jpg"];
        [self.urlArray addObject:@"http://www.sportsnet.ca/wp-content/uploads/2013/10/Close-Up-SML.jpg"];
        [self.urlArray addObject:@"http://blog.photowhoa.com/2015/wp-content/uploads/2013/04/RED-ROCK-JAMES-WEBER-PHOTOGRAPHER-13444.jpg"];
        [self.urlArray addObject:@"http://dp.lexar.com/files/general/inline/inline1.jpg"];
        [self.urlArray addObject:@"http://imgs.abduzeedo.com/files/articles/magical-animal-photography-gregory-colbert/5.jpg"];
        [self.urlArray addObject:@"http://www.diyphotography.net/wordpress/wp-content/uploads/2014/07/c_blurMEDIAphotography_JP_Danko__BLR6665.jpg"];
        [self.urlArray addObject:@"http://www.wix.com/blog/file/2010/09/5-Elements-to-Compose-Great-Photographs-Photo-By-Pedro-Mart%C3%ADn.jpg"];
        [self.urlArray addObject:@"http://www.123inspiration.com/wp-content/uploads/2012/05/Akos-Major-4-600x400.jpg"];
        [self.urlArray addObject:@"http://media.idownloadblog.com/wp-content/uploads/2013/09/iPhone-Compositon-Tips-1024x768.jpg"];
        [self.urlArray addObject:@"http://onlybackground.com/wp-content/uploads/2014/01/marble-beautiful-photography-1920x1200.jpg"];
        [self.urlArray addObject:@"http://iphonephotographyschool.com/wp-content/uploads/Beginners-Guide-iPhone-Photography-7.jpg"];
        [self.urlArray addObject:@"http://www.sportsnet.ca/wp-content/uploads/2013/10/Close-Up-SML.jpg"];
        [self.urlArray addObject:@"http://www.sportsnet.ca/wp-content/uploads/2013/10/Close-Up-SML.jpg"];
        [self.urlArray addObject:@"http://www.sportsnet.ca/wp-content/uploads/2013/10/Close-Up-SML.jpg"];
        [self.urlArray addObject:@"http://blog.photowhoa.com/2015/wp-content/uploads/2013/04/RED-ROCK-JAMES-WEBER-PHOTOGRAPHER-13444.jpg"];
        [self.urlArray addObject:@"http://dp.lexar.com/files/general/inline/inline1.jpg"];
        [self.urlArray addObject:@"http://imgs.abduzeedo.com/files/articles/magical-animal-photography-gregory-colbert/5.jpg"];
        [self.urlArray addObject:@"http://www.diyphotography.net/wordpress/wp-content/uploads/2014/07/c_blurMEDIAphotography_JP_Danko__BLR6665.jpg"];
        [self.urlArray addObject:@"http://www.wix.com/blog/file/2010/09/5-Elements-to-Compose-Great-Photographs-Photo-By-Pedro-Mart%C3%ADn.jpg"];
        [self.urlArray addObject:@"http://www.123inspiration.com/wp-content/uploads/2012/05/Akos-Major-4-600x400.jpg"];
        [self.urlArray addObject:@"http://media.idownloadblog.com/wp-content/uploads/2013/09/iPhone-Compositon-Tips-1024x768.jpg"];
        [self.urlArray addObject:@"http://onlybackground.com/wp-content/uploads/2014/01/marble-beautiful-photography-1920x1200.jpg"];
        [self.urlArray addObject:@"http://iphonephotographyschool.com/wp-content/uploads/Beginners-Guide-iPhone-Photography-7.jpg"];
        [self.urlArray addObject:@"http://www.sportsnet.ca/wp-content/uploads/2013/10/Close-Up-SML.jpg"];
        
        
    }
    
    return self;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    //注册cell
    UINib *nib = [UINib nibWithNibName:@"IOSLICollectionViewCell" bundle:nil];
    [self.galleryCollectionView registerNib:nib forCellWithReuseIdentifier:@"IOSLICollectionViewCell"];
    
    //配置代理
    self.galleryCollectionView.delegate=self;
    self.galleryCollectionView.dataSource=self;
    
    //
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - collection view代理
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.urlArray.count;
    
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
}


-(UICollectionViewCell* )collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    IOSLICollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"IOSLICollectionViewCell" forIndexPath:indexPath];

    //获取IOSLIManager
    IOSLIManager *liManager = [IOSLIManager getSharedManager];
    
    //展示图片
    [liManager retrieveImage:self.urlArray[indexPath.row] defaultImageName:@"1.png" toImageView:cell.imageView];
    
    return cell;
    
    
}


-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout  sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSInteger width=(self.galleryCollectionView.frame.size.width-3*ItemSpace)/2;
    NSInteger height=width;
    
    return CGSizeMake(width, height);
}

/*
 -(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
 
 return 5;
 
 }
 */

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    
    //每个cell间距
    return ItemSpace;
    
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    
    return UIEdgeInsetsMake(0, ItemSpace, 0, ItemSpace);
    
}



-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    
    CGSize headerSize= CGSizeMake(0, 0);
    return headerSize;
    
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    
    CGSize footerSize= CGSizeMake(0, 0);
    return footerSize;
    
}



@end
