//
//  MonitorViewController.h
//  UPHmonitor
//
//  Created by WeidongCao on 2020/4/25.
//  Copyright © 2020 WeidongCao. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "TSLineChartView.h"

NS_ASSUME_NONNULL_BEGIN

@interface MonitorViewController : NSViewController
{
    IBOutlet NSButton *testBtn;
}

-(IBAction)testBtnAction:(id)sender;

@end

NS_ASSUME_NONNULL_END
