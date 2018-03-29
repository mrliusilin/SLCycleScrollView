//
//  CycleScrollView.h
//  SLCyclescrollView
//
//  Created by 刘思麟 on 2018/3/26.
//  Copyright © 2018年 刘思麟. All rights reserved.
//

#import <UIKit/UIKit.h>

/** 设置代理 */
@protocol CycleScrollViewDelegate <NSObject>
@optional
- (void)didSelectItemIndexPath:(NSInteger)index;

/**
 

 @param itemView <#itemView description#>
 @param offset
 */
- (void)itemView:(UIView*)itemView relativeVisiableScrollViewCenterOffset:(CGPoint)relativeOffset offset:(CGPoint)offset;

@end
@class CycleScrollView;
@protocol CycleScrollViewDataSource <NSObject>
@required
- (UIView*)cycleScrollView:(CycleScrollView*)CycleScrollView itemViewForItemAtIndex:(NSInteger)index;

- (NSInteger)numberOfItems;

@end

@interface CycleScrollView : UIView

@property (nonatomic, assign) id<CycleScrollViewDelegate> delegate;

@property (nonatomic, assign) id<CycleScrollViewDataSource> dataSource;

/**
 初始化
 
 @param frame 设置View大小
 @param distance 设置Scroll距离View两侧距离
 @param gap 设置Scroll内部 图片间距
 @return 初始化返回值
 */
- (instancetype)initWithFrame:(CGRect)frame withDistanceForScroll:(float)distance withGap:(float)gap;

- (void)registerView:(Class)viewClass withReuseIdentifier:(NSString*)reuseIdentifier;//

- (UIView *)dequeueReusableItemViewWithReuseIdentifier:(NSString*)reuseIdentifier;

@property (nonatomic,assign) BOOL isAutoScroll;//是否自动播放 默认开启（YES）

@property (nonatomic,assign) NSTimeInterval cycleInterval;//轮播时间间隔 默认（5.0lf）

@property (nonatomic,assign) NSInteger currentIndex;

@end
