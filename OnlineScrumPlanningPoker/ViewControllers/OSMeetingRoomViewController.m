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
#import "OSUserRepresentative.h"

#define MeetingBoardCellIdentifier @"MeetingBoardCellIdentifier"

@interface OSMeetingRoomViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *welcomeLabel;
@property (weak, nonatomic) IBOutlet OSPokerBaseView *pokerView;
- (BOOL)hostMode;
@end

@implementation OSMeetingRoomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if(self.user.name.length > 0){
        self.welcomeLabel.text = [NSString stringWithFormat:@"Welcome to %@'s meeting",self.user.meetingHostName];
    }
    [self.user startMeeting];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.user exitMeeting];
}

- (BOOL)hostMode {
    return [self.user isKindOfClass:[OSHostUser class]];
}

#pragma mark - UITableViewDataSource / UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.user numberOfMembers];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    OSUserRepresentative* user = [self.user memberAtIndex:indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MeetingBoardCellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:MeetingBoardCellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%@ : %@", user.name, user.status];
    return cell;
}
@end
