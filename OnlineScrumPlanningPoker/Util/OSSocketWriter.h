//
//  OSSocketWriter.h
//  OnlineScrumPlanningPoker
//
//  Created by SunHan on 4/28/15.
//  Copyright (c) 2015 SunHan. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GCDAsyncSocket;
@interface OSSocketWriter : NSObject

- (void)writeMessage:(NSDictionary *)info socket:(GCDAsyncSocket *)sock;

@end
