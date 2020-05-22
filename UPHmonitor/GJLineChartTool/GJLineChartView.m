//  您好，谢谢您参考我的项目，如果有问题请移步
//  https://github.com/manofit/GJLineChartView

//
//  GJLineChartView.m
//  GJLineChartView
//
//  Created by gaojun on 2017/9/31.
//  Copyright © 2017年 GJ. All rights reserved.
//

#import "GJLineChartView.h"
#import "XAxisView.h"
#import "YAxisView.h"

#define leftMargin 35
#define lastSpace 50

@interface GJLineChartView ()

@property (strong, nonatomic) NSArray *xTitleArray;
@property (strong, nonatomic) NSArray *yValueArray;
@property (assign, nonatomic) CGFloat yMax;
@property (assign, nonatomic) CGFloat yMin;
@property (assign, nonatomic) CGFloat yTargetVal;
@property (strong, nonatomic) YAxisView *yAxisView;
@property (strong, nonatomic) XAxisView *xAxisView;
@property (strong, nonatomic) NSScrollView *scrollView;
@property (assign, nonatomic) CGFloat pointGap;
@property (assign, nonatomic) CGFloat defaultSpace;//间距
@property (strong, nonatomic) NSString *unit;
@property (assign, nonatomic) CGFloat moveDistance;

@end

@implementation GJLineChartView

- (id)initWithFrame:(CGRect)frame xTitleArray:(NSArray*)xTitleArray yValueArray:(NSArray*)yValueArray yMax:(CGFloat)yMax yMin:(CGFloat)yMin yTargetValu:(CGFloat)targetVal unit:(NSString*)unit {
    
    self = [super initWithFrame:frame];
    if (self) {
        [self setWantsLayer:YES];
        [self.layer setBackgroundColor:[NSColor clearColor].CGColor];
        //self.backgroundColor = [UIColor clearColor];
        
        self.xTitleArray = xTitleArray;
        self.yValueArray = yValueArray;
        self.yMax = yMax;
        self.yMin = yMin;
        self.yTargetVal = targetVal;
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
        
        [self creatXAxisView];
        [self creatYAxisView];
        
//        // 2. 捏合手势
//        UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchGesture:)];
//        [self.xAxisView addGestureRecognizer:pinch];
//
//        //长按手势
//        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(event_longPressAction:)];
//        [self.xAxisView addGestureRecognizer:longPress];
    }
    return self;
}



- (void)creatYAxisView {
    
    self.yAxisView = [[YAxisView alloc]initWithFrame:CGRectMake(0, 0, leftMargin + 10, self.frame.size.height) yMax:self.yMax yMin:self.yMin unit:self.unit];
    [self addSubview:self.yAxisView];
    
}

- (void)creatXAxisView {
    
//    _scrollView = [[NSScrollView alloc]initWithFrame:CGRectMake(leftMargin, 0, self.frame.size.width, self.frame.size.height)];
//    [_scrollView setHasHorizontalScroller:NO];
    //_scrollView.showsHorizontalScrollIndicator = NO;
    //_scrollView.bounces = NO;
//    [self addSubview:_scrollView];
    
    self.xAxisView = [[XAxisView alloc] initWithFrame:CGRectMake(0, 0, self.xTitleArray.count * self.pointGap + lastSpace, self.frame.size.height) xTitleArray:self.xTitleArray yValueArray:self.yValueArray yMax:self.yMax yMin:self.yMin unit:self.unit];
    self.xAxisView.yTargetVal = self.yTargetVal;
    [self addSubview:self.xAxisView];
//    [_scrollView addSubview:self.xAxisView];
//    [_scrollView.contentView setFrameSize:self.xAxisView.frame.size];
    //_scrollView.contentSize = self.xAxisView.frame.size;
    
}


