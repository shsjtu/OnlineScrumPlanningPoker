//
//  HostToMeetingRoomSegue.m
//  OnlineScrumPlanningPoker
//
//  Created by SunHan on 4/26/15.
//  Copyright (c) 2015 SunHan. All rights reserved.
//

#import "GuestToMeetingRoomSegue.h"

@implementation GuestToMeetingRoomSegue

-(void)perform {
    UIViewController *sourceViewController = (UIViewController*)[self sourceViewController];
    UIViewController *destinationController = (UIViewController*)[self destinationViewController];
    UINavigationController *navigationController = sourceViewController.navigationController;
    // Pop to root view controller (not animated) before pushing
    [navigationController popToRootViewControllerAnimated:NO];
    [navigationController pushViewController:destinationController animated:YES];
}

@end
