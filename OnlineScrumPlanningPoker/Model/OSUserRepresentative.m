//
//  OSUserRepresentative.m
//  OnlineScrumPlanningPoker
//
//  Created by SunHan on 4/27/15.
//  Copyright (c) 2015 SunHan. All rights reserved.
//

#import "OSUserRepresentative.h"
#import "OSConstants.h"

@interface OSUserRepresentative()
//@property (nonatomic, strong) NSMutableDictionary *info;
@end

@implementation OSUserRepresentative
-(OSUserRepresentativeSerializationType)serialized:(BOOL)statusRevealed {
    if(self.name.length == 0 || self.status.length == 0) {
        return nil;
    }
    if ([self.status isEqual:kOSSocketVoteUnknown]){
        return @{self.name:self.status};
    }
    if (statusRevealed) {
        return @{self.name:self.status};
    }
    //return "status to be revealed"
    return @{self.name:kOSSocketVoteTBR};
}


-(instancetype)initWithDictionary:(OSUserRepresentativeSerializationType)dict {
    if (self = [super init]) {
        self.name = dict.allKeys.firstObject;
        self.status = dict[self.name];
    }
    return self;
}
@end
