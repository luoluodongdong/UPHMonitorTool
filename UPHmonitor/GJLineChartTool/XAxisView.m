//  您好，谢谢您参考我的项目，如果有问题请移步
//  https://github.com/manofit/GJLineChartView

//
//  XAxisView.m
//  GJLineChartView
//
//  Created by gaojun on 2017/9/31.
//  Copyright © 2017年 GJ. All rights reserved.
//

#import "XAxisView.h"

#define topMargin 30   // 为顶部留出的空白
#define bottomMargin 30 //为底部留出空白
#define kChartLineColor         [NSColor grayColor]
#define kChartTextColor         [NSColor lightGrayColor]
//#define defaultSpace 5
#define leftMargin 10
#define rightMargin 10
#define kScreenWidth [NSScreen mainScreen].visibleFrame.size.width


@interface XAxisView ()

@property (strong, nonatomic) NSArray *xTitleArray;
@property (strong, nonatomic) NSArray *yValueArray;
@property (assign, nonatomic) CGFloat yMax;
@property (assign, nonatomic) CGFloat yMin;

@property (assign, nonatomic) CGFloat defaultSpace;

/**
 *  记录坐标轴的第一个frame
 */
@property (assign, nonatomic) CGRect firstFrame;
@property (assign, nonatomic) CGRect firstStrFrame;//第一个点的文字的frame


@end



@implementation XAxisView

- (id)initWithFrame:(CGRect)frame xTitleArray:(NSArray*)xTitleArray yValueArray:(NSArray*)yValueArray yMax:(CGFloat)yMax yMin:(CGFloat)yMin unit:(NSString*)unit {
    
    self = [super initWithFrame:frame];
    if (self) {
        [self setWantsLayer:YES];
        self.layer.backgroundColor = [NSColor whiteColor].CGColor;
        self.xTitleArray = xTitleArray;
        self.yValueArray = yValueArray;
        self.yMax = yMax;
        self.yMin = yMin;
        self.unit = unit;
        
        if (xTitleArray.count > 600) {
            _defaultSpace = 5;
        }
        else if (xTitleArray.count > 400 && xTitleArray.count <= 600){
            _defaultSpace = 10;
        }
        else if (xTitleArray.count > 200 && xTitleArray.count <= 400){
            _defaultSpace = 20;
        }
        else if (xTitleArray.count > 100 && xTitleArray.count <= 200){
            _defaultSpace = 30;
        }
        else {
            _defaultSpace = 40;
        }
        
        self.pointGap = _defaultSpace;
        
        
    }
    
    return self;
}

- (void)setPointGap:(CGFloat)pointGap {
    _pointGap = pointGap;
    
    [self.layer setNeedsDisplay];
}

