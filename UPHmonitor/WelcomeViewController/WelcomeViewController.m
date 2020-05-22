//
//  WelcomeViewController.m
//  UPHmonitor
//
//  Created by WeidongCao on 2020/4/27.
//  Copyright © 2020 WeidongCao. All rights reserved.
//

#import "WelcomeViewController.h"

@interface WelcomeViewController ()

@end

@implementation WelcomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self dismissController:self];

    });
}

@end
