//
//  MyTableViewCell.m
//  PictureDetail
//
//  Created by mac on 2017/6/5.
//  Copyright © 2017年 tangchaoke. All rights reserved.
//

#import "MyTableViewCell.h"
#import "UIImageView+WebCache.h"

#define DeviceWidth     [UIScreen mainScreen].bounds.size.width
#define DeviceHeight    [UIScreen mainScreen].bounds.size.height

@implementation MyTableViewCell 

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _myCollectionView.delegate=self;
    _myCollectionView.dataSource=self;
    _myCollectionView.scrollEnabled=NO;
    [_myCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([MyCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:@"mycollectionviewcell"];
    
}

//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.picArray.count;
}

//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((DeviceWidth-50)/3, (DeviceWidth-50)/3);
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 10, 0, 10);
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    MyCollectionViewCell *cell = (MyCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"mycollectionviewcell" forIndexPath:indexPath];
    cell.backgroundColor=[UIColor whiteColor];
    
    [cell.theImageView sd_setImageWithURL:[NSURL URLWithString:self.picArray[indexPath.row]]];
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectedRow: item: index:)]) {
        
        MyCollectionViewCell * item=(MyCollectionViewCell *)[_myCollectionView cellForItemAtIndexPath:indexPath];
        
        [self.delegate selectedRow:indexPath.row item:item index:self.index];
        
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
