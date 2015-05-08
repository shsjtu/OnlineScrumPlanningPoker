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
#import "OSSocketReader.h"
#import "OSSocketWriter.h"
#import "OSUserRepresentative.h"

@interface OSGuestUser () <GCDAsyncSocketDelegate, NSNetServiceBrowserDelegate, NSNetServiceDelegate, OSSocketReaderDelegate>
@property (strong, nonatomic) NSMutableArray *services;
@property (strong, nonatomic) NSNetServiceBrowser *serviceBrowser;
@property (strong, nonatomic) GCDAsyncSocket *hostSocket;
@property (strong, nonatomic) NSString *hostName;
@property (strong, nonatomic) OSSocketReader* reader;
@property (strong, nonatomic) OSSocketWriter* writer;
@property (strong, nonatomic) NSMutableArray* allRepresentatives;

//methods
- (void)resolveService:(NSNetService*)service;
- (BOOL)connectWithService:(NSNetService *)service error:(NSError **)errPtr;
- (void)startBrowsing;
- (void)stopBrowsing;
- (void)disconnectHost;
@end

@implementation OSGuestUser
- (instancetype)init {
    if (self = [super init]) {
        self.reader = [[OSSocketReader alloc] init];
        self.reader.delegate = self;
        self.writer = [[OSSocketWriter alloc] init];
        self.allRepresentatives = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return self;
}

- (void)dealloc{}

- (void)startMeeting {
    self.selfRepresentative.name = self.name;
    self.selfRepresentative.status = kOSSocketVoteUnknown;
    self.selfRepresentative.revealed = YES;
    [self.reader installSocket:self.hostSocket];
}

- (void)exitMeeting {
    [self disconnectHost];
}

- (NSString*)meetingHostName {
    return self.hostName;
}

- (NSInteger)numberOfMembers {
    return self.allRepresentatives.count;
}

- (OSUserRepresentative*)memberAtIndex:(NSInteger)index {
    if(index>=self.allRepresentatives.count) {  return nil; }
    return self.allRepresentatives[index];
}

- (void)vote:(NSString*)voteString {
    [super vote:voteString];
    //commit the vote to host
    [self commitStatus];
}

- (BOOL)isHost {
    return NO;
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
        self.serviceBrowser.delegate = nil;
        self.serviceBrowser = nil;
    }
}

- (void)disconnectHost {
    if (self.hostSocket) {
        self.hostSocket.delegate = nil;
        [self.hostSocket disconnect];
        self.hostSocket = nil;
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
    if(!self.hostSocket || ![self.hostSocket isConnected]) {
        // init socket
        self.hostSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
        // connect
        while (!lConnected && [addresses count]) {
            NSData *address = [addresses objectAtIndex:0];
            if ([self.hostSocket connectToAddress:address error:errPtr]) {
                lConnected = YES;
            } else if (*errPtr) {
                NSLog(@"Unable to connect to address. Error %@ with user info %@.", *errPtr, [*errPtr userInfo]);
            }
        }
    }else {
        lConnected = [self.hostSocket isConnected];
    }
    return lConnected;
}

- (void)handleHostBroadCast:(NSDictionary*)response {
    [self.allRepresentatives removeAllObjects];
    NSArray* allMembers = response[kOSSocketInfoKey];
    for (OSUserRepresentativeSerializationType memberDict in allMembers) {
        OSUserRepresentative* member = [[OSUserRepresentative alloc] initWithDictionary:memberDict];
        member.revealed = YES;
        [self.allRepresentatives addObject:member];
    }
    //notify delegate about status update
    [self.delegate didUpdateUsers:NO];
}

- (void)handleHostResponse:(NSDictionary*)response {
    NSString* event = response[kOSSocketEventKey];
    if ([event isEqual:kOSSocketEventTypeWelcomeGuest]) {
        [self commitStatus];
    }else if ([event isEqual:kOSSocketEventTypeDenyGuest]){
        NSLog(@"Connection has been denied by host");
    }else if ([event isEqual:kOSSocketEventTypeHostBroadcast]){
        [self handleHostBroadCast:response];
    }else {
        NSLog(@"Guest recieved unknown response: %@",response);
    }
}

- (void)commitStatus {
    NSString* status = self.selfRepresentative.status;
    NSDictionary* statusInfo = @{kOSSocketEventKey:kOSSocketEventTypeGuestVote,
                                 kOSSocketNameKey:self.name,
                                 kOSSocketInfoKey:status};
    [self.writer writeMessage:statusInfo socket:self.hostSocket];
}

#pragma mark - OSSocketReaderDelegate
- (void)socket:(GCDAsyncSocket *)sock onMessage:(NSDictionary*)infoDict {
    if(self.hostSocket == sock) {
        [self handleHostResponse:infoDict];
    }
}

#pragma mark - GCDAsyncSocketDelegate
- (void)socketDidDisconnect:(GCDAsyncSocket *)socket withError:(NSError *)error {
    if(socket == self.hostSocket){
        NSLog(@"Socket disconnect: %@.", error);
        [socket setDelegate:nil];
        [self setHostSocket:nil];
        [self.guestDelegate connectHostError:error];
    }
}

- (void)socket:(GCDAsyncSocket *)socket didConnectToHost:(NSString *)host port:(UInt16)port {
    if(socket == self.hostSocket){
        [self.guestDelegate connectHostSuccess];
    }
}

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag {
    [self.reader socket:sock didReadData:data withTag:tag];
}

#pragma mark - NSNetServiceDelegate
- (void)netService:(NSNetService *)service didNotResolve:(NSDictionary *)errorDict {
    [service setDelegate:nil];
    NSLog(@"Service (%@) didNotResolve: %@", service.name, errorDict);
    [self.guestDelegate connectHostError:[NSError errorWithDomain: errorDict[NSNetServicesErrorDomain]
                                                        code: [errorDict[NSNetServicesErrorCode] intValue]
                                                    userInfo: nil]];
}

- (void)netServiceDidResolveAddress:(NSNetService *)service {
    NSError* error = nil;
    if(![self connectWithService:service error:&error]){
        [self.guestDelegate connectHostError:error];
    }
    [service stop];
    [self stopBrowsing];
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
        [self.guestDelegate didUpdateHosts];
    }
}

- (void)netServiceBrowser:(NSNetServiceBrowser *)serviceBrowser didRemoveService:(NSNetService *)service moreComing:(BOOL)moreComing {
    // Update Services
    @synchronized (self){
        [self.services removeObject:service];
    }
    if(!moreComing) {
        [self.guestDelegate didUpdateHosts];
    }
}

- (void)netServiceBrowserDidStopSearch:(NSNetServiceBrowser *)serviceBrowser {
    [self stopBrowsing];
}

- (void)netServiceBrowser:(NSNetServiceBrowser *)aBrowser didNotSearch:(NSDictionary *)userInfo {
    [self stopBrowsing];
}
@end
