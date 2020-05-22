//  您好，谢谢您参考我的项目，如果有问题请移步
//  https://github.com/manofit/GJLineChartView

//
//  GJLineChartView.h
//  GJLineChartView
//
//  Created by gaojun on 2018/2/20.
//  Copyright © 2018年 GJ. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "UIColor+expanded.h"
#import "QuartzCore/CAAnimation.h"

//饼形图需要的宏定义
#define kAnimationDuration 0.25f
#define kPieBackgroundColor [NSColor grayColor]
#define kPieFillColor [NSColor clearColor].CGColor
#define kPieRandColor [NSColor colorWithRed:arc4random() % 255 / 255.0f green:arc4random() % 255 / 255.0f blue:arc4random() % 255 / 255.0f alpha:1.0f]
#define kLabelLoctionRatio (1.2*bgRadius)
#define kThemeColor [NSColor colorWithRed:0.66 green:0.65 blue:0.98 alpha:1.00]
#define numberOfYAxisElements 3 // y轴分为几段

typedef NS_ENUM(NSInteger) {
    PieChart_Type = 0, //饼形图
    BarChart_Type = 1  //柱状图
}DrawViewType;

@interface GJChartDrawView : NSView<CAAnimationDelegate>

//自定义初始化方法
-(id)initWithFrame:(CGRect)frame type:(DrawViewType)type yMax:(CGFloat)yMax yMin:(CGFloat)yMin;

//绘图类型
@property(nonatomic ,assign)DrawViewType drawType;
//折线图数据数组
@property(nonatomic ,strong)NSMutableArray *yValueArray;
//x轴刻度名称
@property(nonatomic ,strong)NSMutableArray *scaleArray;
//y轴刻度名称
@property(nonatomic ,strong)NSMutableArray *columnArray;
//折线图开始点
@property(nonatomic ,assign)CGPoint startPoint;
//折线图结束点
@property(nonatomic ,assign)CGPoint endPoint;
//count
@property(nonatomic ,assign)NSInteger NumCount;
//单位
@property(nonatomic ,strong)NSString *unitStr;
//最大范围
@property(nonatomic ,assign)float yMax;
//最小范围
@property(nonatomic ,assign)float yMin;
//饼形图颜色数据
@property(nonatomic ,strong)NSArray *colorItems;

//柱状图y轴目标值
@property(nonatomic ,assign)unsigned long yTargetVal;

@end
