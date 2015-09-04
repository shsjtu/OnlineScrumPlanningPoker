//
//  OSGeneric.h
//  OnlineScrumPlanningPoker
//
//  Created by SunHan on 4/13/15.
//  Copyright (c) 2015 SunHan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface OSGeneric : NSObject
+ (void)displayError:(NSString*)message
  fromViewController:(UIViewController*)viewController
             handler:(void (^)(UIAlertAction *action))handler;
+ (void)displayError:(NSString*)message fromViewController:(UIViewController*)viewController;
+ (BOOL)newerVersion:(NSString*)version;
+ (BOOL)elderVersion:(NSString*)version;
+ (BOOL)sameVersion:(NSString*)version;
@end
