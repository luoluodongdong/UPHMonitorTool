//
//  DrawLineView.m
//  UPHmonitor
//
//  Created by WeidongCao on 2020/4/26.
//  Copyright © 2020 WeidongCao. All rights reserved.
//

#import "DrawLineView.h"
#import "QuartzCore/CAAnimation.h"
#import "QuartzCore/CAShapeLayer.h"
#import "QuartzCore/CAMediaTimingFunction.h"

//图标上下左右边距
#define UP    20.0
#define BELOW 30.0
#define LEFT  30.0
#define RIGHT 10.0

#define kAnimationDuration 0.25f
#define kPieBackgroundColor [NSColor grayColor]
#define kPieFillColor [NSColor clearColor].CGColor
#define kPieRandColor [NSColor colorWithRed:arc4random() % 255 / 255.0f green:arc4random() % 255 / 255.0f blue:arc4random() % 255 / 255.0f alpha:1.0f]
#define kLabelLoctionRatio (1.2*bgRadius)
#define kThemeColor [NSColor colorWithRed:0.66 green:0.65 blue:0.98 alpha:1.00]

@interface DrawLineView()

//折线图开始点
@property(nonatomic ,assign)CGPoint startPoint;
//折线图结束点
@property(nonatomic ,assign)CGPoint endPoint;
//count
@property(nonatomic ,assign)NSInteger NumCount;

@end

@implementation DrawLineView
{
    //折线图获取数组元素下标
    int     _number;

    //长按显示标注线
    NSView  *_lineView;
    //展示数据label
    NSButton *_dataBtn;
    
    //饼形图需要的变量
    CGFloat _total;

    //记录num
    int    _num;
    
    NSMutableArray *_arrayPoint;
    BOOL _updateFlag;
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    if (_updateFlag) {
        //_updateFlag = NO;
        
        if (_number == self.yValueArray.count) {
            _updateFlag = NO;
            //return;
        }
        [self drawOneLineChart];
        //[self drawBarChart];
        
        //_updateFlag = NO;
    }
    // Drawing code here.
}
-(void)viewWillDraw{
//    NSLog(@"[DrawLineView] - viewWillDraw");
//    if (_number<self.yValueArray.count) {
//        [self drawBarChart];
//    }
    
}
-(void)initView{
    
    _arrayPoint = [NSMutableArray array];
    self.NumCount = self.xTitleArray.count + 1;
    _number = 0;
    _updateFlag = YES;
    [_arrayPoint addObjectsFromArray:[self disposePointArray:self.yValueArray]];
    
    //_startPoint = CGPointMake((self.frame.size.width - LEFT - RIGHT) / self.NumCount + LEFT, self.frame.size.height - BELOW);
    //IOS -> MacOS 反转y轴
    //_startPoint = CGPointMake((self.frame.size.width - LEFT - RIGHT) / self.NumCount + LEFT, BELOW);
    _startPoint = NSPointToCGPoint(NSPointFromString([_arrayPoint objectAtIndex:0]));
    _endPoint = NSPointToCGPoint(NSPointFromString([_arrayPoint objectAtIndex:1]));//CGPointFromString([_arrayPoint objectAtIndex:0]);
}
-(void)drawLineChart{
    //[self drawBarChart];
    [self initView];
    _updateFlag = YES;
}

//处理数据获取绘图点（数据y轴顶点）
-(NSMutableArray *)disposePointArray:(NSArray *)array
{
    NSMutableArray *points = [NSMutableArray array];
    for (int i = 0; i < array.count; i++) {
        NSString *string = [array objectAtIndex:i];
        
        //CGFloat y = (self.frame.size.height - BELOW) - ([string floatValue]<1?1:[string floatValue] / _yMax * (self.frame.size.height - BELOW - UP));
        //IOS -> MacOS 反转y轴
        CGFloat y = ([string floatValue]<1?BELOW:[string floatValue] / _yMax * (self.frame.size.height - BELOW - UP) + BELOW);
        
        if (y<=0) {
            y = BELOW;
        }
        
        CGPoint point = CGPointMake(LEFT + ((self.frame.size.width - LEFT - RIGHT) / self.NumCount * (i + 1)), y);
        
        [points addObject:NSStringFromPoint(NSPointFromCGPoint(point))];
    }
    return points;
}

// 判断是小数还是整数
- (BOOL)isPureFloat:(CGFloat)num
{
    int i = num;
    
    CGFloat result = num - i;
    
    // 当不等于0时，是小数
    return result != 0;
}

