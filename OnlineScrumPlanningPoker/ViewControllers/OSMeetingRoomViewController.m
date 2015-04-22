//
//  OSMeetingRoomViewController.m
//  OnlineScrumPlanningPoker
//
//  Created by SunHan on 4/13/15.
//  Copyright (c) 2015 SunHan. All rights reserved.
//

#import "OSMeetingRoomViewController.h"
#import "OSHostUser.h"
#import "OSPokerBaseView.h"

@interface OSMeetingRoomViewController ()
@property (weak, nonatomic) IBOutlet UILabel *welcomeLabel;
@property (weak, nonatomic) IBOutlet OSPokerBaseView *pokerView;
- (BOOL)hostMode;
@end

@implementation OSMeetingRoomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if(self.user.name.length > 0){
        self.welcomeLabel.text = [NSString stringWithFormat:@"Welcome to %@'s meeting",self.user.name];
    }
    [self.user startMeeting];
}

- (BOOL)hostMode {
    return [self.user isKindOfClass:[OSHostUser class]];
}


@end
