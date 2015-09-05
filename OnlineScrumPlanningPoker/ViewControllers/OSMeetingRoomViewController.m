//
//  OSMeetingRoomViewController.m
//  OnlineScrumPlanningPoker
//
//  Created by SunHan on 4/13/15.
//  Copyright (c) 2015 SunHan. All rights reserved.
//

#import "OSMeetingRoomViewController.h"
#import "OSGuestUser.h"
#import "OSHostUser.h"
#import "OSPokerBaseView.h"
#import "OSUserRepresentative.h"
#import "OSMeetingBoardCellTableViewCell.h"
#import "UIColor+More.h"
#import "OSGeneric.h"

#define MeetingBoardCellIdentifier @"MeetingBoardCellIdentifier"
#define kColorSchemaNumber 5

@interface OSMeetingRoomViewController () <UITableViewDataSource, UITableViewDelegate, OSUserDelegate, OSGuestUserDelegate>
@property (weak, nonatomic) IBOutlet UILabel *welcomeLabel;
@property (weak, nonatomic) IBOutlet OSPokerBaseView *pokerView;
@property (weak, nonatomic) IBOutlet UITableView* tableView;

@property (weak, nonatomic) IBOutlet UIButton* voteButton;
@property (weak, nonatomic) IBOutlet UIButton* showAllButton;
@property (weak, nonatomic) IBOutlet UIButton* restartButton;
- (UIColor *)nameLabelColor:(NSIndexPath*)indexPath;
- (UIColor *)statusLabelColor:(NSIndexPath*)indexPath;
@end

@implementation OSMeetingRoomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = [NSString stringWithFormat:@"%@'s Meeting",self.user.meetingHostName];
    self.welcomeLabel.text = [NSString stringWithFormat:@"Welcome, %@! Please vote.", self.user.name];
    self.showAllButton.hidden = ![self.user isHost];
    self.restartButton.hidden = ![self.user isHost];
    self.showAllButton.enabled = NO;
    [self.user setDelegate:self];
    if (![self.user isHost]) {
        [((OSGuestUser*)self.user) setGuestDelegate:self];
    }
    [self.user startMeeting];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.user exitMeeting];
}

- (UIColor *)nameLabelColor:(NSIndexPath*)indexPath {
    UIColor *color = nil;;
    switch (indexPath.row % kColorSchemaNumber) {
        case 0: color = [UIColor colorFromHexString:@"ECC6C4"];   break;
        case 1: color = [UIColor colorFromHexString:@"DDE8CC"];   break;
        case 2: color = [UIColor colorFromHexString:@"D6CDDF"];   break;
        case 3: color = [UIColor colorFromHexString:@"FDDCC5"];   break;
        case 4: color = [UIColor colorFromHexString:@"C3E4EC"];   break;
        default:    break;
    }
    return color;
}

- (UIColor *)statusLabelColor:(NSIndexPath*)indexPath {
    UIColor *color = nil;;
    switch (indexPath.row % kColorSchemaNumber) {
        case 0: color = [UIColor colorFromHexString:@"A74946"];   break;
        case 1: color = [UIColor colorFromHexString:@"88A158"];   break;
        case 2: color = [UIColor colorFromHexString:@"745F8A"];   break;
        case 3: color = [UIColor colorFromHexString:@"EB7F2E"];   break;
        case 4: color = [UIColor colorFromHexString:@"3C97AA"];   break;
        default:    break;
    }
    return color;
}

- (IBAction)voteAction:(id)sender {
    self.voteButton.enabled = NO;
    [self.voteButton setTitle:@"Voted" forState:UIControlStateNormal];
    [self.user vote:[self.pokerView pointString]];
    if ([self.user isHost]) {
       
    } else {
        self.welcomeLabel.text = [NSString stringWithFormat:@"Just voted. Awaiting the reveal."];
    }
}

- (IBAction)showAllAction:(id)sender {
    if ([self.user isHost]) {
        [(OSHostUser*)self.user revealAllVotes];
    }
}

- (IBAction)restartAction:(id)sender {
    if ([self.user isHost]) {
        [(OSHostUser*)self.user restartMeeting];
    }
}

- (IBAction)helpAction:(id)sender {
    NSString* message;
    if ([self.user isHost]) {
        message = @"As meeting host, you can make your vote and wait for the others to make thier choices. Then tap \"Show all votes\" to reveal the result.";
    }else {
        message = @"You just joined a meeting. Please make your vote and wait for the host to reveal the results.";
    }
    [OSGeneric displayError:message fromViewController:self];
}

#pragma mark - OSUserDelegate
- (void)didUpdateUsers:(BOOL)readyToReveal{
    [self.tableView reloadData];
    if([self.user isHost]) {
        if (readyToReveal) {
            if([(OSHostUser*)self.user allRevealed]){
                self.welcomeLabel.text = [NSString stringWithFormat:@"Results revealed!"];
            }else{
                self.welcomeLabel.text = [NSString stringWithFormat:@"All voted. Please show all votes."];
            }
        } else {
            self.welcomeLabel.text = [NSString stringWithFormat:@"Awaiting for everyone to vote."];
        }
        self.showAllButton.enabled = readyToReveal;
    }else {
        if (readyToReveal) {
             self.welcomeLabel.text = [NSString stringWithFormat:@"Check out the result!"];
        }
    }
}

- (void)userReset {
    self.voteButton.enabled = YES;
     self.welcomeLabel.text = [NSString stringWithFormat:@"Welcome, %@! Please vote.", self.user.name];
}

#pragma mark - OSGuestUserDelegate
- (void)didUpdateHosts {
    
}
- (void)connectHostSuccess {
    
}
- (void)connectHostError:(NSError*)error {
    if (![self.user isHost]) {
        [OSGeneric displayError:@"Host has closed the meeting"
             fromViewController:self
                        handler:^(UIAlertAction *action){
                            [self.navigationController popViewControllerAnimated:YES];
        }];
    }
}

#pragma mark - UITableViewDataSource / UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.user numberOfMembers];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    OSUserRepresentative* user = [self.user memberAtIndex:indexPath.row];
    OSMeetingBoardCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MeetingBoardCellIdentifier];
    cell.nameLabel.text = [NSString stringWithFormat:@" %@",user.name];
    cell.statusLabel.text = user.status;
    cell.nameLabel.backgroundColor = [self nameLabelColor:indexPath];
    cell.statusLabel.backgroundColor = [self statusLabelColor:indexPath];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.0;
}
@end
