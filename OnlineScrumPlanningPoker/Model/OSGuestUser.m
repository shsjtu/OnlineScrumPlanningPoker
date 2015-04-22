//
//  OSGuestUser.m
//  OnlineScrumPlanningPoker
//
//  Created by SunHan on 4/19/15.
//  Copyright (c) 2015 SunHan. All rights reserved.
//

#import "OSGuestUser.h"
#import "GCDAsyncSocket.h"
#import "OSConstants.h"

@interface OSGuestUser () <GCDAsyncSocketDelegate, NSNetServiceBrowserDelegate, NSNetServiceDelegate>
@property (strong, nonatomic) NSMutableArray *services;
@property (strong, nonatomic) NSNetServiceBrowser *serviceBrowser;
@property (strong, nonatomic) GCDAsyncSocket *socket;
@property (strong, nonatomic) NSString *hostName;

//methods
- (void)resolveService:(NSNetService*)service;
- (BOOL)connectWithService:(NSNetService *)service error:(NSError **)errPtr;

@end

@implementation OSGuestUser
- (void)startMeeting {}

- (void)dealloc{}

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

- (NSInteger)numberOfHosts {
    return self.services.count;
}

- (NSString*)nameOfHostAtIndex:(NSInteger)index {
    if(index < self.services.count) {
        NSNetService* service = self.services[index];
        return service.name;
    }
    return nil;
}

- (void)resolveHostAtIndex:(NSInteger)index {
    if(index < self.services.count) {
        NSNetService* service = self.services[index];
        [self resolveService:service];
    }else {
        NSLog(@"OSGuestUser: resolve host at invalid index");
    }
}

- (void)resolveService:(NSNetService*)service {
    if(service){
        service.delegate = self;
        [service resolveWithTimeout:30.0];
    }
}

- (BOOL)connectWithService:(NSNetService *)service error:(NSError **)errPtr{
    self.hostName = service.name;
    BOOL lConnected = NO;
    // Copy Service Addresses
    NSArray *addresses = [[service addresses] mutableCopy];
    if(!self.socket || ![self.socket isConnected]) {
        // init socket
        self.socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
        // connect
        while (!lConnected && [addresses count]) {
            NSData *address = [addresses objectAtIndex:0];
            if ([self.socket connectToAddress:address error:errPtr]) {
                lConnected = YES;
            } else if (*errPtr) {
                NSLog(@"Unable to connect to address. Error %@ with user info %@.", *errPtr, [*errPtr userInfo]);
            }
        }
    }else {
        lConnected = [self.socket isConnected];
    }
    return lConnected;
}

#pragma mark - GCDAsyncSocketDelegate
- (void)socketDidDisconnect:(GCDAsyncSocket *)socket withError:(NSError *)error {
    if(socket == self.socket){
        NSLog(@"Socket disconnect: %@.", error);
        [socket setDelegate:nil];
        [self setSocket:nil];
        [self.delegate connectHostError:error];
    }
}

- (void)socket:(GCDAsyncSocket *)socket didConnectToHost:(NSString *)host port:(UInt16)port {
    if(socket == self.socket){
        [self.delegate connectHostSuccess];
    }
    // Start Reading
    //NSData *term = [@"**/**" dataUsingEncoding:NSUTF8StringEncoding];
    //[socket readDataToData:term withTimeout:-1 tag:0];
}

- (void)socket:(GCDAsyncSocket *)socket didReadData:(NSData *)data withTag:(long)tag {
    //NSString* str = [NSString stringWithUTF8String:data.bytes];
    //NSLog(@"didReadData: %@",str);
    // Start Reading
    //NSData *term = [@"**/**" dataUsingEncoding:NSUTF8StringEncoding];
    //[socket readDataToData:term withTimeout:-1 tag:0];
}


#pragma mark - NSNetServiceDelegate
- (void)netService:(NSNetService *)service didNotResolve:(NSDictionary *)errorDict {
    [service setDelegate:nil];
    NSLog(@"Service (%@) didNotResolve: %@", service.name, errorDict);
    [self.delegate connectHostError:[NSError errorWithDomain: errorDict[NSNetServicesErrorDomain]
                                                        code: [errorDict[NSNetServicesErrorCode] intValue]
                                                    userInfo: nil]];
}

- (void)netServiceDidResolveAddress:(NSNetService *)service {
    NSError* error = nil;
    if(![self connectWithService:service error:&error]){
        [self.delegate connectHostError:error];
    }
    [service stop];
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
        [self.delegate didUpdateHosts];
    }
}

- (void)netServiceBrowser:(NSNetServiceBrowser *)serviceBrowser didRemoveService:(NSNetService *)service moreComing:(BOOL)moreComing {
    // Update Services
    @synchronized (self){
        [self.services removeObject:service];
    }
    if(!moreComing) {
        [self.delegate didUpdateHosts];
    }
}

- (void)netServiceBrowserDidStopSearch:(NSNetServiceBrowser *)serviceBrowser {
    [self stopBrowsing];
}

- (void)netServiceBrowser:(NSNetServiceBrowser *)aBrowser didNotSearch:(NSDictionary *)userInfo {
    [self stopBrowsing];
}
@end
