//
//  OSUser.h
//  OnlineScrumPlanningPoker
//
//  Created by SunHan on 4/13/15.
//  Copyright (c) 2015 SunHan. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol OSUserDelegate;
@class OSUserRepresentative;
@interface OSUser : NSObject
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) OSUserRepresentative *selfRepresentative;
@property (assign) id <OSUserDelegate> delegate;

- (void)startMeeting;
- (void)exitMeeting;
- (NSString*)meetingHostName;
- (NSInteger)numberOfMembers;
- (OSUserRepresentative*)memberAtIndex:(NSInteger)index;
@end

@protocol OSUserDelegate <NSObject>
- (void)didUpdateUsers;
@end
