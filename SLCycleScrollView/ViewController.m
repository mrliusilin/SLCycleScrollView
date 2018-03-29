//
//  ViewController.m
//  SLCycleScrollView
//
//  Created by 刘思麟 on 2018/3/29.
//  Copyright © 2018年 刘思麟. All rights reserved.
//

#import "ViewController.h"
#import "CycleScrollView.h"
#import "ItemView.h"

@interface ViewController ()<CycleScrollViewDelegate,CycleScrollViewDataSource>

@property (nonatomic,strong) CycleScrollView * cycleView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.cycleView];
    // Do any additional setup after loading the view, typically from a nib.
}

- (UIView*)cycleScrollView:(CycleScrollView*)cycleScrollView itemViewForItemAtIndex:(NSInteger)index {
    ItemView * imgV = [cycleScrollView dequeueReusableItemViewWithReuseIdentifier:@"cell"];
    imgV.clipsToBounds = YES;
    imgV.layer.cornerRadius = 10;
    switch (index) {
        case 0:
            imgV.backgroundColor = [UIColor redColor];
            imgV.contentLB.text = @"1哈哈哈测试嘻嘻第二行第三行再测试下哈哈哈测试嘻嘻第二行第三行再测试下";
            break;
        case 1:
            imgV.backgroundColor = [UIColor purpleColor];
            imgV.contentLB.text = @"2哈哈哈测试嘻嘻第二行第三行再测试下哈哈哈测试嘻嘻第二行第三行再测试下";
            break;
        case 2:
            imgV.backgroundColor = [UIColor greenColor];
            imgV.contentLB.text = @"3哈哈哈测试嘻嘻第二行第三行再测试下哈哈哈测试嘻嘻第二行第三行再测试下";
        default:
            
            break;
    }
    return imgV;
}

- (NSInteger)numberOfItems {
    return 3;
}

- (void)itemView:(UIView *)itemView relativeVisiableScrollViewCenterOffset:(CGPoint)relativeOffset offset:(CGPoint)offset {
    ItemView * view = (ItemView*)itemView;
    CGRect rect = view.bounds;
    rect.origin.x += (relativeOffset.x - offset.x) * 0.95 ;
    view.contentLB.frame = rect;
}

- (CycleScrollView *)cycleView {
    if (!_cycleView) {
        _cycleView = [[CycleScrollView alloc] initWithFrame:CGRectMake(20, 100, 300, 100) withDistanceForScroll:-12 withGap:12];
        [_cycleView registerView:[ItemView class] withReuseIdentifier:@"cell"];
        _cycleView.dataSource = self;
        _cycleView.delegate = self;
    }
    return _cycleView;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
