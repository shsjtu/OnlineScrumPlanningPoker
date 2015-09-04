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
- (instancetype)init {
    if(self = [super init]) {
        self.revealed = NO;
    }
    return self;
}

-(OSUserRepresentativeSerializationType)serialized {
    if(_name.length == 0 || _status.length == 0) {
        return nil;
    }
    return @{self.name:self.status};
}

-(NSString*)status {
    if (_status.length == 0) {
        return nil;
    }
    if ([_status isEqual:kOSSocketVoteUnknown]){
        return _status;
    }
    if (self.revealed) {
        return _status;
    }
    //return "status to be revealed"
    return kOSSocketVoteTBR;
}

-(BOOL)voted {
    if (_status.length == 0) {
        return NO;
    }
    return ![_status isEqual:kOSSocketVoteUnknown];
}

-(BOOL)voteRevealed{
    if (_status.length == 0) {
        return NO;
    }
    return ![_status isEqual:kOSSocketVoteUnknown] && ![_status isEqual:kOSSocketVoteTBR];
}

-(instancetype)initWithDictionary:(OSUserRepresentativeSerializationType)dict {
    if (self = [super init]) {
        self.name = dict.allKeys.firstObject;
        self.status = dict[self.name];
    }
    return self;
}
@end
