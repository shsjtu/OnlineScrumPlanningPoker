//
//  ViewController.m
//  OnlineScrumPlanningPoker
//
//  Created by SunHan on 3/5/15.
//  Copyright (c) 2015 SunHan. All rights reserved.
//

#import "OSMasterViewController.h"
#import "OSNetworkUtil.h"
#import "OSGeneric.h"
#import "OSConstants.h"
#import "OSMeetingRoomViewController.h"
#import "OSHostsBrowserViewController.h"
#import "OSHostUser.h"
#import "OSGuestUser.h"
#import "UIColor+More.h"

#define kActionCell @"ActionCell"

@interface OSMasterViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *nameInput;
@property (weak, nonatomic) IBOutlet UILabel *currentNetworkLabel;
- (void)hostAction;
- (void)joinAction;
- (BOOL)readyForMeeting;
@end

@implementation OSMasterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadUserDefaults];
    NSString* ssid = [OSNetworkUtil wifiSSID];
    if(ssid) {
        self.currentNetworkLabel.text = [NSString stringWithFormat:@"My WIFI: \"%@\"", ssid];
    }else {
        self.currentNetworkLabel.text = @"You are not connected to any WIFI";
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadUserDefaults {
    NSString* defaultsUserName = [[NSUserDefaults standardUserDefaults] objectForKey:kOSAppDefaultsUserNameKey];
    if (defaultsUserName) {
        self.nameInput.text = defaultsUserName;
    }
}

- (void)saveDefaultsUserName {
    [[NSUserDefaults standardUserDefaults] setObject:self.nameInput.text forKey:kOSAppDefaultsUserNameKey];
}

- (void)hostAction {
    if([self readyForMeeting]) {
        [self saveDefaultsUserName];
        [self performSegueWithIdentifier:kOSSegueIdHostToMeetingRoom sender:self];
    }
}

- (void)joinAction {
    if([self readyForMeeting]) {
        [self saveDefaultsUserName];
        [self performSegueWithIdentifier:kOSSegueIdMasterToHostsBrowser sender:self];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

- (BOOL)readyForMeeting {
    //trim string
    self.nameInput.text = [self.nameInput.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (self.nameInput.text.length == 0) {
        [OSGeneric displayError:@"Please enter your name" fromViewController:self];
        return NO;
    }
    return YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:kOSSegueIdMasterToHostsBrowser]) {
        OSGuestUser* guestUser = [[OSGuestUser alloc] init];
        guestUser.name = self.nameInput.text;
        OSHostsBrowserViewController* browserController = segue.destinationViewController;
        browserController.guestUser = guestUser;
    }else if([segue.identifier isEqualToString:kOSSegueIdHostToMeetingRoom]) {
        OSUser* user = [[OSHostUser alloc] init];
        user.name = self.nameInput.text;
        OSMeetingRoomViewController* roomViewController = segue.destinationViewController;
        roomViewController.user = user;
    }
}
#pragma mark - UITableViewDataSource / UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"Start your meeting:";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kActionCell];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:kActionCell];
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    if(indexPath.row==0) {
        cell.textLabel.text = @"Host a meeting";
    }else{
        cell.textLabel.text =  @"Join a meeting";
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row==0) {
        [self hostAction];
    }else{
        [self joinAction];
    }
}
@end
