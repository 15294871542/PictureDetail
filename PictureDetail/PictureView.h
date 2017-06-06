//
//  PictureView.h
//  CowShare
//
//  Created by mac on 2017/6/1.
//  Copyright © 2017年 tangchaoke. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol complentDelegate <NSObject>

-(void)complent;

@end

@interface PictureView : UIView <UIScrollViewDelegate>

@property (nonatomic,strong) NSMutableArray * picArray;//图片数组
@property (nonatomic,strong) UIScrollView * picScrollView;//图片滚动视图
@property (nonatomic,strong) UIPageControl * picPageControl;//图片页码
@property (nonatomic,assign) NSInteger currentIndex;//当前点击的图片所在位置

@property (nonatomic,strong) void (^ backBlock)(NSInteger);//返回按钮点击
@property (nonatomic,assign) id <complentDelegate> delegate;

@end
