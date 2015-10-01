//
//  OSRootNavigationController.m
//  OnlineScrumPlanningPoker
//
//  Created by SunHan on 4/12/15.
//  Copyright (c) 2015 SunHan. All rights reserved.
//

#import "OSRootNavigationController.h"

@implementation OSRootNavigationController

- (BOOL)shouldAutorotate {
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskPortraitUpsideDown;
}

@end
