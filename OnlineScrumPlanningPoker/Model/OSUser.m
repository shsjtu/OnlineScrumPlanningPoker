//
//  OSUser.m
//  OnlineScrumPlanningPoker
//
//  Created by SunHan on 4/13/15.
//  Copyright (c) 2015 SunHan. All rights reserved.
//

#import "OSUser.h"
#import "OSUserRepresentative.h"

@implementation OSUser

-(instancetype)init {
    if (self == [super init]) {
        self.selfRepresentative = [[OSUserRepresentative alloc] init];
    }
    return self;
}

- (void)startMeeting {
    NSAssert(NO, @"Subclasses need to overwrite this method");
}

- (void)exitMeeting {
    NSAssert(NO, @"Subclasses need to overwrite this method");
}

- (NSString*)meetingHostName {
    NSAssert(NO, @"Subclasses need to overwrite this method");
    return nil;
}

- (NSInteger)numberOfMembers {
    NSAssert(NO, @"Subclasses need to overwrite this method");
    return 0;
}

- (OSUserRepresentative*)memberAtIndex:(NSInteger)index {
    NSAssert(NO, @"Subclasses need to overwrite this method");
    return nil;
}
@end
