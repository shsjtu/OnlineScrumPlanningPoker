//
//  OSHostsBrowserViewController.m
//  OnlineScrumPlanningPoker
//
//  Created by SunHan on 4/12/15.
//  Copyright (c) 2015 SunHan. All rights reserved.
//

#import "OSHostsBrowserViewController.h"
#import "OSMeetingRoomViewController.h"
#import "OSConstants.h"
#import "OSGuestUser.h"
#import "OSGeneric.h"


#define HostsBrowserCellIdentifier @"HostsBrowserCellIdentifier"

@interface OSHostsBrowserViewController () <OSGuestUserDelegate>
@property (weak, nonatomic) IBOutlet UITableView *hostsTableView;
@end

@implementation OSHostsBrowserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.guestUser setDelegate:self];
    [self.guestUser startBrowsing];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     if([segue.identifier isEqualToString:kOSSegueIdGuestToMeetingRoom]) {
         OSMeetingRoomViewController* meetingController = segue.destinationViewController;
         meetingController.user = self.guestUser;
     }
}

#pragma mark - OSGuestUserDelegate
- (void)didUpdateHosts {
    [self.hostsTableView reloadData];
}

- (void)connectHostSuccess {
    //[self.navigationController popViewControllerAnimated:NO];
    [self performSegueWithIdentifier:kOSSegueIdGuestToMeetingRoom sender:self];
}

- (void)connectHostError:(NSError*)error {
    [OSGeneric displayError:[NSString stringWithFormat:@"Cannot connect to host (%@ - %zd)", error.domain, error.code] fromViewController:self];
}

#pragma mark - UITableViewDataSource / UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.guestUser numberOfHosts];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [NSString stringWithFormat:@"%zd meetings in network", [self.guestUser numberOfHosts]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:HostsBrowserCellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:HostsBrowserCellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.textLabel.text = [self.guestUser nameOfHostAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.guestUser resolveHostAtIndex:indexPath.row];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
@end
