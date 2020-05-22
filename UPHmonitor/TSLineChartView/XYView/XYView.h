//
//  XYView.h
//  UPHmonitor
//
//  Created by WeidongCao on 2020/4/26.
//  Copyright © 2020 WeidongCao. All rights reserved.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface XYView : NSView

//x轴刻度名称
@property(nonatomic ,strong)NSArray *scaleArray;
//最大范围
@property(nonatomic ,assign)float yMax;
//最小范围
@property(nonatomic ,assign)float yMin;

//Y轴分几段
@property(nonatomic ,assign)int sectionNum;
//单位
@property(nonatomic ,strong)NSString *unitStr;
//柱状图y轴目标值
@property(nonatomic ,assign)float yTargetVal;

-(void)initView;

@end

NS_ASSUME_NONNULL_END
