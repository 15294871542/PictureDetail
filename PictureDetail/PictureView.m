//
//  PictureView.m
//  CowShare
//
//  Created by mac on 2017/6/1.
//  Copyright © 2017年 tangchaoke. All rights reserved.
//

#import "PictureView.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"
#import "Masonry.h"

#define DeviceWidth     [UIScreen mainScreen].bounds.size.width
#define DeviceHeight    [UIScreen mainScreen].bounds.size.height

@implementation PictureView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor blackColor];
        [self creatScrollView];//创建滚动视图
        
    }
    
    return self;
}

-(void)setPicArray:(NSMutableArray *)picArray
{
    if (picArray!=nil) {
        
        _picArray=picArray;
        
        [self upDate];//更新操作
    }
}

-(void)setCurrentIndex:(NSInteger)currentIndex
{
    self.picScrollView.contentOffset=CGPointMake(DeviceWidth*currentIndex, 0);
    self.picPageControl.currentPage=currentIndex;
}

//创建滚动视图
-(void)creatScrollView
{
    self.picScrollView = [[UIScrollView alloc]init];
    self.picScrollView.bounds=CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    self.picScrollView.center=CGPointMake(self.center.x, self.frame.size.height/2);
    self.picScrollView.pagingEnabled=YES;
    self.picScrollView.delegate=self;
    [self addSubview:self.picScrollView];
    
    self.picPageControl = [[UIPageControl alloc]initWithFrame:CGRectMake((DeviceWidth-100)/2, self.frame.size.height-30, 100, 10)];
    self.picPageControl.pageIndicatorTintColor = [UIColor grayColor];
    self.picPageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
    [self addSubview:self.picPageControl];
    
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    self.picPageControl.currentPage=scrollView.contentOffset.x/DeviceWidth;
}

//更新操作
-(void)upDate
{
    self.picScrollView.bounds=CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    self.picScrollView.center=CGPointMake(self.center.x, self.frame.size.height/2);
    
    self.picScrollView.contentSize=CGSizeMake(self.frame.size.width*self.picArray.count, self.frame.size.width);
    self.picPageControl.frame=CGRectMake((DeviceWidth-15*self.picArray.count)/2, self.frame.size.height-30, 15*self.picArray.count, 10);
    
    self.picPageControl.numberOfPages = self.picArray.count;
    self.picPageControl.currentPage = self.currentIndex;
    
    for (int i=0; i<self.picArray.count; i++) {
        
        UIView * bgView=[[UIView alloc]initWithFrame:CGRectMake(self.frame.size.width*i, 0, self.frame.size.width, self.frame.size.height)];
        bgView.backgroundColor=[UIColor blackColor];
        [self.picScrollView addSubview:bgView];
        
        UIButton * button=[UIButton buttonWithType:UIButtonTypeCustom];
        button.frame=CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        button.backgroundColor=[UIColor whiteColor];
        button.adjustsImageWhenHighlighted=NO;
        button.tag=10+i;
        [button sd_setImageWithURL:[NSURL URLWithString:self.picArray[i]] forState:UIControlStateNormal completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
            float top=(self.frame.size.height-image.size.height/image.size.width*DeviceWidth)/2;
            button.frame=CGRectMake(0, top, self.frame.size.width, image.size.height/image.size.width*DeviceWidth);
            if (error==nil) {
                
                if (self.delegate && [self.delegate respondsToSelector:@selector(complent)]) {
                    [self.delegate complent];
                }
                
            }
            
        }];
        [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:button];
        
        [self.picScrollView addSubview:bgView];
        
    }
    
}

//图片按钮点击事件
-(void)buttonClicked:(UIButton *)btn
{
    self.backBlock(self.picPageControl.currentPage);
}

@end
