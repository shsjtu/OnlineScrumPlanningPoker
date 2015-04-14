//
//  OSGeneric.m
//  OnlineScrumPlanningPoker
//
//  Created by SunHan on 4/13/15.
//  Copyright (c) 2015 SunHan. All rights reserved.
//

#import "OSGeneric.h"

@implementation OSGeneric
+ (void)displayError:(NSString*)message fromViewController:(UIViewController*)viewController{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil
                                                                             message:message
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                       style:UIAlertActionStyleDefault
                                                     handler:nil];
    [alertController addAction:okAction];
    [viewController presentViewController:alertController animated:YES completion:nil];
}
@end
