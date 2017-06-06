//
//  MyTableViewCell.h
//  PictureDetail
//
//  Created by mac on 2017/6/5.
//  Copyright © 2017年 tangchaoke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyCollectionViewCell.h"

@protocol CYTableViewDelegate <NSObject>

-(void)selectedRow:(NSInteger)row item:(MyCollectionViewCell *)item index:(NSInteger)index;

@end

@interface MyTableViewCell : UITableViewCell <UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) IBOutlet UICollectionView *myCollectionView;

@property (assign, nonatomic) id <CYTableViewDelegate> delegate;
@property (strong, nonatomic) NSArray * picArray;//当前section的图片数组
@property (assign ,nonatomic) NSInteger index;//当前所在section

@end
