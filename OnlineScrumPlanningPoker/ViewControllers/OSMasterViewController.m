//
//  ViewController.m
//  OnlineScrumPlanningPoker
//
//  Created by SunHan on 3/5/15.
//  Copyright (c) 2015 SunHan. All rights reserved.
//

#import "OSMasterViewController.h"
#import "OSNetworkUtil.h"

@interface OSMasterViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *nameInput;
@property (weak, nonatomic) IBOutlet UILabel *currentNetworkLabel;
@property (weak, nonatomic) IBOutlet UIView *outlineView;
- (IBAction)hostAction:(id)sender;
- (IBAction)joinAction:(id)sender;

@end

@implementation OSMasterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.outlineView.backgroundColor = [UIColor clearColor];
    self.outlineView.layer.borderColor = [UIColor colorWithWhite:0.8 alpha:1.0].CGColor;
    self.outlineView.layer.borderWidth = 2.0f;
    self.outlineView.layer.cornerRadius = 8.0f;
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

- (IBAction)hostAction:(id)sender {
    
}

- (IBAction)joinAction:(id)sender {
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}
@end
