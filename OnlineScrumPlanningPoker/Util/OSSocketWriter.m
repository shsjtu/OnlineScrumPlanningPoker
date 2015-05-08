//
//  OSSocketWriter.m
//  OnlineScrumPlanningPoker
//
//  Created by SunHan on 4/28/15.
//  Copyright (c) 2015 SunHan. All rights reserved.
//

#import "OSSocketWriter.h"
#import "OSConstants.h"
#import "GCDAsyncSocket.h"

@implementation OSSocketWriter

- (NSData*)codeLength:(int64_t)lengh {
    return [NSData dataWithBytes:&lengh length:sizeof(int64_t)];
}

- (NSData*)codeMessage:(NSDictionary*)info {
    NSError* error = nil;
    NSData* data = [NSJSONSerialization dataWithJSONObject:info options:NSJSONWritingPrettyPrinted error:&error];
    if (error) {
        NSLog(@"writeMessage: %@", error);
    }
    return data;
}

- (void)writeMessage:(NSDictionary *)info socket:(GCDAsyncSocket *)sock {
    if(info) {
        NSMutableDictionary* payload = [NSMutableDictionary dictionaryWithDictionary:info];
        [payload setObject:kOSSocketCurrentVersion forKey:kOSSocketVersionKey];
        NSData* data = [self codeMessage:payload];
        if (data) {
            [sock writeData:[self codeLength:(int64_t)data.length] withTimeout:-1 tag:kOSSocketHeaderTag];
            [sock writeData:data withTimeout:-1 tag:kOSSocketPayloadTag];
        }
    }
}
@end
