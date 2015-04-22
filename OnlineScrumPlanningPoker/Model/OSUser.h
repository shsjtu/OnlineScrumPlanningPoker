//
//  OSUser.h
//  OnlineScrumPlanningPoker
//
//  Created by SunHan on 4/13/15.
//  Copyright (c) 2015 SunHan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OSUser : NSObject
@property (strong, nonatomic) NSString *name;
- (void)startMeeting;
- (NSString*)hostName;
@end
