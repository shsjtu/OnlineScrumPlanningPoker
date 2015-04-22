//
//  OSGuestUser.h
//  OnlineScrumPlanningPoker
//
//  Created by SunHan on 4/19/15.
//  Copyright (c) 2015 SunHan. All rights reserved.
//

#import "OSUser.h"

@protocol OSGuestUserDelegate;
@interface OSGuestUser : OSUser
@property (assign) id <OSGuestUserDelegate> delegate;

/* 
 * Start browsing broadcasted services in network 
 */
- (void)startBrowsing;

/* 
 * Stop service browsing 
 */
- (void)stopBrowsing;

/*
 * Number of avaliable services
 */
- (NSInteger)numberOfHosts;

/*
 * Name of ith service
 */
- (NSString*)nameOfHostAtIndex:(NSInteger)index;

/*
 * Start resolving ith service
 */
- (void)resolveHostAtIndex:(NSInteger)index;
@end

@protocol OSGuestUserDelegate <NSObject>
- (void)didUpdateHosts;
- (void)connectHostSuccess;
- (void)connectHostError:(NSError*)error;
@end