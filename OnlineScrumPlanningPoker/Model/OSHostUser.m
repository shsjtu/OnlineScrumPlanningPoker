//
//  OSHostUser.m
//  OnlineScrumPlanningPoker
//
//  Created by SunHan on 4/13/15.
//  Copyright (c) 2015 SunHan. All rights reserved.
//

#import "OSHostUser.h"
#import "GCDAsyncSocket.h"
#import "OSConstants.h"

@interface OSHostUser () <NSNetServiceDelegate, GCDAsyncSocketDelegate>

@property (strong, nonatomic) NSNetService *publichService;
@property (strong, nonatomic) GCDAsyncSocket *listenerSocket;
@property (strong, nonatomic) GCDAsyncSocket *clientSocket;

@end

@implementation OSHostUser

- (void)startMeeting {
    [self startBroadcast];
}
- (void)startBroadcast {
    // Initialize GCDAsyncSocket
    self.listenerSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    // Start Listening for Incoming Connections
    NSError *error = nil;
    if ([self.listenerSocket acceptOnPort:0 error:&error]) {
        // Initialize Service
        self.publichService = [[NSNetService alloc] initWithDomain:kOSBonjourServiceDomain
                                                              type:kOSBonjourServiceType
                                                              name:self.name
                                                              port:[self.listenerSocket localPort]];
        // Configure Service
        [self.publichService setDelegate:self];
        // Publish Service
        [self.publichService publish];
    } else {
        NSLog(@"OSHostUser: Unable to create socket. Error %@ with user info %@.", error, [error userInfo]);
    }
}

- (void)stopBroadcase {
    if (self.listenerSocket) {
        [self.listenerSocket disconnect];
        [self.listenerSocket setDelegate:nil];
        [self setListenerSocket:nil];
    }
    if (self.publichService) {
        [self.publichService stop];
        [self.publichService setDelegate:nil];
        [self setPublichService:nil];
    }
}

- (void)dealloc {
    [self stopBroadcase];
}


#pragma mark - NSNetServiceDelegate
- (void)netServiceDidPublish:(NSNetService *)service {
    
}

- (void)netService:(NSNetService *)service didNotPublish:(NSDictionary *)errorDict {
    NSLog(@"Failed to Publish Service: domain(%@) type(%@) name(%@) - %@", [service domain], [service type], [service name], errorDict);
    if (service == self.publichService) {
        [self stopBroadcase];
        [self publichService];
    }
}

#pragma mark - GCDAsyncSocketDelegate
- (void)socket:(GCDAsyncSocket *)socket didAcceptNewSocket:(GCDAsyncSocket *)newSocket {
    NSLog(@"Accepted New Socket from %@:%hu", [newSocket connectedHost], [newSocket connectedPort]);
    
    // Socket
    [self setClientSocket:newSocket];
    
    // Read Data from Socket
    [newSocket readDataToLength:sizeof(uint64_t) withTimeout:-1.0 tag:0];
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)socket withError:(NSError *)error {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    if (self.listenerSocket == socket) {
        [self.listenerSocket setDelegate:nil];
        [self setListenerSocket:nil];
    }
    
    if (self.clientSocket == socket) {
        [self.clientSocket setDelegate:nil];
        [self setClientSocket:nil];
    }
}
@end
