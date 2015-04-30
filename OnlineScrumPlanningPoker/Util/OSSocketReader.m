//
//  OSSocketReader.m
//  OnlineScrumPlanningPoker
//
//  Created by SunHan on 4/27/15.
//  Copyright (c) 2015 SunHan. All rights reserved.
//

#import "OSSocketReader.h"
#import "GCDAsyncSocket.h"
#import "OSConstants.h"

@implementation OSSocketReader

- (int64_t)parseHeader:(NSData*)data {
    int64_t payload = *((int64_t*)data.bytes);
    return payload;
}

- (NSDictionary*)parsePayload:(NSData*)data {
    NSError* error = nil;
    NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    if(error) {
        NSLog(@"parsePayload :%@",error);
    }
    return dict;
}

- (void)installSocket:(GCDAsyncSocket*)sock {
    [sock readDataToLength:sizeof(int64_t) withTimeout:-1 tag:kOSSocketHeaderTag];
}

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag {
    if (tag == kOSSocketHeaderTag) {
        int64_t bodyLength = [self parseHeader:data];
        [sock readDataToLength:(NSUInteger)bodyLength withTimeout:-1 tag:kOSSocketPayloadTag];
    }else if (tag == kOSSocketPayloadTag) {
        NSDictionary* info = [self parsePayload:data];
        if (info) {
            [self.delegate socket:sock onMessage:info];
        }
        [self installSocket:sock];
    }
}
@end
