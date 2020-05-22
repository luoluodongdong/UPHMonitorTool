//
//  ContainerViewController.m
//  UPHmonitor
//
//  Created by WeidongCao on 2020/4/26.
//  Copyright © 2020 WeidongCao. All rights reserved.
//

#import "ContainerViewController.h"

@interface ContainerViewController ()
@property (nonatomic, retain) WelcomeViewController *welcomeVC;
@property (nonatomic, retain) MonitorViewController *monitorVC;
@property (nonatomic, retain) NSViewController *currentVC;
@end

@implementation ContainerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    self.currentVC = nil;
    self.welcomeVC = [[WelcomeViewController alloc] init];
    self.welcomeVC.view.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
    [self switchToWelcomeView];
    self.monitorVC = [[MonitorViewController alloc] init];
    self.monitorVC.view.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self switchToMonitorView];

    });
}

-(void)switchToMonitorView{
    if (self.currentVC != nil) {
        [self.currentVC.view removeFromSuperview];
        [self.currentVC removeFromParentViewController];
    }
    [self.view addSubview:self.monitorVC.view];
    [self addChildViewController:self.monitorVC];
    self.currentVC = self.monitorVC;
}
-(void)switchToWelcomeView{
    
    if (self.currentVC != nil) {
        [self.currentVC.view removeFromSuperview];
        [self.currentVC removeFromParentViewController];
    }
    [self.view addSubview:self.welcomeVC.view];
    [self addChildViewController:self.welcomeVC];
    self.currentVC = self.welcomeVC;
}

@end