//绘制折线图
-(void)drawOneLineChart
{
    NSBezierPath *path = [NSBezierPath bezierPath];

    //画数据点
    [path appendBezierPathWithArcWithCenter:_startPoint
                                          radius:1.0
                                      startAngle:0
                                        endAngle:2*M_PI
                                       clockwise:YES];
//    if (_number == self.yValueArray.count - 1) {
//        [path appendBezierPathWithArcWithCenter:_endPoint
//            radius:5.0
//        startAngle:0
//          endAngle:2*M_PI
//         clockwise:YES];
//    }

    //绘制折线图
    [path moveToPoint:_startPoint];
    [path lineToPoint:_endPoint];
    path.lineJoinStyle = kCGLineJoinRound;
    
    //显示数据
    NSString *yValue = [_yValueArray objectAtIndex:_number];
    //NSLog(@"%d - %@",_number,yValue);
    //NSLog(@"(%f,%f) - (%f,%f)",_startPoint.x,_startPoint.y,_endPoint.x,_endPoint.y);
    NSTextField *xLabel = [[NSTextField alloc]initWithFrame:CGRectMake(0, 0, 60, 20)];
    xLabel.textColor = [NSColor grayColor];
    [xLabel setBackgroundColor:[NSColor clearColor]];
    [xLabel setBordered:NO];
    [xLabel setEditable:NO];
    xLabel.font = [NSFont systemFontOfSize:7];
    xLabel.alignment = NSTextAlignmentLeft;
    xLabel.stringValue = yValue;
    [xLabel setFrameOrigin:NSMakePoint(_startPoint.x - 10, _startPoint.y - 10)];
    [self addSubview:xLabel];
    //设置layer层
    CAShapeLayer *shaperLayer = [CAShapeLayer layer];
    shaperLayer.path = [self CGPathFromPath:path];//path.CGPath;
    //CGFloat scaleX = (self.frame.size.width - LEFT - RIGHT) / self.NumCount-15;
    shaperLayer.lineWidth = 2.0;
    shaperLayer.strokeColor = self.lineColor.CGColor;
//    if ([yValue floatValue] >= self.yTargetVal) {
//        shaperLayer.strokeColor = [NSColor systemGreenColor].CGColor;
//    }else{
//        shaperLayer.strokeColor = [NSColor systemRedColor].CGColor;
//    }
    //shaperLayer.strokeColor = [NSColor colorWithHexString:@"0x4299fa" andAlpha:1.0].CGColor;
    shaperLayer.fillColor = kPieRandColor.CGColor;
    //shaperLayer.fillColor = [NSColor systemGreenColor].CGColor;
    //设置动画
    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:NSStringFromSelector(@selector(strokeEnd))];
    anim.delegate = self;
    anim.fromValue = @0;
    anim.toValue = @1;
    if (_arrayPoint.count>10)
    {
        anim.duration = 0.05;
    }
    else
    {
        anim.duration = 0.1;
    }
    
    [shaperLayer addAnimation:anim forKey:NSStringFromSelector(@selector(strokeEnd))];
    
    [self.layer addSublayer:shaperLayer];
    
    
}

//绘制柱状图
-(void)drawBarChart
{
    
    
    NSBezierPath *path = [NSBezierPath bezierPath];
    //绘制折线图
    [path moveToPoint:_startPoint];
    [path lineToPoint:_endPoint];
    path.lineJoinStyle = kCGLineJoinRound;
    
    //显示数据
    NSString *yValue = [_yValueArray objectAtIndex:_number];
    NSLog(@"%d - %@",_number,yValue);
    //NSLog(@"(%f,%f) - (%f,%f)",_startPoint.x,_startPoint.y,_endPoint.x,_endPoint.y);
    NSTextField *xLabel = [[NSTextField alloc]initWithFrame:CGRectMake(0, 0, 60, 20)];
    xLabel.textColor = [NSColor grayColor];
    [xLabel setBackgroundColor:[NSColor clearColor]];
    [xLabel setBordered:NO];
    [xLabel setEditable:NO];
    xLabel.font = [NSFont systemFontOfSize:7];
    xLabel.alignment = NSTextAlignmentLeft;
    xLabel.stringValue = yValue;
    [xLabel setFrameOrigin:NSMakePoint(_endPoint.x - 10, _endPoint.y - 10)];
    //xLabel.center = CGPointMake((LEFT + scaleX * i), self.frame.size.height - BELOW / 2);
    [self addSubview:xLabel];
    
    //设置layer层
    CAShapeLayer *shaperLayer = [CAShapeLayer layer];
    shaperLayer.path = [self CGPathFromPath:path];//path.CGPath;
    CGFloat scaleX = (self.frame.size.width - LEFT - RIGHT) / self.NumCount-15;
    shaperLayer.lineWidth = scaleX;
    if ([yValue floatValue] >= self.yTargetVal) {
        shaperLayer.strokeColor = [NSColor systemGreenColor].CGColor;
    }else{
        shaperLayer.strokeColor = [NSColor systemRedColor].CGColor;
    }
    //shaperLayer.strokeColor = [NSColor colorWithHexString:@"0x4299fa" andAlpha:1.0].CGColor;
    shaperLayer.fillColor = kPieRandColor.CGColor;
    //shaperLayer.fillColor = [NSColor systemGreenColor].CGColor;
    //设置动画
    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:NSStringFromSelector(@selector(strokeEnd))];
    anim.delegate = self;
    anim.fromValue = @0;
    anim.toValue = @1;
    if (_arrayPoint.count>10)
    {
        anim.duration = 0.05;
    }
    else
    {
        anim.duration = 0.1;
    }
    
    [shaperLayer addAnimation:anim forKey:NSStringFromSelector(@selector(strokeEnd))];
    
    
    [self.layer addSublayer:shaperLayer];
    
    
}

