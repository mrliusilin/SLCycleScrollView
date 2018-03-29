//
//  ItemView.m
//  SLCydescrollView
//
//  Created by 刘思麟 on 2018/3/27.
//  Copyright © 2018年 刘思麟. All rights reserved.
//

#import "ItemView.h"

@implementation ItemView

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.contentLB];
        self.contentLB.text = @"哈哈哈测试嘻嘻\n第二行\n第三行再测试下";
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
//    self.contentLB.frame = self.bounds;
//    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        [obj removeFromSuperview];
//    }];
}

- (UILabel *)contentLB {
    if (!_contentLB) {
        _contentLB = [UILabel new];
        _contentLB.numberOfLines = 0;
        _contentLB.textColor = [UIColor whiteColor];
        _contentLB.font = [UIFont systemFontOfSize:14];
    }
    return _contentLB;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
