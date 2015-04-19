//
//  OSHostsBrowserViewController.m
//  OnlineScrumPlanningPoker
//
//  Created by SunHan on 4/12/15.
//  Copyright (c) 2015 SunHan. All rights reserved.
//

#import "OSHostsBrowserViewController.h"
#import "Constants.h"

#define HostsBrowserCellIdentifier @"HostsBrowserCellIdentifier"

@interface OSHostsBrowserViewController () <NSNetServiceBrowserDelegate>
@property (weak, nonatomic) IBOutlet UITableView *hostsTableView;
@property (strong, nonatomic) NSMutableArray *services;
@property (strong, nonatomic) NSNetServiceBrowser *serviceBrowser;
@end

@implementation OSHostsBrowserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self startBrowsing];
}

- (void)startBrowsing {
    if (self.services) {
        [self.services removeAllObjects];
    } else {
        self.services = [[NSMutableArray alloc] init];
    }
    
    // Initialize Service Browser
    self.serviceBrowser = [[NSNetServiceBrowser alloc] init];
    
    // Configure Service Browser
    [self.serviceBrowser setDelegate:self];
    [self.serviceBrowser searchForServicesOfType:kOSBonjourServiceType inDomain:kOSBonjourServiceDomain];
}

- (void)stopBrowsing {
    if (self.serviceBrowser) {
        [self.serviceBrowser stop];
        [self.serviceBrowser setDelegate:nil];
        [self setServiceBrowser:nil];
    }
}

#pragma mark - NSNetServiceBrowserDelegate
- (void)netServiceBrowser:(NSNetServiceBrowser *)serviceBrowser didFindService:(NSNetService *)service moreComing:(BOOL)moreComing {
    // Update Services
    @synchronized (self){
        [self.services addObject:service];
    }
    if(!moreComing) {
        // Sort Services
        [self.services sortUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]]];
        [self.hostsTableView reloadData];
    }
}

- (void)netServiceBrowser:(NSNetServiceBrowser *)serviceBrowser didRemoveService:(NSNetService *)service moreComing:(BOOL)moreComing {
    // Update Services
    @synchronized (self){
        [self.services removeObject:service];
    }
    if(!moreComing) {
        [self.hostsTableView reloadData];
    }
}

- (void)netServiceBrowserDidStopSearch:(NSNetServiceBrowser *)serviceBrowser {
    [self stopBrowsing];
}

- (void)netServiceBrowser:(NSNetServiceBrowser *)aBrowser didNotSearch:(NSDictionary *)userInfo {
    [self stopBrowsing];
}


#pragma mark - UITableViewDataSource / UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.services count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:HostsBrowserCellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:HostsBrowserCellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if(indexPath.row >= self.services.count) {
        cell.textLabel.text = @"***";
    }else{
        NSNetService* service = self.services[indexPath.row];
        cell.textLabel.text = service.name;
    }
    
    return cell;
}
@end
