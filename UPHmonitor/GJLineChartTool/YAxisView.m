//  您好，谢谢您参考我的项目，如果有问题请移步
//  https://github.com/manofit/GJLineChartView

//
//  YAxisView.m
//  GJLineChartView
//
//  Created by gaojun on 2017/9/31.
//  Copyright © 2017年 GJ. All rights reserved.
//

#import "YAxisView.h"
#define topMargin 30   // 为顶部留出的空白
#define bottomMargin 30 //为底部留出空白
#define xAxisTextGap 5 //x轴文字与坐标轴间隙
#define numberOfYAxisElements 3 // y轴分为几段
#define kChartLineColor         [NSColor whiteColor]
#define kChartTextColor         [NSColor lightGrayColor]


@interface YAxisView ()

@property (assign, nonatomic) CGFloat yMax;
@property (assign, nonatomic) CGFloat yMin;
@property (strong, nonatomic) NSString* unit;
@end

@implementation YAxisView

- (id)initWithFrame:(CGRect)frame yMax:(CGFloat)yMax yMin:(CGFloat)yMin unit:(NSString*)unit {
    
    if (self = [super initWithFrame:frame]) {
        //[self setWantsLayer:YES];
        [self.layer setBackgroundColor:[NSColor whiteColor].CGColor];
        //self.layer.backgroundColor = [NSColor whiteColor].CGColor;
        self.yMax = yMax;
        self.yMin = yMin;
        self.unit = unit;
    }
    return self;
}



- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    CGContextRef context = [[NSGraphicsContext currentContext] CGContext];//UIGraphicsGetCurrentContext();
    // 计算坐标轴的位置以及大小
    NSDictionary *attr = @{NSFontAttributeName : [NSFont systemFontOfSize:8]};
    
    CGSize labelSize = [@"x" sizeWithAttributes:attr];

    [self drawLine:context
        startPoint:CGPointMake(20, 30 - 10)
          endPoint:CGPointMake(20, self.frame.size.height - 10)
         lineColor:[NSColor grayColor]
         lineWidth:1];
    
    NSString * Unit = [NSString stringWithFormat:@"单位/%@",self.unit];
    NSDictionary *waterAttr = @{NSFontAttributeName : [NSFont systemFontOfSize:8]};
    CGSize waterLabelSize = [Unit sizeWithAttributes:waterAttr];
    CGRect waterRect = CGRectMake(self.frame.size.width - waterLabelSize.width + 1, self.frame.size.height - 10,waterLabelSize.width ,waterLabelSize.height);
    [Unit drawInRect:waterRect withAttributes:@{NSFontAttributeName :[NSFont systemFontOfSize:8],NSForegroundColorAttributeName:kChartTextColor}];
    
    int duan = numberOfYAxisElements;
    
    if (self.yMax - self.yMin == 0){
        duan = 1;
    }

    // Label做占据的高度
    CGFloat allLabelHeight = self.frame.size.height - xAxisTextGap - labelSize.height;
    // Label之间的间隙
    CGFloat labelMargin = (allLabelHeight + labelSize.height - (duan + 1) * labelSize.height) / duan;

    // 添加Label
    for (int i = 0; i < duan + 1; i++) {

        CGFloat avgValue = (self.yMax - self.yMin) / duan;
        
        
        
        CGFloat yAxisValue = ((self.frame.size.height - topMargin - bottomMargin) / duan) * i + bottomMargin;
        
        [self drawLine:context
        startPoint:CGPointMake(20, yAxisValue)
          endPoint:CGPointMake(20 + 5, yAxisValue)
         lineColor:[NSColor grayColor]
         lineWidth:1];
        
        if (avgValue == 0.0){
            avgValue = self.yMin;
            // 判断是不是小数
            if ([self isPureFloat:self.yMin + avgValue * i]) {
                CGSize yLabelSize = [[NSString stringWithFormat:@"%.0f", 0 + avgValue * i] sizeWithAttributes:waterAttr];
                
                [[NSString stringWithFormat:@"%.0f", 0 + avgValue * i] drawInRect:CGRectMake(self.frame.size.width - 1-5 - yLabelSize.width, self.frame.size.height - labelSize.height - 5 - labelMargin* i - yLabelSize.height/2, yLabelSize.width, yLabelSize.height) withAttributes:@{NSFontAttributeName :[NSFont systemFontOfSize:8],NSForegroundColorAttributeName:kChartTextColor}];
            }
            else {
                CGSize yLabelSize = [[NSString stringWithFormat:@"%.0f", 0 + avgValue * i] sizeWithAttributes:waterAttr];
                
                //[[NSString stringWithFormat:@"%.0f", 0 + avgValue * i] drawInRect:CGRectMake(self.frame.size.width - 1-5 - yLabelSize.width, self.frame.size.height - labelSize.height - 5 - labelMargin* i - yLabelSize.height/2, yLabelSize.width, yLabelSize.height) withAttributes:@{NSFontAttributeName :[NSFont systemFontOfSize:8],NSForegroundColorAttributeName:kChartTextColor}];
                [[NSString stringWithFormat:@"%.0f", self.yMin + avgValue * i] drawInRect:CGRectMake(self.frame.size.width - 1-5 - yLabelSize.width, yAxisValue, yLabelSize.width, yLabelSize.height) withAttributes:@{NSFontAttributeName :[NSFont systemFontOfSize:8],NSForegroundColorAttributeName:kChartTextColor}];
            }
            
        }else{
            // 判断是不是小数
            if ([self isPureFloat:self.yMin + avgValue * i]) {
                CGSize yLabelSize = [[NSString stringWithFormat:@"%.0f", self.yMin + avgValue * i] sizeWithAttributes:waterAttr];
                
                [[NSString stringWithFormat:@"%.0f", self.yMin + avgValue * i] drawInRect:CGRectMake(self.frame.size.width - 1-5 - yLabelSize.width, self.frame.size.height - labelSize.height - 5 - labelMargin* i - yLabelSize.height/2, yLabelSize.width, yLabelSize.height) withAttributes:@{NSFontAttributeName :[NSFont systemFontOfSize:8],NSForegroundColorAttributeName:kChartTextColor}];
            }
            else {
                CGSize yLabelSize = [[NSString stringWithFormat:@"%.0f", self.yMin + avgValue * i] sizeWithAttributes:waterAttr];
                
                //[[NSString stringWithFormat:@"%.0f", self.yMin + avgValue * i] drawInRect:CGRectMake(self.frame.size.width - 1-5 - yLabelSize.width, self.frame.size.height - labelSize.height - 5 - labelMargin* i - yLabelSize.height/2, yLabelSize.width, yLabelSize.height) withAttributes:@{NSFontAttributeName :[NSFont systemFontOfSize:8],NSForegroundColorAttributeName:kChartTextColor}];
                [[NSString stringWithFormat:@"%.0f", self.yMin + avgValue * i] drawInRect:CGRectMake(self.frame.size.width - 1-5 - yLabelSize.width, yAxisValue, yLabelSize.width, yLabelSize.height) withAttributes:@{NSFontAttributeName :[NSFont systemFontOfSize:8],NSForegroundColorAttributeName:kChartTextColor}];
            }
        }
        
        
        
    }
}

// 判断是小数还是整数
- (BOOL)isPureFloat:(CGFloat)num
{
    int i = num;
    
    CGFloat result = num - i;
    
    // 当不等于0时，是小数
    return result != 0;
}

- (void)drawLine:(CGContextRef)context startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint lineColor:(NSColor *)lineColor lineWidth:(CGFloat)width {
    
    CGContextSetShouldAntialias(context, YES ); //抗锯齿
    CGColorSpaceRef Linecolorspace1 = CGColorSpaceCreateDeviceRGB();
    CGContextSetStrokeColorSpace(context, Linecolorspace1);
    CGContextSetLineWidth(context, width);
    CGContextSetStrokeColorWithColor(context, lineColor.CGColor);
    CGContextMoveToPoint(context, startPoint.x, startPoint.y);
    CGContextAddLineToPoint(context, endPoint.x, endPoint.y);
    CGContextStrokePath(context);
    CGColorSpaceRelease(Linecolorspace1);
}



@end
