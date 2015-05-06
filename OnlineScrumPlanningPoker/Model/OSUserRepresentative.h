//
//  OSUserRepresentative.h
//  OnlineScrumPlanningPoker
//
//  Created by SunHan on 4/27/15.
//  Copyright (c) 2015 SunHan. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NSDictionary* OSUserRepresentativeSerializationType;

@interface OSUserRepresentative : NSObject
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *status;

-(OSUserRepresentativeSerializationType)serialized:(BOOL)statusRevealed;
-(instancetype)initWithDictionary:(OSUserRepresentativeSerializationType)dict;

@end
