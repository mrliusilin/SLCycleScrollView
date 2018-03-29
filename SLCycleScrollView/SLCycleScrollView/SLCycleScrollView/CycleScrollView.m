//
//  CycleScrollView.m
//  SLCyclescrollView
//
//  Created by 刘思麟 on 2018/3/26.
//  Copyright © 2018年 刘思麟. All rights reserved.
//

#import "CycleScrollView.h"

#define placeHolderCount 3

@interface CycleScrollView()<UIScrollViewDelegate> {
    CGFloat _distance;
    CGFloat _gap;
    NSMutableDictionary *_reuseViewClassDic;//复用标识（key） class（value）
    NSMutableDictionary *_reuseViewDic;//复用标识(class) view(value)
    NSMutableArray * _visiableItemViewsArr;//
    CGPoint _scrollViewShowCenterPoint;
}

@property (nonatomic,strong) UIScrollView * cycleScrollView;

@property (nonatomic,strong) NSTimer * cycleTimer;

@end

@implementation CycleScrollView

- (instancetype)initWithFrame:(CGRect)frame withDistanceForScroll:(float)distance withGap:(float)gap {
    if (self = [super initWithFrame:frame]) {
        _distance = distance;
        _gap = gap;
        [self addSubview:self.cycleScrollView];
        _visiableItemViewsArr = @[].mutableCopy;
        self.clipsToBounds = YES;
        _cycleInterval = 5;
        _isAutoScroll = YES;
    }
    return self;
}

- (void)registerView:(Class)viewClass withReuseIdentifier:(NSString *)reuseIdentifier {
    if (!_reuseViewClassDic) {
        _reuseViewClassDic = @{}.mutableCopy;
    }
    if (!_reuseViewDic) {
        _reuseViewDic = @{}.mutableCopy;
    }
    if (![_reuseViewClassDic.allKeys containsObject:reuseIdentifier]) {
        [_reuseViewClassDic setObject:NSStringFromClass(viewClass) forKey:reuseIdentifier];
        [_reuseViewDic setObject:@[].mutableCopy forKey:NSStringFromClass(viewClass)];
    }
}

- (UIView *)dequeueReusableItemViewWithReuseIdentifier:(NSString *)reuseIdentifier {
    UIView * view;
    NSString * classStr = _reuseViewClassDic[reuseIdentifier];
    NSMutableArray * muArr = _reuseViewDic[classStr];
    NSAssert(classStr, @"该视图类未注册");
    if (muArr.count < 1) {
        view = [NSClassFromString(classStr) new];
    }else {
        view = muArr.firstObject;
        [muArr removeObjectAtIndex:0];
    }
    return view;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.cycleScrollView.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame) - _distance, CGRectGetHeight(self.frame));
    self.cycleScrollView.contentSize = CGSizeMake(placeHolderCount * (CGRectGetWidth(self.frame) - _distance), CGRectGetHeight(self.frame));
    [self.cycleScrollView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    _scrollViewShowCenterPoint = CGPointMake(CGRectGetWidth(self.frame) - _distance, 0);
    if (self.dataSource) {
        [_visiableItemViewsArr addObject:[self.dataSource cycleScrollView:self itemViewForItemAtIndex:[self.dataSource numberOfItems] - 1]];
        [_visiableItemViewsArr addObject:[self.dataSource cycleScrollView:self itemViewForItemAtIndex:0]];
        [_visiableItemViewsArr addObject:[self.dataSource cycleScrollView:self itemViewForItemAtIndex:1]];
    }
    self.currentIndex = 0;
    if (self.isAutoScroll) {
        [[NSRunLoop currentRunLoop] addTimer:self.cycleTimer forMode:NSRunLoopCommonModes];
    }
}

#pragma UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.x + scrollView.frame.size.width == scrollView.contentSize.width) {
        UIView * view1 = _visiableItemViewsArr.firstObject;
        NSMutableArray * muArr = _reuseViewDic[NSStringFromClass([view1 class])];
        [muArr addObject:view1];
        [_visiableItemViewsArr removeObjectAtIndex:0];
        [view1 removeFromSuperview];
        if (self.dataSource) {
            UIView * view2 = [self.dataSource cycleScrollView:self itemViewForItemAtIndex:(self.currentIndex + 2) % [self.dataSource numberOfItems]];
            [_visiableItemViewsArr addObject:view2];
        }
        self.currentIndex ++;
    }else if (scrollView.contentOffset.x == 0){
        UIView * view1 = _visiableItemViewsArr.lastObject;
        NSMutableArray * muArr = _reuseViewDic[NSStringFromClass([view1 class])];
        [muArr addObject:view1];
        [_visiableItemViewsArr removeLastObject];
        [view1 removeFromSuperview];
        if (self.dataSource) {
            UIView * view2 = [self.dataSource cycleScrollView:self itemViewForItemAtIndex:(self.currentIndex - 2 ) % [self.dataSource numberOfItems]];
            [_visiableItemViewsArr insertObject:view2 atIndex:0];
        }
        self.currentIndex --;
    }
    
    CGPoint relativeCenterOffset = CGPointMake(scrollView.contentOffset.x - CGRectGetWidth(self.cycleScrollView.frame), scrollView.contentOffset.y - _scrollViewShowCenterPoint.y);
    if (self.delegate && [self.delegate respondsToSelector:@selector(itemView:relativeVisiableScrollViewCenterOffset:offset:)]) {
        for (int index = 0; index < _visiableItemViewsArr.count; index ++ ) {
            [self.delegate itemView:_visiableItemViewsArr[index] relativeVisiableScrollViewCenterOffset:relativeCenterOffset offset:CGPointMake((index - 1) * self.cycleScrollView.frame.size.width, 0)];
        }
    }
}

- (void)setCurrentIndex:(NSInteger)currentIndex {
    _currentIndex = currentIndex;
    [_visiableItemViewsArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIView * v = obj;
        v.frame = CGRectMake(idx * CGRectGetWidth(self.cycleScrollView.frame), 0, CGRectGetWidth(self.cycleScrollView.frame) - _gap, CGRectGetHeight(self.cycleScrollView.frame));
        [self.cycleScrollView addSubview:v];
    }];
    [self.cycleScrollView setContentOffset:CGPointMake(CGRectGetWidth(self.cycleScrollView.frame), 0)   animated:NO];
}

- (UIScrollView *)cycleScrollView {
    if (!_cycleScrollView) {
        _cycleScrollView = [UIScrollView new];
        _cycleScrollView.delegate = self;
        _cycleScrollView.pagingEnabled = YES;
        _cycleScrollView.bounces = NO;
        _cycleScrollView.clipsToBounds = YES;
    }
    return _cycleScrollView;
}

- (NSTimer *)cycleTimer {
    if (!_cycleTimer) {
        _cycleTimer = [NSTimer timerWithTimeInterval:self.cycleInterval repeats:YES block:^(NSTimer * _Nonnull timer) {
            [self.cycleScrollView setContentOffset:CGPointMake(self.cycleScrollView.contentSize.width - CGRectGetWidth(self.cycleScrollView.frame), 0) animated:YES];
        }];
    }
    return _cycleTimer;
}

- (void)dealloc {
    if (self.cycleTimer) {
        [self.cycleTimer invalidate];
    }
}

@end
