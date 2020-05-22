//  您好，谢谢您参考我的项目，如果有问题请移步
//  https://github.com/manofit/GJLineChartView

//
//  GJLineChartView.h
//  GJLineChartView
//
//  Created by gaojun on 2018/2/20.
//  Copyright © 2018年 GJ. All rights reserved.
//

#import "GJChartDrawView.h"
#import "QuartzCore/CAShapeLayer.h"
#import "QuartzCore/CAMediaTimingFunction.h"
//图标上下左右边距
#define UP    20.0
#define BELOW 30.0
#define LEFT  30.0
#define RIGHT 10.0

@implementation GJChartDrawView
{
    //折线图获取数组元素下标
    int     _number;

    //长按显示标注线
    NSView  *_lineView;
    //展示数据label
    NSButton *_dataBtn;
    
    //饼形图需要的变量
    CGFloat _total;
    CAShapeLayer *_bgCircleLayer;
    //记录num
    int    _num;
    
    NSMutableArray *_arrayPoint;
    
}

-(id)initWithFrame:(CGRect)frame type:(DrawViewType)type yMax:(CGFloat)yMax yMin:(CGFloat)yMin
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setWantsLayer:YES];
        [self.layer setBackgroundColor:[NSColor whiteColor].CGColor];
        //self.backgroundColor = [UIColor whiteColor];
        self.columnArray = [NSMutableArray array];
        _drawType = type;
        _yMax     = yMax;
        _yMin     = yMin;
        if (_drawType == BarChart_Type)
        {
//            UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressAction:)];
//            [self addGestureRecognizer:longPressGesture];
        }
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
    [super drawRect:rect];

    if (_drawType != PieChart_Type && _num != 1) {
        
          [self drawScale];
    }
    _num = 1;
    
    switch (_drawType) {

        case PieChart_Type:
        {
            [self pieChartAction];
        }
            break;
        case BarChart_Type:
        {
            [self drawBarChart];
        }
            break;
        default:
            break;
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

//绘制刻度xy
-(void)drawScale
{
    //加单位
    CGFloat avgValue = (self.yMax - self.yMin) / numberOfYAxisElements;
    for (int i = 0; i < numberOfYAxisElements + 1; i++)
    {
        [self.columnArray addObject:[NSString stringWithFormat:@"%.0f", self.yMin + avgValue * i]];
    }
    
    NSString * unit = [NSString stringWithFormat:@"单位(%@)",self.unitStr];
    [self addLabelWithTitle:unit point:NSMakePoint(30, self.frame.size.height - BELOW)];
    //[self.columnArray replaceObjectAtIndex:self.columnArray.count-1 withObject:[NSString stringWithFormat:@"%@\n%@",unit,self.columnArray[self.columnArray.count-1]]];
    
    NSBezierPath *scalePath = [NSBezierPath bezierPath];
    //UIBezierPath *scalePath = [UIBezierPath bezierPath];
    // Y axis
    [scalePath moveToPoint:CGPointMake(30, BELOW)];
    [scalePath lineToPoint:CGPointMake(30, self.frame.size.height - UP)];
    // Y 目标值
    float yValue = _yTargetVal / _yMax * (self.frame.size.height - BELOW - UP);
    [scalePath moveToPoint:CGPointMake(30, yValue)];
    [scalePath lineToPoint:CGPointMake(self.frame.size.width -RIGHT, yValue)];
    [self addLabelWithTitle:[NSString stringWithFormat:@"%lu",_yTargetVal] point:NSMakePoint(30, yValue)];
    // X axis
    //[scalePath moveToPoint:CGPointMake(30, self.frame.size.height - BELOW)];
    //[scalePath lineToPoint:CGPointMake(self.frame.size.width - RIGHT, self.frame.size.height - BELOW)];
    [scalePath moveToPoint:CGPointMake(30, BELOW)];
    [scalePath lineToPoint:CGPointMake(self.frame.size.width -RIGHT, BELOW)];
    //Y轴刻度
    CGFloat scaleY = (self.frame.size.height - UP - BELOW) / (self.columnArray.count-1);
    for (int i = 0; i < self.columnArray.count; i++) {
        [scalePath moveToPoint:CGPointMake(LEFT, (scaleY * i) + BELOW)];
        [scalePath lineToPoint:CGPointMake(LEFT + 2, (scaleY * i) + BELOW)];
        NSTextField *yLabel = [[NSTextField alloc]initWithFrame:CGRectMake(0, 0, 60, 10)];
        yLabel.textColor = [NSColor grayColor];
        [yLabel setBackgroundColor:[NSColor clearColor]];
        [yLabel setBordered:NO];
        [yLabel setEditable:NO];
        [yLabel.cell setWraps:YES];
        yLabel.font = [NSFont systemFontOfSize:8];
        yLabel.alignment = NSTextAlignmentLeft;//NSTextAlignmentCenter;
        yLabel.maximumNumberOfLines = 1;
        yLabel.stringValue = self.columnArray[i];
        [yLabel setFrameOrigin:NSMakePoint(LEFT , (scaleY * i) + BELOW)];
        [self addSubview:yLabel];
    }
    
    // X轴刻度
    CGFloat scaleX = (self.frame.size.width - LEFT - RIGHT) / self.NumCount;
    for (int i = 0; i < self.NumCount; i++) {
        [scalePath moveToPoint:CGPointMake((LEFT + scaleX * i), BELOW)];
        [scalePath lineToPoint:CGPointMake((LEFT + scaleX * i), BELOW - 2)];
        if (i > 0) {
            NSTextField *xLabel = [[NSTextField alloc]initWithFrame:CGRectMake(0, 0, scaleX, 20)];
            xLabel.textColor = [NSColor grayColor];
            [xLabel setBordered:NO];
            [xLabel setEditable:NO];
            if (_drawType == 0)
            {
                xLabel.font = [NSFont systemFontOfSize:10];
            }
            else
            {
                xLabel.font = [NSFont systemFontOfSize:8];
            }
            xLabel.alignment = NSTextAlignmentCenter;
            xLabel.stringValue = [_scaleArray objectAtIndex:i - 1];
            [xLabel setFrameOrigin:NSMakePoint((LEFT + scaleX * i) - 20, BELOW / 2 - 10)];
            //xLabel.center = CGPointMake((LEFT + scaleX * i), self.frame.size.height - BELOW / 2);
            [self addSubview:xLabel];
        }
    }
    
    CAShapeLayer *shaperLayer = [CAShapeLayer layer];
    shaperLayer.path = [self CGPathFromPath:scalePath];//scalePath.CGPath;
    shaperLayer.lineWidth = 1.0;
    shaperLayer.lineCap = kCALineCapRound;
    shaperLayer.lineJoin = kCALineJoinRound;
    shaperLayer.strokeColor = [NSColor grayColor].CGColor;
    [self.layer addSublayer:shaperLayer];
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
    [xLabel setFrameOrigin:NSMakePoint(_endPoint.x - 10, _endPoint.y - 10)];
    
    //xLabel.center = CGPointMake((LEFT + scaleX * i), self.frame.size.height - BELOW / 2);
    [self addSubview:xLabel];
    //设置layer层
    CAShapeLayer *shaperLayer = [CAShapeLayer layer];
    shaperLayer.path = [self CGPathFromPath:path];//path.CGPath;
    CGFloat scaleX = (self.frame.size.width - LEFT - RIGHT) / self.NumCount-15;
    shaperLayer.lineWidth = scaleX;
    if (_endPoint.y >= ((_yTargetVal / _yMax * (self.frame.size.height - BELOW - UP)))) {
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


//绘制饼形图
-(void)pieChartAction
{
    self.hidden = YES;
    [self setWantsLayer:YES];
    [self.layer setBackgroundColor:kPieBackgroundColor.CGColor];
    //self.backgroundColor = kPieBackgroundColor;
    
    //1.pieView中心点
    CGFloat centerWidth = self.frame.size.width * 0.5f;
    CGFloat centerHeight = self.frame.size.height * 0.5f;
    CGFloat centerX = centerWidth;
    CGFloat centerY = centerHeight;
    CGPoint centerPoint = CGPointMake(centerX, centerY);
    CGFloat radiusBasic = centerWidth > centerHeight ? centerHeight : centerWidth;
    
    //计算红绿蓝部分总和
    _total = 0.0f;
    for (int i = 0; i < _arrayPoint.count; i++) {
        _total += [_arrayPoint[i] floatValue];
    }
    
    //线的半径为扇形半径的一半，线宽是扇形半径，这样就能画出圆形了
    //2.背景路径
    CGFloat bgRadius = radiusBasic * 0.5;
//    NSBezierPath *bgPath = [NSBezierPath bezierPathWithArcCenter:centerPoint
//                                                          radius:bgRadius
//                                                      startAngle:-M_PI_2
//                                                        endAngle:M_PI_2 * 3
//                                                       clockwise:YES];
    NSBezierPath *bgPath = [NSBezierPath bezierPath];
    [bgPath appendBezierPathWithArcWithCenter:centerPoint
                                          radius:bgRadius
                                      startAngle:-M_PI_2
                                        endAngle:M_PI_2 * 3
                                       clockwise:YES];
    _bgCircleLayer = [CAShapeLayer layer];
    _bgCircleLayer.fillColor   = [NSColor clearColor].CGColor;
    _bgCircleLayer.strokeColor = [NSColor lightGrayColor].CGColor;
    _bgCircleLayer.strokeStart = 0.0f;
    _bgCircleLayer.strokeEnd   = 1.0f;
    _bgCircleLayer.zPosition   = 1;
    _bgCircleLayer.lineWidth   = bgRadius * 2.0f;
    _bgCircleLayer.path        = [self CGPathFromPath:bgPath];//bgPath.CGPath;
    
    //3.子扇区路径
    CGFloat otherRadius = radiusBasic * 0.5 - 3.0;
//    UIBezierPath *otherPath = [UIBezierPath bezierPathWithArcCenter:centerPoint
//                                                             radius:otherRadius
//                                                         startAngle:-M_PI_2
//                                                           endAngle:M_PI_2 * 3
//                                                          clockwise:YES];
    NSBezierPath *otherPath = [NSBezierPath bezierPath];
    [otherPath appendBezierPathWithArcWithCenter:centerPoint
                                          radius:otherRadius
                                      startAngle:-M_PI_2
                                        endAngle:M_PI_2 * 3
                                       clockwise:YES];
    CGFloat start = 0.0f;
    CGFloat end = 0.0f;
    for (int i = 0; i < _arrayPoint.count; i++) {
        //4.计算当前end位置 = 上一个结束位置 + 当前部分百分比
        end = [_arrayPoint[i] floatValue] / _total + start;
        
        //图层
        CAShapeLayer *pie = [CAShapeLayer layer];
        [self.layer addSublayer:pie];
        pie.fillColor   = kPieFillColor;
        if (i > _colorItems.count - 1 || !_colorItems  || _colorItems.count == 0) {//如果传过来的颜色数组少于item个数则随机填充颜色
            pie.strokeColor = kPieRandColor.CGColor;
        } else {
            pie.strokeColor = ((NSColor *)_colorItems[i]).CGColor;
        }
        pie.strokeStart = start;
        pie.strokeEnd   = end;
        pie.lineWidth   = otherRadius * 2.0f;
        pie.zPosition   = 2;
        pie.path        = [self CGPathFromPath:otherPath];//otherPath.CGPath;
        
        //计算百分比label的位置
        CGFloat centerAngle = M_PI * (start + end);
        CGFloat labelCenterX = kLabelLoctionRatio * sinf(centerAngle) + centerX;
        CGFloat labelCenterY = -kLabelLoctionRatio * cosf(centerAngle) + centerY;
        NSTextField *label = [[NSTextField alloc] initWithFrame:CGRectMake(0, 0, radiusBasic * 0.7f, radiusBasic * 0.7f)];
        //label.center = CGPointMake(labelCenterX, labelCenterY);
        label.stringValue = [NSString stringWithFormat:@"%ld%%",(long)((end - start + 0.005) * 100)];
        label.alignment = NSTextAlignmentCenter;
        label.textColor = [NSColor whiteColor];
        label.layer.zPosition = 3;
        [self addSubview:label];
        //计算下一个start位置 = 当前end位置
        start = end;
    }
    self.layer.mask = _bgCircleLayer;
    [self stroke];
}

//绘制动画（饼形图）
- (void)stroke
{
    //画图动画
    self.hidden = NO;
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation.duration  = kAnimationDuration;
    animation.fromValue = @0.0f;
    animation.toValue   = @1.0f;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.removedOnCompletion = YES;
    [_bgCircleLayer addAnimation:animation forKey:@"circleAnimation"];
}

#pragma mark CAAnimationDelegate 监听动画结束
-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if (_drawType == BarChart_Type){
        if (flag) {
            [self drawAction];
        }
    }
}
//重写set方法，图标数据信息信息
-(void)setYValueArray:(NSMutableArray *)yValueArray
{
    self.NumCount = yValueArray.count + 1;
    _yValueArray = yValueArray;
    if (!_arrayPoint) {
        _arrayPoint = [NSMutableArray array];
    }
    //饼状图
    if (_drawType == PieChart_Type)
    {
        [_arrayPoint addObjectsFromArray:[self disposePointArray:yValueArray]];
        [self.layer setNeedsDisplay];
    }
    //柱状图
    else
    {
        [_arrayPoint addObjectsFromArray:[self disposePointArray:yValueArray]];
        
        //_startPoint = CGPointMake((self.frame.size.width - LEFT - RIGHT) / self.NumCount + LEFT, self.frame.size.height - BELOW);
        //IOS -> MacOS 反转y轴
        _startPoint = CGPointMake((self.frame.size.width - LEFT - RIGHT) / self.NumCount + LEFT, BELOW);
        _endPoint = NSPointToCGPoint(NSPointFromString([_arrayPoint objectAtIndex:0]));//CGPointFromString([_arrayPoint objectAtIndex:0]);
        [self.layer setNeedsDisplay];
    }
}

//处理数据获取绘图点（数据y轴顶点）
-(NSMutableArray *)disposePointArray:(NSArray *)array
{
    //饼状图
    if (_drawType == PieChart_Type) {
        NSMutableArray *points = [NSMutableArray array];
        CGFloat allFloat = 0.0;
        for (NSString *string in array) {
            allFloat = allFloat + [string floatValue];
        }
        for (NSString *string in array) {
            CGFloat f = [string floatValue] / allFloat;
            [points addObject:[NSString stringWithFormat:@"%.2f",f]];
        }
        return points;
    }
    //柱状图
    else
    {
        NSMutableArray *points = [NSMutableArray array];
        for (int i = 0; i < array.count; i++) {
            NSString *string = [array objectAtIndex:i];
            
            //CGFloat y = (self.frame.size.height - BELOW) - ([string floatValue]<1?1:[string floatValue] / _yMax * (self.frame.size.height - BELOW - UP));
            //IOS -> MacOS 反转y轴
            CGFloat y = ([string floatValue]<1?BELOW:[string floatValue] / _yMax * (self.frame.size.height - BELOW - UP));
            
            if (y<=0) {
                y = BELOW;
            }
            
            CGPoint point = CGPointMake(LEFT + ((self.frame.size.width - LEFT - RIGHT) / self.NumCount * (i + 1)), y);
            
            [points addObject:NSStringFromPoint(NSPointFromCGPoint(point))];
        }
        return points;
    }
}

//获取开始、结束点
-(void)drawAction
{
    _number++;
    
    if (_drawType == BarChart_Type)
    {
        if (_number < _arrayPoint.count)
        {
            CGFloat scaleX = (self.frame.size.width - LEFT - RIGHT) / self.NumCount;
            
            //_startPoint = CGPointMake((self.frame.size.width - LEFT - RIGHT) / self.NumCount + LEFT + scaleX * _number, self.frame.size.height - BELOW);
            //IOS -> MacOS 反转Y轴
            _startPoint = CGPointMake((self.frame.size.width - LEFT - RIGHT) / self.NumCount + LEFT + scaleX * _number, BELOW);
            
            NSString *pointStr = [_arrayPoint objectAtIndex:_number];
            
            _endPoint = NSPointToCGPoint(NSPointFromString(pointStr));//CGPointFromString(pointStr);
            
            [self.layer setNeedsDisplay];
        }
    }
    
}

//折线图长按手势响应事件
//-(void)longPressAction:(UILongPressGestureRecognizer *)sender
//{
//    if (sender.state != UIGestureRecognizerStateEnded)
//    {
//        if (_dataBtn)
//        {
//            [_dataBtn removeFromSuperview];
//            _dataBtn = nil;
//        }
//        CGPoint longPoint = [sender locationInView:self];
//
//        if (!_lineView)
//        {
//            _lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 1)];
//            _lineView.backgroundColor = [UIColor colorWithRed:0.11 green:0.75 blue:0.29 alpha:1.00];
//            _lineView.center = CGPointMake(self.frame.size.width/2, longPoint.y);
//            [self addSubview:_lineView];
//        }
//        else
//        {
//            _lineView.center = CGPointMake(self.frame.size.width/2, longPoint.y);
//        }
//        for (NSString *pointStr in _arrayPoint)
//        {
//            CGPoint selectPoint = CGPointFromString(pointStr);
//
//            if (longPoint.y < selectPoint.y + 2 && longPoint.y > selectPoint.y - 2) {
//                _lineView.center = CGPointMake(self.frame.size.width/2, selectPoint.y);
//                [self createShowDataLabel:selectPoint];
//            }
//        }
//    }
//    else
//    {
//        if (_lineView) {
//            [_lineView removeFromSuperview];
//            _lineView = nil;
//        }
//        if (_dataBtn) {
//            [_dataBtn removeFromSuperview];
//            _dataBtn = nil;
//        }
//    }
//}
//创建折线图显示数据

-(void)createShowDataLabel:(CGPoint)point
{
    if (!_dataBtn) {
        _dataBtn = [[NSButton alloc]initWithFrame:CGRectMake(0, 0, 15, 15)];
        _dataBtn.font = [NSFont boldSystemFontOfSize:10];
        _dataBtn.alignment = NSTextAlignmentCenter;
        //[_dataBtn setBackgroundImage: [NSImage imageNamed:@"qipao"] forState:UIControlStateNormal];
        [_dataBtn setImage:[NSImage imageNamed:@"qipao"]];
        //[_dataBtn setTitleColor:[NSColor colorWithRed:0.11 green:0.75 blue:0.29 alpha:1.00] forState:UIControlStateNormal];
        //[_dataBtn setContentTintColor:[NSColor colorWithRed:0.11 green:0.75 blue:0.29 alpha:1.00]];
        int y = ((self.frame.size.height - BELOW) - point.y) / (self.frame.size.height - BELOW - UP) * _yMax;
        [_dataBtn setTitle:[NSString stringWithFormat:@"%d",y]];
        CGSize size = [self labelText:_dataBtn.title fondSize:20 width:self.frame.size.width];
        _dataBtn.frame = CGRectMake(0, 0, size.width, size.height);
        //_dataBtn.center = CGPointMake(point.x, point.y - size.height/2);
        [self addSubview:_dataBtn];
        [self addSubview:_dataBtn positioned:NSWindowAbove relativeTo:[self.subviews objectAtIndex:0]];
        //[self bringSubviewToFront:_dataBtn];
    }
}


-(CGSize)labelText:(NSString *)text fondSize:(float)size width:(CGFloat)width
{
    NSDictionary *send = @{NSFontAttributeName: [NSFont systemFontOfSize:size]};
    CGSize textSize = [text boundingRectWithSize:CGSizeMake(width, 0)
                                         options:NSStringDrawingTruncatesLastVisibleLine |
                       NSStringDrawingUsesLineFragmentOrigin |
                       NSStringDrawingUsesFontLeading
                                      attributes:send context:nil].size;
    
    return textSize;
}

@end
