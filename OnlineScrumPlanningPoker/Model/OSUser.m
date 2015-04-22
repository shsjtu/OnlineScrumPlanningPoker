//
//  OSUser.m
//  OnlineScrumPlanningPoker
//
//  Created by SunHan on 4/13/15.
//  Copyright (c) 2015 SunHan. All rights reserved.
//

#import "OSUser.h"

@implementation OSUser

- (void)startMeeting {
    NSAssert(NO, @"Subclasses need to overwrite this method");
}
- (NSString*)hostName {
    NSAssert(NO, @"Subclasses need to overwrite this method");
    return nil;
}
@end
