//
//  OSNetworkUtil.m
//  OnlineScrumPlanningPoker
//
//  Created by SunHan on 4/9/15.
//  Copyright (c) 2015 SunHan. All rights reserved.
//

#import "OSNetworkUtil.h"
#import <SystemConfiguration/CaptiveNetwork.h>

@implementation OSNetworkUtil
+ (NSString*)wifiSSID{
    NSArray *ifs = (__bridge_transfer id)CNCopySupportedInterfaces();
    if(!ifs) { return nil; }
    id info = nil;
    for (NSString *ifnam in ifs) {
        info = (__bridge_transfer id)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam);
        if (info && [info count]) { break; }
    }
    return info[@"SSID"];
}
@end
