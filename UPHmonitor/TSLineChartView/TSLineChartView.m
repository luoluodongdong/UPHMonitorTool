//
//  TSLineChartView.m
//  UPHmonitor
//
//  Created by WeidongCao on 2020/4/25.
//  Copyright © 2020 WeidongCao. All rights reserved.
//

#import "TSLineChartView.h"

//上下左右边距
#define UP    20.0
#define BELOW 30.0
#define LEFT  30.0
#define RIGHT 10.0

@interface TSLineChartView()
//y轴刻度名称
@property(nonatomic ,strong)NSMutableArray *columnArray;
//折线图开始点
@property(nonatomic ,assign)CGPoint startPoint;
//折线图结束点
@property(nonatomic ,assign)CGPoint endPoint;
@property (nonatomic, strong) XYView *xyView;
//@property (nonatomic, strong) DrawLineView *drawLineView;
@property (nonatomic, strong) NSMutableArray *chartViewArray;

@property (nonatomic, strong) NSView *titleView;

@end

@implementation TSLineChartView


-(id)initWithFrame:(CGRect)frame backgroundcolor:(NSColor *__nullable)bgColor
{
    self = [super initWithFrame:frame];
    if (self) {
        if (bgColor != nil) {
            [self setWantsLayer:YES];
            [self.layer setBackgroundColor:bgColor.CGColor];
        }
        //self.backgroundColor = [UIColor whiteColor];
        

    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    NSLog(@"[TSLineChartView] - drawRect");
    
    if (self.titleView != nil) {
        [self.titleView removeFromSuperview];
        self.titleView = nil;
    }
    self.titleView = [[NSView alloc] initWithFrame:NSMakeRect(0, 0, self.frame.size.width, self.frame.size.height)];
    [self drawTitleAndInfo];
    [self initView];
    [self drawChart];
    // Drawing code here.
}

-(void)drawTitleAndInfo{
    CGContextRef context = [[NSGraphicsContext currentContext] CGContext];
    CGFloat titleX = self.frame.size.width/2 - self.chartTitle.length/2 * 14;
    NSPoint titlePoint = NSMakePoint(titleX, self.frame.size.height - 30);
    [self addLabelWithTitle:self.chartTitle fontSize:16 point:titlePoint alignment:NSTextAlignmentCenter];
    
    CGFloat infoX = self.frame.size.width - 200;
    CGFloat infoY = self.frame.size.height - 40;
    
    int count = 0;
    for (NSDictionary *item in self.sourceDataArray) {
        NSColor *color = [item objectForKey:@"color"];
        NSString *name = [item objectForKey:@"title"];
        if (name == nil) {
            name = @"NO SET";
        }
        [self drawLine:context
            startPoint:NSMakePoint(infoX, infoY - count * 15)
              endPoint:NSMakePoint(infoX + 30, infoY - count * 15)
             lineColor:color
             lineWidth:2.0];
        
        [self addLabelWithTitle:name
                       fontSize:10
                          point:NSMakePoint(infoX + 30 + 2, infoY - count * 15 - 6)
                      alignment:NSTextAlignmentLeft];
        count += 1;
    }
    [self addSubview:self.titleView];
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


-(void)addLabelWithTitle:(NSString *)title fontSize:(CGFloat)size point:(NSPoint )point alignment:(NSTextAlignment)alignment{
    NSTextField *yLabel = [[NSTextField alloc]initWithFrame:CGRectMake(0, 0, title.length * size, size + 2)];
    yLabel.textColor = [NSColor grayColor];
    [yLabel setBackgroundColor:[NSColor clearColor]];
    [yLabel setBordered:NO];
    [yLabel setEditable:NO];
    [yLabel.cell setWraps:YES];
    yLabel.font = [NSFont systemFontOfSize:size];
    yLabel.alignment = alignment;//NSTextAlignmentLeft;//NSTextAlignmentCenter;
    yLabel.maximumNumberOfLines = 1;
    yLabel.stringValue = title;
    [yLabel setFrameOrigin:point];
    [self.titleView addSubview:yLabel];
}

-(void)initView{
    if (self.xyView != nil) {
        [self.xyView removeFromSuperview];
        self.xyView = nil;
    }
    self.xyView = [[XYView alloc] initWithFrame:NSMakeRect(0, 0, self.frame.size.width, self.frame.size.height - 100)];
    self.xyView.scaleArray = self.xTitleArray;
    self.xyView.yMax = self.yMax;
    self.xyView.yMin = self.yMin;
    self.xyView.yTargetVal = self.yTargetVal;
    self.xyView.sectionNum = 4;
    self.xyView.unitStr = self.unitStr;
    [self.xyView initView];
    self.xyView.autoresizingMask = NSViewHeightSizable | NSViewWidthSizable;
    [self addSubview:self.xyView];
        
}

-(void)drawChart{
    [self clearChart];
    self.chartViewArray = [NSMutableArray array];
    for (NSDictionary *data in self.sourceDataArray) {
        NSString *title = [data objectForKey:@"title"];
        NSArray *yValueArray = [data objectForKey:@"data"];
        NSColor *lineColor = [data objectForKey:@"color"];
        DrawLineView *dlv = [[DrawLineView alloc] initWithFrame:NSMakeRect(0, 0, self.frame.size.width, self.frame.size.height - 100)];
        dlv.yValueArray = [NSMutableArray arrayWithArray:yValueArray];
        dlv.yMax = self.yMax;
        dlv.yMin = self.yMin;
        dlv.yTargetVal = 800;
        dlv.lineColor = lineColor;
        dlv.xTitleArray = self.xTitleArray;
        [dlv initView];
        dlv.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
        [self addSubview:dlv];
        [self.chartViewArray addObject:dlv];
        dispatch_async(dispatch_get_main_queue(), ^{
            [dlv drawLineChart];
        });
        
    }

}

-(void)clearChart{
    if (self.chartViewArray != nil) {
        for (DrawLineView *view in self.chartViewArray) {
            [view removeFromSuperview];
        }
    }
    self.chartViewArray = nil;
}

@end
