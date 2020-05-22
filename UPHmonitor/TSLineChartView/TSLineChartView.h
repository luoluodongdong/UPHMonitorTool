//
//  TSLineChartView.h
//  UPHmonitor
//
//  Created by WeidongCao on 2020/4/25.
//  Copyright © 2020 WeidongCao. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "XYView.h"
#import "DrawLineView.h"

NS_ASSUME_NONNULL_BEGIN

@interface TSLineChartView : NSView

//单位
@property(nonatomic ,strong)NSString *unitStr;
//最大范围
@property(nonatomic ,assign)float yMax;
//最小范围
@property(nonatomic ,assign)float yMin;
//y轴目标值
@property(nonatomic ,assign)unsigned long yTargetVal;
//图标标题
@property (nonatomic, strong) NSString *chartTitle;
//x轴标注
@property (nonatomic, strong) NSArray *xTitleArray;
//数据源数组
@property (nonatomic, strong) NSArray *sourceDataArray;

-(id)initWithFrame:(CGRect)frame backgroundcolor:(NSColor *__nullable)bgColor;

-(void)initView;

-(void)clearChart;

-(void)drawChart;

@end

NS_ASSUME_NONNULL_END
