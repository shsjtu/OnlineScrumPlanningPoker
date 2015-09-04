//
//  OSGeneric.m
//  OnlineScrumPlanningPoker
//
//  Created by SunHan on 4/13/15.
//  Copyright (c) 2015 SunHan. All rights reserved.
//

#import "OSGeneric.h"
#import "OSConstants.h"

@implementation OSGeneric
+ (void)displayError:(NSString*)message fromViewController:(UIViewController*)viewController{
    [self displayError:message fromViewController:viewController handler:nil];
}

+ (void)displayError:(NSString*)message
  fromViewController:(UIViewController*)viewController
             handler:(void (^)(UIAlertAction *action))handler {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil
                                                                             message:message
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                       style:UIAlertActionStyleDefault
                                                     handler:handler];
    [alertController addAction:okAction];
    [viewController presentViewController:alertController animated:YES completion:nil];
}

+ (NSComparisonResult)compareVersion:(NSString*)version {
    return [kOSSocketCurrentVersion compare:version options:NSNumericSearch];
}

+ (BOOL)newerVersion:(NSString*)version {
    return [OSGeneric compareVersion:version] == NSOrderedAscending;
}

+ (BOOL)elderVersion:(NSString*)version {
    return [OSGeneric compareVersion:version] == NSOrderedDescending;
}

+ (BOOL)sameVersion:(NSString*)version {
    return [OSGeneric compareVersion:version] == NSOrderedSame;
}
@end
