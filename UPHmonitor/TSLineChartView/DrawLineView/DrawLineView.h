//
//  DrawLineView.h
//  UPHmonitor
//
//  Created by WeidongCao on 2020/4/26.
//  Copyright © 2020 WeidongCao. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "QuartzCore/CAAnimation.h"

NS_ASSUME_NONNULL_BEGIN

@interface DrawLineView : NSView<CAAnimationDelegate>

//折线图数据数组
@property(nonatomic ,strong)NSMutableArray *yValueArray;
//最大范围
@property(nonatomic ,assign)float yMax;
//最小范围
@property(nonatomic ,assign)float yMin;
//柱状图y轴目标值
@property(nonatomic ,assign)float yTargetVal;
//x轴标注
@property (nonatomic, strong) NSArray *xTitleArray;
//折线颜色
@property(nonatomic ,strong)NSColor *lineColor;

-(void)initView;
-(void)drawLineChart;

@end

NS_ASSUME_NONNULL_END