- (void)setIsLongPress:(BOOL)isLongPress {
    _isLongPress = isLongPress;
    
    [self.layer setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];

    CGContextRef context = [[NSGraphicsContext currentContext] CGContext];//UIGraphicsGetCurrentContext();
    
    ////////////////////// X轴文字 //////////////////////////
    // 添加坐标轴Label
    for (int i = 0; i < self.xTitleArray.count; i++) {
        NSString *title = self.xTitleArray[i];
        
        [[NSColor blackColor] set];
        NSDictionary *attr = @{NSFontAttributeName : [NSFont systemFontOfSize:8]};
        CGSize labelSize = [title sizeWithAttributes:attr];
        
        CGRect titleRect = CGRectMake((i + 1) * self.pointGap - labelSize.width / 2, bottomMargin - labelSize.height - 10,labelSize.width,labelSize.height);
        
        if (i == 0) {
            self.firstFrame = titleRect;
            if (titleRect.origin.x < 0) {
                titleRect.origin.x = 0;
            }
            
            [title drawInRect:titleRect withAttributes:@{NSFontAttributeName :[NSFont systemFontOfSize:8],NSForegroundColorAttributeName:kChartTextColor}];
            
            //画垂直X轴的竖线
            [self drawLine:context
                startPoint:CGPointMake(titleRect.origin.x+labelSize.width/2, bottomMargin -5)
                  endPoint:CGPointMake(titleRect.origin.x+labelSize.width/2, bottomMargin -10)
                 lineColor:kChartLineColor
                 lineWidth:1];
        }
        // 如果Label的文字有重叠，那么不绘制
        CGFloat maxX = CGRectGetMaxX(self.firstFrame);
        if (i != 0) {
            if ((maxX + 3) > titleRect.origin.x) {
                //不绘制
                
            }else{
                
                [title drawInRect:titleRect withAttributes:@{NSFontAttributeName :[NSFont systemFontOfSize:8],NSForegroundColorAttributeName:kChartTextColor}];
                //画垂直X轴的竖线
                [self drawLine:context
                    startPoint:CGPointMake(titleRect.origin.x+labelSize.width/2, bottomMargin -5)
                      endPoint:CGPointMake(titleRect.origin.x+labelSize.width/2, bottomMargin -10)
                     lineColor:kChartLineColor
                     lineWidth:1];
                
                self.firstFrame = titleRect;
            }
        }else {
            if (self.firstFrame.origin.x < 0) {
                
                CGRect frame = self.firstFrame;
                frame.origin.x = 0;
                self.firstFrame = frame;
            }
        }
        
    }
    
    //////////////// 画原点上的x轴 ///////////////////////
    NSDictionary *attribute = @{NSFontAttributeName : [NSFont systemFontOfSize:8]};
    CGSize textSize = [@"x" sizeWithAttributes:attribute];
    
//    [self drawLine:context
//        startPoint:CGPointMake(0, self.frame.size.height - textSize.height - 5)
//          endPoint:CGPointMake(self.frame.size.width, self.frame.size.height - textSize.height - 5)
//         lineColor:kChartLineColor
//         lineWidth:1];
    [self drawLine:context
    startPoint:CGPointMake(20, bottomMargin - 10)
      endPoint:CGPointMake(self.frame.size.width - rightMargin, bottomMargin - 10)
     lineColor:kChartLineColor
     lineWidth:1];
    
    
    //////////////// 画横向分割线 ///////////////////////
//    CGFloat separateMargin = (self.frame.size.height - topMargin - bottomMargin) / 5;
//    for (int i = 0; i < 5; i++) {
//
//        [self drawLine:context
//            startPoint:CGPointMake(0, self.frame.size.height - textSize.height - 5  - (i + 1) *(separateMargin + 1))
//              endPoint:CGPointMake(0+self.frame.size.width - rightMargin, self.frame.size.height - textSize.height - 5  - (i + 1) *(separateMargin + 1))
//             lineColor:[NSColor lightGrayColor]
//             lineWidth:.1];
//    }
    
    //画target value
    CGFloat targetY = ((self.frame.size.height - topMargin - bottomMargin) / self.yMax) * self.yTargetVal + bottomMargin;
    [self drawLine:context
        startPoint:CGPointMake(20, targetY)
          endPoint:CGPointMake(self.frame.size.width - rightMargin - leftMargin - 20, targetY)
         lineColor:[NSColor lightGrayColor]
         lineWidth:1.0];
    
    /////////////////////// 根据数据源画折线 /////////////////////////
    if (self.yValueArray && self.yValueArray.count > 0) {
        

        //画折线
        for (NSInteger i = 0; i < self.yValueArray.count; i++) {
            
            //如果是最后一个点
            if (i == self.yValueArray.count-1) {
                
                NSNumber *endValue = self.yValueArray[i];
                CGFloat end_yAxisValue = ((self.frame.size.height - topMargin - bottomMargin) / self.yMax) * ([endValue floatValue]) + bottomMargin;
                
                CGFloat chartHeight = self.frame.size.height - textSize.height - 5 - topMargin;
                CGPoint endPoint = CGPointMake((i+1)*self.pointGap, end_yAxisValue);
                
                //画最后一个点
                NSColor *aColor = [NSColor lightGrayColor]; //点的颜色
                CGContextSetFillColorWithColor(context, aColor.CGColor);//填充颜色
                CGContextAddArc(context, endPoint.x, endPoint.y, 3, 0, 2*M_PI, 0); //添加一个圆
                CGContextDrawPath(context, kCGPathFill);//绘制填充
                
                
                //画点上的文字
                NSString *str = [NSString stringWithFormat:@"%.2f", endValue.floatValue];
                // 判断是不是小数
                if ([self isPureFloat:endValue.floatValue]) {
                    str = [NSString stringWithFormat:@"%.2f", endValue.floatValue];
                }
                else {
                    str = [NSString stringWithFormat:@"%.0f", endValue.floatValue];
                }
                
                NSDictionary *attr = @{NSFontAttributeName : [NSFont systemFontOfSize:8]};
                CGSize strSize = [str sizeWithAttributes:attr];
                
                CGRect strRect = CGRectMake(endPoint.x-strSize.width/2,endPoint.y-strSize.height,strSize.width,strSize.height);
                
                // 如果点的文字有重叠，那么不绘制
                CGFloat maxX = CGRectGetMaxX(self.firstStrFrame);
                if (i != 0) {
                    if ((maxX + 3) > strRect.origin.x) {
                        //不绘制
                        
                    }else{
                        
                        [str drawInRect:strRect withAttributes:@{NSFontAttributeName :[NSFont systemFontOfSize:8],NSForegroundColorAttributeName:kChartTextColor}];
                        
                        self.firstStrFrame = strRect;
                    }
                }else {
                    if (self.firstStrFrame.origin.x < 0) {
                        
                        CGRect frame = self.firstStrFrame;
                        frame.origin.x = 0;
                        self.firstStrFrame = frame;
                    }
                }
                
            }else {
                NSNumber *startValue = self.yValueArray[i];
                NSNumber *endValue = self.yValueArray[i+1];
                
                //CGFloat targetY = ((self.frame.size.height - topMargin - bottomMargin) / self.yMax) * self.yTargetVal + bottomMargin;
                
                CGFloat start_yAxisValue = ((self.frame.size.height - topMargin - bottomMargin) / self.yMax) * ([startValue floatValue]) + bottomMargin;
                CGFloat end_yAxisValue = ((self.frame.size.height - topMargin - bottomMargin) / self.yMax) * ([endValue floatValue]) + bottomMargin;
                
                CGFloat chartHeight = self.frame.size.height - textSize.height - 5 - topMargin;
                //CGFloat chartHeight = bottomMargin - 10;
                
                CGPoint startPoint = CGPointMake((i+1)*self.pointGap, start_yAxisValue);
                CGPoint endPoint = CGPointMake((i+2)*self.pointGap, end_yAxisValue);
                
                CGFloat normal[1]={1};
                CGContextSetLineDash(context,0,normal,0); //画实线
                
                [self drawLine:context
                    startPoint:startPoint
                      endPoint:endPoint
                     lineColor:[NSColor colorWithRed:26/255.0 green:135/255.0 blue:254/255.0 alpha:1]
                     lineWidth:2];
                
                
                //画点
                NSColor *aColor = [NSColor lightGrayColor]; //点的颜色
                CGContextSetFillColorWithColor(context, aColor.CGColor);//填充颜色
                CGContextAddArc(context, startPoint.x, startPoint.y, 3, 0, 2*M_PI, 0); //添加一个圆
                CGContextDrawPath(context, kCGPathFill);//绘制填充
                
                
                if (!_isShowLabel) {
                    
                    //画点上的文字
                    NSString *str = [NSString stringWithFormat:@"%.2f", endValue.floatValue];
                    // 判断是不是小数
                    if ([self isPureFloat:startValue.floatValue]) {
                        str = [NSString stringWithFormat:@"%.2f", startValue.floatValue];
                    }
                    else {
                        str = [NSString stringWithFormat:@"%.0f", startValue.floatValue];
                    }
                    
                    NSDictionary *attr = @{NSFontAttributeName : [NSFont systemFontOfSize:8]};
                    CGSize strSize = [str sizeWithAttributes:attr];
                    
                    CGRect strRect = CGRectMake(startPoint.x-strSize.width/2,startPoint.y-strSize.height,strSize.width,strSize.height);
                    if (i == 0) {
                        self.firstStrFrame = strRect;
                        if (strRect.origin.x < 0) {
                            strRect.origin.x = 0;
                        }
                        
                        [str drawInRect:strRect withAttributes:@{NSFontAttributeName :[NSFont systemFontOfSize:8],NSForegroundColorAttributeName:kChartTextColor}];
                    }
                    // 如果点的文字有重叠，那么不绘制
                    CGFloat maxX = CGRectGetMaxX(self.firstStrFrame);
                    //            NSLog(@"%f   %f",maxX,strRect.origin.x);
                    if (i != 0) {
                        if ((maxX + 3) > strRect.origin.x) {
                            //不绘制
                            
                        }else{
                            
                            [str drawInRect:strRect withAttributes:@{NSFontAttributeName :[NSFont systemFontOfSize:8],NSForegroundColorAttributeName:kChartTextColor}];
                            
                            self.firstStrFrame = strRect;
                        }
                    }else {
                        if (self.firstStrFrame.origin.x < 0) {
                            
                            CGRect frame = self.firstStrFrame;
                            frame.origin.x = 0;
                            self.firstStrFrame = frame;
                        }
                    }
                }
            }
            
            
        }
    }
    
    
    //长按时进入
    if(self.isLongPress)
    {
        NSLog(@"%f",_currentLoc.x/self.pointGap);
        int nowPoint = _currentLoc.x/self.pointGap;
        if(nowPoint >= 0 && nowPoint < [self.yValueArray count]) {
            
            NSNumber *num = [self.yValueArray objectAtIndex:nowPoint];
            CGFloat chartHeight = self.frame.size.height - textSize.height - 5 - topMargin;
            
            CGPoint selectPoint = CGPointMake((nowPoint+1)*self.pointGap, chartHeight -  (num.floatValue-self.yMin)/(self.yMax-self.yMin) * chartHeight+topMargin);
            
            //            NSLog(@"_screenLoc=%@",NSStringFromCGPoint(_screenLoc));
            //            NSLog(@"_currentLoc=%@",NSStringFromCGPoint(_currentLoc));
            
            // 显示的时间和单位
            //            CGContextSetFillColorWithColor(context, [UIColor greenColor].CGColor);
            //            CGContextSetStrokeColorWithColor(context, [UIColor greenColor].CGColor);
            CGContextSaveGState(context);
            
            
            //            NSString *timeStr = ;
            NSDictionary *timeAttr = @{NSFontAttributeName : [NSFont systemFontOfSize:12]};
            CGSize timeSize = [[NSString stringWithFormat:@"时间:%@",self.xTitleArray[nowPoint]] sizeWithAttributes:timeAttr];
            
            
            //画文字所在的位置  动态变化
            CGPoint drawPoint = CGPointZero;
            if(_screenLoc.x >((kScreenWidth-leftMargin)/2) && _screenLoc.y < 80) {
                //如果按住的位置在屏幕靠右边边并且在屏幕靠上面的地方   那么字就显示在按住位置的左上角40 60位置
                drawPoint = CGPointMake(_currentLoc.x-40-timeSize.width, 80-60);
            }
            else if(_screenLoc.x >((kScreenWidth-leftMargin)/2) && _screenLoc.y > self.frame.size.height-20) {
                drawPoint = CGPointMake(_currentLoc.x-40-timeSize.width, self.frame.size.height-20 -60);
            }
            else if(_screenLoc.x >((kScreenWidth-leftMargin)/2)) {
                //如果按住的位置在屏幕靠右边边   那么字就显示在按住位置的左上角40 60位置
                drawPoint = CGPointMake(_currentLoc.x-40-timeSize.width, _currentLoc.y-60);
            }
            else if (_screenLoc.x <= ((kScreenWidth-leftMargin)/2) && _screenLoc.y < 80) {
                //如果按住的位置在屏幕靠左边边并且在屏幕靠上面的地方   那么字就显示在按住位置的右上角上角40 40位置
                drawPoint = CGPointMake(_currentLoc.x+40, 80-60);
                
            }
            else if (_screenLoc.x <= ((kScreenWidth-leftMargin)/2) && _screenLoc.y > self.frame.size.height-20) {
                
                drawPoint = CGPointMake(_currentLoc.x+40, self.frame.size.height-20 -60);
                
            }
            else if(_screenLoc.x  <= ((kScreenWidth-leftMargin)/2)) {
                //如果按住的位置在屏幕靠左边   那么字就显示在按住位置的右上角40 60位置
                drawPoint = CGPointMake(_currentLoc.x+40, _currentLoc.y-60);
            }
            
            
            //画选中的数值
            [[NSString stringWithFormat:@"时间:%@",self.xTitleArray[nowPoint]] drawAtPoint:CGPointMake(drawPoint.x, drawPoint.y) withAttributes:@{NSFontAttributeName:[NSFont systemFontOfSize:12],NSForegroundColorAttributeName:[NSColor greenColor]}];
            
            
            // 判断是不是小数
            if ([self isPureFloat:[num floatValue]]) {
                [[NSString stringWithFormat:@"%.2f%@", [num floatValue],self.unit] drawAtPoint:CGPointMake(drawPoint.x, drawPoint.y+15) withAttributes:@{NSFontAttributeName:[NSFont systemFontOfSize:12],NSForegroundColorAttributeName:[NSColor greenColor]}];
            }
            else {
                [[NSString stringWithFormat:@"%.0f%@", [num floatValue],self.unit] drawAtPoint:CGPointMake(drawPoint.x, drawPoint.y+15)withAttributes:@{NSFontAttributeName:[NSFont systemFontOfSize:12],NSForegroundColorAttributeName:[NSColor greenColor]}];
                
            }
            
            
            //画十字线
            //            CGContextRestoreGState(context);
            //            CGContextSetLineWidth(context, 1);
            //            CGContextSetFillColorWithColor(context, [UIColor lightGrayColor].CGColor);
            //            CGContextSetStrokeColorWithColor(context, [UIColor lightGrayColor].CGColor);
            //
            ////            // 选中横线
            ////            CGContextMoveToPoint(context, 0, selectPoint.y);
            ////            CGContextAddLineToPoint(context, self.frame.size.width, selectPoint.y);
            //
            //            // 选中竖线
            //            CGContextMoveToPoint(context, selectPoint.x, 0);
            //            CGContextAddLineToPoint(context, selectPoint.x, self.frame.size.height- textSize.height - 5);
            //
            //            CGContextStrokePath(context);
            
            [self drawLine:context startPoint:CGPointMake(selectPoint.x, 0) endPoint:CGPointMake(selectPoint.x, self.frame.size.height- textSize.height - 5) lineColor:[NSColor lightGrayColor] lineWidth:1];
            
            // 交界点
            CGRect myOval = {selectPoint.x-2, selectPoint.y-2, 4, 4};
            CGContextSetFillColorWithColor(context, [NSColor greenColor].CGColor);
            CGContextAddEllipseInRect(context, myOval);
            CGContextFillPath(context);
        }
    }
    
    
    
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


// 判断是小数还是整数
- (BOOL)isPureFloat:(CGFloat)num {
    int i = num;
    
    CGFloat result = num - i;
    
    // 当不等于0时，是小数
    return result != 0;
}

@end