// 捏合手势监听方法
//- (void)pinchGesture:(UIPinchGestureRecognizer *)recognizer
//{
//    if (recognizer.state == 3) {
//
//        if (self.xAxisView.frame.size.width-lastSpace <= self.scrollView.frame.size.width) { //当缩小到小于屏幕宽时，松开回复屏幕宽度
//
//            CGFloat scale = self.scrollView.frame.size.width / (self.xAxisView.frame.size.width-lastSpace);
//
//            self.pointGap *= scale;
//
//            [UIView animateWithDuration:0.25 animations:^{
//
//                CGRect frame = self.xAxisView.frame;
//                frame.size.width = self.scrollView.frame.size.width+lastSpace;
//                self.xAxisView.frame = frame;
//            }];
//
//            self.xAxisView.pointGap = self.pointGap;
//
//        }else if (self.xAxisView.frame.size.width-lastSpace >= self.xTitleArray.count * _defaultSpace){
//
//            [UIView animateWithDuration:0.25 animations:^{
//                CGRect frame = self.xAxisView.frame;
//                frame.size.width = self.xTitleArray.count * _defaultSpace + lastSpace;
//                self.xAxisView.frame = frame;
//
//            }];
//
//            self.pointGap = _defaultSpace;
//
//            self.xAxisView.pointGap = self.pointGap;
//        }
//    }else{
//
//        CGFloat currentIndex,leftMagin;
//        if( recognizer.numberOfTouches == 2 ) {
//            //2.获取捏合中心点 -> 捏合中心点距离scrollviewcontent左侧的距离
//            CGPoint p1 = [recognizer locationOfTouch:0 inView:self.xAxisView];
//            CGPoint p2 = [recognizer locationOfTouch:1 inView:self.xAxisView];
//            CGFloat centerX = (p1.x+p2.x)/2;
//            leftMagin = centerX - self.scrollView.contentOffset.x;
//            //            NSLog(@"centerX = %f",centerX);
//            //            NSLog(@"self.scrollView.contentOffset.x = %f",self.scrollView.contentOffset.x);
//            //            NSLog(@"leftMagin = %f",leftMagin);
//
//
//            currentIndex = centerX / self.pointGap;
//            //            NSLog(@"currentIndex = %f",currentIndex);
//
//
//
//            self.pointGap *= recognizer.scale;
//            self.pointGap = self.pointGap > _defaultSpace ? _defaultSpace : self.pointGap;
//            if (self.pointGap == _defaultSpace) {
//
//                NSLog(@"已经放至最大");
//            }
//            self.xAxisView.pointGap = self.pointGap;
//            recognizer.scale = 1.0;
//
//            self.xAxisView.frame = CGRectMake(0, 0, self.xTitleArray.count * self.pointGap + lastSpace, self.frame.size.height);
//
//            self.scrollView.contentOffset = CGPointMake(currentIndex*self.pointGap-leftMagin, 0);
//            //            NSLog(@"contentOffset = %f",self.scrollView.contentOffset.x);
//
//        }
//    }
//
//    self.scrollView.contentSize = CGSizeMake(self.xAxisView.frame.size.width, 0);
//}


//- (void)event_longPressAction:(UILongPressGestureRecognizer *)longPress {
//
//    if(UIGestureRecognizerStateChanged == longPress.state || UIGestureRecognizerStateBegan == longPress.state) {
//
//        CGPoint location = [longPress locationInView:self.xAxisView];
//
//        //相对于屏幕的位置
//        CGPoint screenLoc = CGPointMake(location.x - self.scrollView.contentOffset.x , location.y);
//        [self.xAxisView setScreenLoc:screenLoc];
//
//        if (ABS(location.x - _moveDistance) > self.pointGap) { //不能长按移动一点点就重新绘图  要让定位的点改变了再重新绘图
//
//            [self.xAxisView setIsShowLabel:YES];
//            [self.xAxisView setIsLongPress:YES];
//            self.xAxisView.currentLoc = location;
//            _moveDistance = location.x;
//        }
//    }
//
//    if(longPress.state == UIGestureRecognizerStateEnded)
//    {
//        _moveDistance = 0;
//        //恢复scrollView的滑动
//        [self.xAxisView setIsLongPress:NO];
//        [self.xAxisView setIsShowLabel:NO];
//
//    }
//}

@end