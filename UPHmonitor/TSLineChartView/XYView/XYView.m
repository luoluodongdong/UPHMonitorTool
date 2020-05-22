//
//  XYView.m
//  UPHmonitor
//
//  Created by WeidongCao on 2020/4/26.
//  Copyright © 2020 WeidongCao. All rights reserved.
//

#import "XYView.h"
#import "QuartzCore/CAShapeLayer.h"

//图标上下左右边距
#define UP    20.0
#define BELOW 30.0
#define LEFT  30.0
#define RIGHT 10.0

@interface XYView()
//y轴刻度名称
@property(nonatomic ,strong)NSMutableArray *columnArray;
//count
@property(nonatomic ,assign)NSInteger NumCount;
@end

@implementation XYView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}
-(void)viewWillDraw{
    [self drawScale];
}
-(void)initView{
    self.columnArray = [NSMutableArray array];
    self.NumCount = self.scaleArray.count + 1;
    
}

//绘制刻度xy
-(void)drawScale
{
    NSLog(@"[XYView] - drawScale");
    //Y轴刻度
    CGFloat avgValue = (self.yMax - self.yMin) / self.sectionNum;
    for (int i = 0; i < self.sectionNum + 1; i++)
    {
        [self.columnArray addObject:[NSString stringWithFormat:@"%.00f", self.yMin + avgValue * i]];
    }
    
    NSString * unit = [NSString stringWithFormat:@"单位(%@)",self.unitStr];
    [self addLabelWithTitle:unit point:NSMakePoint(20, self.frame.size.height - BELOW + 20)];
    //[self.columnArray replaceObjectAtIndex:self.columnArray.count-1 withObject:[NSString stringWithFormat:@"%@\n%@",unit,self.columnArray[self.columnArray.count-1]]];
    
    NSBezierPath *scalePath = [NSBezierPath bezierPath];
    //UIBezierPath *scalePath = [UIBezierPath bezierPath];
    // Y axis
    [scalePath moveToPoint:CGPointMake(30, BELOW)];
    [scalePath lineToPoint:CGPointMake(30, self.frame.size.height - UP)];
    // Y 目标值
    //float yValue = self.yTargetVal / _yMax * (self.frame.size.height - BELOW - UP);
    float yValue = (self.frame.size.height - BELOW - UP)/(self.yMax - self.yMin) * self.yTargetVal;
//    [scalePath moveToPoint:CGPointMake(30, yValue + BELOW)];
//    [scalePath setLineWidth:2.0];
//    [scalePath lineToPoint:CGPointMake(self.frame.size.width -RIGHT, yValue + BELOW)];
    [self addLabelWithTitle:[NSString stringWithFormat:@"%.00f",self.yTargetVal] point:NSMakePoint(LEFT + 2, yValue + BELOW)];
//    [self addStraightLine:[NSColor systemGreenColor]
//                    start:NSMakePoint(30, yValue + BELOW - 100)
//                      end:NSMakePoint(self.frame.size.width -RIGHT, yValue + BELOW - 100)
//                    width:1.0];
    [self addStraightAndImaginaryLine:[NSColor systemGreenColor]
                                start:NSMakePoint(30, yValue + BELOW)
                                  end:NSMakePoint(self.frame.size.width -RIGHT, yValue + BELOW)
                                width:1.0
                        segmentLength:7
                                  gap:3];
    // X axis
    //[scalePath moveToPoint:CGPointMake(30, self.frame.size.height - BELOW)];
    //[scalePath lineToPoint:CGPointMake(self.frame.size.width - RIGHT, self.frame.size.height - BELOW)];
    [scalePath moveToPoint:CGPointMake(30, BELOW)];
    [scalePath lineToPoint:CGPointMake(self.frame.size.width -RIGHT, BELOW)];
    //Y轴刻度
    CGFloat scaleY = (self.frame.size.height - BELOW - UP)/(self.yMax - self.yMin);
    for (int i = 0; i < self.columnArray.count; i++) {
        CGFloat yValue = [[self.columnArray objectAtIndex:i] floatValue];
        [scalePath moveToPoint:CGPointMake(LEFT, scaleY * yValue + BELOW)];
        [scalePath lineToPoint:CGPointMake(LEFT + 2, scaleY * yValue + BELOW)];
        NSTextField *yLabel = [[NSTextField alloc]initWithFrame:CGRectMake(0, 0, 30, 10)];
        yLabel.textColor = [NSColor grayColor];
        [yLabel setBackgroundColor:[NSColor clearColor]];
        [yLabel setBordered:NO];
        [yLabel setEditable:NO];
        [yLabel.cell setWraps:YES];
        yLabel.font = [NSFont systemFontOfSize:10];
        yLabel.alignment = NSTextAlignmentRight;//NSTextAlignmentCenter;
        yLabel.maximumNumberOfLines = 1;
        yLabel.stringValue = self.columnArray[i];
        [yLabel setFrameOrigin:NSMakePoint(0, scaleY * yValue + BELOW - 2)];
        [self addSubview:yLabel];
    }
    
    // X轴刻度
    CGFloat scaleX = (self.frame.size.width - LEFT - RIGHT) / self.NumCount;
    for (int i = 0; i < self.NumCount; i++) {
        [scalePath moveToPoint:CGPointMake((LEFT + scaleX * i), BELOW)];
        [scalePath lineToPoint:CGPointMake((LEFT + scaleX * i), BELOW + 2)];
        if (i > 0) {
            NSTextField *xLabel = [[NSTextField alloc]initWithFrame:CGRectMake(0, 0, scaleX+5, 20)];
            xLabel.textColor = [NSColor grayColor];
            [xLabel setBordered:NO];
            [xLabel setEditable:NO];
            [xLabel setBackgroundColor:[NSColor clearColor]];
            xLabel.font = [NSFont systemFontOfSize:10];
            xLabel.alignment = NSTextAlignmentLeft;
            xLabel.stringValue = [_scaleArray objectAtIndex:i - 1];
            [xLabel setFrameOrigin:NSMakePoint((LEFT + scaleX * i) - 15, BELOW / 2 - 10)];
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
/**  画直线  */
-(void)addStraightLine:(NSColor *)color start:(NSPoint)start end:(NSPoint)end width:(CGFloat)width{
    CAShapeLayer *lineLayer = [CAShapeLayer layer];
    NSBezierPath *mdotteShapePath = [NSBezierPath bezierPath];

    lineLayer.fillColor = [NSColor clearColor].CGColor;//填充色
    lineLayer.strokeColor = color.CGColor;//线颜色
    lineLayer.lineWidth = width;
    [mdotteShapePath moveToPoint:start];
    [mdotteShapePath lineToPoint:end];
    lineLayer.path = [self CGPathFromPath:mdotteShapePath];
    [self.layer addSublayer:lineLayer];
}
/**  画直虚线  */
-(void)addStraightAndImaginaryLine:(NSColor *)color start:(NSPoint)start end:(NSPoint)end width:(CGFloat)width segmentLength:(NSUInteger)length gap:(NSUInteger)gap{
    CAShapeLayer *dotteShapLayer = [CAShapeLayer layer];
    NSBezierPath *mdotteShapePath = [NSBezierPath bezierPath];
    dotteShapLayer.fillColor = [NSColor clearColor].CGColor;//填充色
    dotteShapLayer.strokeColor = color.CGColor;//线颜色
    dotteShapLayer.lineWidth = width;//限宽
    [mdotteShapePath moveToPoint:start];
    [mdotteShapePath lineToPoint:end];
    dotteShapLayer.path = [self CGPathFromPath:mdotteShapePath];
    dotteShapLayer.lineDashPhase = 1;
    dotteShapLayer.lineDashPattern = @[@(length),@(gap)];//第一个为线条长度，第二个为线条间间隔
    [self.layer addSublayer:dotteShapLayer];
}

-(void)addLabelWithTitle:(NSString *)title point:(NSPoint )point{
    NSTextField *yLabel = [[NSTextField alloc]initWithFrame:CGRectMake(0, 0, 60, 12)];
    yLabel.textColor = [NSColor grayColor];
    [yLabel setBackgroundColor:[NSColor clearColor]];
    [yLabel setBordered:NO];
    [yLabel setEditable:NO];
    [yLabel.cell setWraps:YES];
    yLabel.font = [NSFont systemFontOfSize:10];
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
