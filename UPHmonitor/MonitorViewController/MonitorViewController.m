//
//  MonitorViewController.m
//  UPHmonitor
//
//  Created by WeidongCao on 2020/4/25.
//  Copyright © 2020 WeidongCao. All rights reserved.
//

#import "MonitorViewController.h"

@interface MonitorViewController ()
@property TSLineChartView *tslcv;
@property NSMutableArray *sourceDataArray;
@end

@implementation MonitorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.

    [self drawTestTSLineChart];
}
-(IBAction)testBtnAction:(id)sender{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        //[self.tslcv clearChart];
        self.tslcv.sourceDataArray = [self getSourceDataArray];
        [self.tslcv drawChart];
    });
}

-(void)drawTestTSLineChart{
    self.tslcv = [[TSLineChartView alloc] initWithFrame:NSMakeRect(10, 100, 960, 500) backgroundcolor:nil];
    self.tslcv.chartTitle = @"L HSG UPH Daliy Monitor";
    self.tslcv.sourceDataArray = [self getSourceDataArray];
    self.tslcv.xTitleArray = [self getXaxisTitles];
    self.tslcv.unitStr = @"pcs";
    self.tslcv.yMax = 1000;
    self.tslcv.yMin = 0;
    self.tslcv.yTargetVal = 800;
    self.tslcv.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
    [self.view addSubview:self.tslcv];

}
-(NSMutableArray *)getSourceDataArray{
    self.sourceDataArray = [NSMutableArray array];
    NSDictionary *data = @{
        @"title":@"PCBA Input",
        @"data":[self getRandValues],
        @"color":[NSColor systemBlueColor]
    };
    [self.sourceDataArray addObject:data];
    data = @{
        @"title":@"H18 Linklabel",
        @"data":[self getRandValues],
        @"color":[NSColor systemPinkColor]
    };
    [self.sourceDataArray addObject:data];
    data = @{
        @"title":@"L-V14",
        @"data":[self getRandValues],
        @"color":[NSColor systemOrangeColor]
    };
    [self.sourceDataArray addObject:data];
    data = @{
        @"title":@"L-Packing",
        @"data":[self getRandValues],
        @"color":[NSColor systemBrownColor]
    };
    [self.sourceDataArray addObject:data];
    return self.sourceDataArray;
}
-(NSMutableArray *)getXaxisTitles{
    NSMutableArray *xTitleArray = [NSMutableArray array];
    for (int i=0; i<24; i++) {
        
        if (i<9) {
            [xTitleArray addObject:[NSString stringWithFormat:@"0%d:00",i+1]];
        }else{
            [xTitleArray addObject:[NSString stringWithFormat:@"%d:00",i+1]];
        }
    }
    return xTitleArray;
}
-(NSMutableArray *)getRandValues{
    NSMutableArray *yValueArray = [NSMutableArray array];
    for (int i = 0; i<20; i++) {
        int value = 700 + arc4random_uniform(250);

        if (i==10) {
            [yValueArray addObject:[NSString stringWithFormat:@"%d",800]];
        }else{
            [yValueArray addObject:[NSString stringWithFormat:@"%d",value]];
        }
        
    }
    return yValueArray;
}
@end