#pragma mark CAAnimationDelegate 监听动画结束
-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    //NSLog(@"%@ - %hhd",anim, flag);
    
    if (flag) {
        if (_number < self.yValueArray.count - 1) {
            [self drawAction];
        }
        
    }
}

//获取开始、结束点
-(void)drawAction
{
    _number++;
    
    //CGFloat scaleX = (self.frame.size.width - LEFT - RIGHT) / self.NumCount;
    
    //_startPoint = CGPointMake((self.frame.size.width - LEFT - RIGHT) / self.NumCount + LEFT + scaleX * _number, self.frame.size.height - BELOW);
    //IOS -> MacOS 反转Y轴
    //_startPoint = CGPointMake((self.frame.size.width - LEFT - RIGHT) / self.NumCount + LEFT + scaleX * _number, BELOW);
    
    
    NSString *pointStr = [_arrayPoint objectAtIndex:_number];
    _startPoint =NSPointToCGPoint(NSPointFromString(pointStr));
    //最后一次绘制，同一个点
    if (_number == self.yValueArray.count - 1) {
        _endPoint = _startPoint;
    }else{
        pointStr = [_arrayPoint objectAtIndex:_number + 1];
        _endPoint = NSPointToCGPoint(NSPointFromString(pointStr));//CGPointFromString(pointStr);
    }
    
    
    [self.layer setNeedsDisplay];
    
}

-(void)addLabelWithTitle:(NSString *)title point:(NSPoint )point{
    NSTextField *yLabel = [[NSTextField alloc]initWithFrame:CGRectMake(0, 0, 60, 10)];
    yLabel.textColor = [NSColor grayColor];
    [yLabel setBackgroundColor:[NSColor clearColor]];
    [yLabel setBordered:NO];
    [yLabel setEditable:NO];
    [yLabel.cell setWraps:YES];
    yLabel.font = [NSFont systemFontOfSize:8];
    yLabel.alignment = NSTextAlignmentLeft;//NSTextAlignmentCenter;
    yLabel.maximumNumberOfLines = 1;
    yLabel.stringValue = title;
    [yLabel setFrameOrigin:point];
    [self addSubview:yLabel];
}
- (CGMutablePathRef)CGPathFromPath:(NSBezierPath *)path
{
    CGMutablePathRef cgPath = CGPathCreateMutable();
    NSInteger n = [path elementCount];
    
    for (NSInteger i = 0; i < n; i++) {
        NSPoint ps[3];
        switch ([path elementAtIndex:i associatedPoints:ps]) {
            case NSMoveToBezierPathElement: {
                CGPathMoveToPoint(cgPath, NULL, ps[0].x, ps[0].y);
                break;
            }
            case NSLineToBezierPathElement: {
                CGPathAddLineToPoint(cgPath, NULL, ps[0].x, ps[0].y);
                break;
            }
            case NSCurveToBezierPathElement: {
                CGPathAddCurveToPoint(cgPath, NULL, ps[0].x, ps[0].y, ps[1].x, ps[1].y, ps[2].x, ps[2].y);
                break;
            }
            case NSClosePathBezierPathElement: {
                CGPathCloseSubpath(cgPath);
                break;
            }
            default: NSAssert(0, @"Invalid NSBezierPathElement");
        }
    }
    return cgPath;
}

@end
