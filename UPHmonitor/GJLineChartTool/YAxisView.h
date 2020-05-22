//  您好，谢谢您参考我的项目，如果有问题请移步
//  https://github.com/manofit/GJLineChartView


//
//  YAxisView.h
//  GJLineChartView
//
//  Created by gaojun on 2017/9/31.
//  Copyright © 2017年 GJ. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface YAxisView : NSView

- (id)initWithFrame:(CGRect)frame yMax:(CGFloat)yMax yMin:(CGFloat)yMin unit:(NSString*)unit;

@end
