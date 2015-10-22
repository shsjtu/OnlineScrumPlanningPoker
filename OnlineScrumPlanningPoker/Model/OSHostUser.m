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
#import "OSSocketReader.h"
#import "OSSocketWriter.h"
#import "OSConstants.h"
#import "OSUserRepresentative.h"

@interface OSHostUser () <NSNetServiceDelegate, GCDAsyncSocketDelegate, OSSocketReaderDelegate>
@property (strong, nonatomic) NSNetService *publishService;
@property (strong, nonatomic) GCDAsyncSocket *listenerSocket;
@property (strong, nonatomic) NSMutableArray *sockets;
@property (strong, nonatomic) OSSocketReader* reader;
@property (strong, nonatomic) OSSocketWriter* writer;
@end

@implementation OSHostUser
- (NSInteger)maxCapacity {
    return 30;
}

- (instancetype)init {
    if (self = [super init]) {
        self.sockets = [[NSMutableArray alloc] initWithCapacity:[self maxCapacity]];
        self.reader = [[OSSocketReader alloc] init];
        self.reader.delegate = self;
        self.writer = [[OSSocketWriter alloc] init];
    }
    return self;
}

- (void)startMeeting {
    self.selfRepresentative.name = self.name;
    self.selfRepresentative.status = kOSSocketVoteUnknown;
    [self startBroadcast];
}

- (void)exitMeeting {
    [self stopBroadcast];
}

- (NSString*)meetingHostName {
    return self.name;
}

- (NSInteger)numberOfMembers {
    return self.sockets.count+1;
}

- (OSUserRepresentative*)memberAtIndex:(NSInteger)index {
    if(index ==0) {
        return self.selfRepresentative;
    }
    if(index>self.sockets.count)    return nil;
    return ((GCDAsyncSocket*)self.sockets[index-1]).userData;
}

- (void)vote:(NSString*)voteString {
    [super vote:voteString];
    //notify delegate about status update
    [self.delegate didUpdateUsers:[self allVoted]];
    //share the vote (status) with other members
    [self broadcastMembers:NO];
}

- (BOOL)isHost {
    return YES;
}

- (BOOL)allVoted {
    BOOL notVoted = NO;
    notVoted = ![self.selfRepresentative voted];
    if (!notVoted) {
        for (GCDAsyncSocket* sock in self.sockets) {
            notVoted = ![(OSUserRepresentative*)sock.userData voted];
            if(notVoted)    break;
        }
    }
    return !notVoted;
}

- (BOOL)allRevealed {
    BOOL notRevealed = NO;
    notRevealed = !self.selfRepresentative.revealed;
    if (!notRevealed) {
        for (GCDAsyncSocket* sock in self.sockets) {
            notRevealed = ![(OSUserRepresentative*)sock.userData revealed];
            if(notRevealed)    break;
        }
    }
    return !notRevealed;
}

- (void)revealAllVotes {
    [self broadcastMembers:YES];
    //notify delegate about status update
    [self.delegate didUpdateUsers:[self allVoted]];
}

- (void)restartMeeting {
    //inform members to reset status
    for (GCDAsyncSocket* sock in self.sockets) {
        OSUserRepresentative* member = sock.userData;
        [member reset];
        [self.writer writeMessage:@{kOSSocketEventKey:kOSSocketEventTypeHostRestart} socket:sock];
    }
    //reset self representative' status
    [self.selfRepresentative reset];
    //broadcast reset status
    [self broadcastMembers:NO];
    //notify delegate about status update
    [self.delegate didUpdateUsers:[self allVoted]];
    [self.delegate userReset];
}

- (void)welcomeSocket:(GCDAsyncSocket *)sock {
    sock.userData = [[OSUserRepresentative alloc] init];
    [self.writer writeMessage:@{kOSSocketEventKey:kOSSocketEventTypeWelcomeGuest} socket:sock];
    [self.reader installSocket:sock];
}

- (void)denySocket:(GCDAsyncSocket *)sock {
    [self.writer writeMessage:@{kOSSocketEventKey:kOSSocketEventTypeDenyGuest} socket:sock];
    [sock disconnectAfterWriting];
}

- (void)broadcastMembers:(BOOL)statusRevealed {
    NSMutableArray* allMembers = [[NSMutableArray alloc] initWithCapacity:self.sockets.count + 1];
    self.selfRepresentative.revealed = statusRevealed;
    OSUserRepresentativeSerializationType memberDict = [self.selfRepresentative serialized];
    if (memberDict) {
        [allMembers addObject:memberDict];
    }
    for (GCDAsyncSocket* sock in self.sockets) {
        OSUserRepresentative* member = sock.userData;
        member.revealed = statusRevealed;
        memberDict = [member serialized];
        if (memberDict) {
            [allMembers addObject:memberDict];
        }
    }
    if (allMembers.count > 0) {
        NSDictionary* statusInfo = @{kOSSocketEventKey:kOSSocketEventTypeHostBroadcast,
                                     kOSSocketNameKey:self.name,
                                     kOSSocketInfoKey:allMembers};
        for (GCDAsyncSocket* sock in self.sockets) {
            [self.writer writeMessage:statusInfo socket:sock];
        }
    }
}

- (void)startBroadcast {
    // Initialize GCDAsyncSocket
    self.listenerSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    // Start Listening for Incoming Connections
    NSError *error = nil;
    if ([self.listenerSocket acceptOnPort:0 error:&error]) {
        // Initialize Service
        self.publishService = [[NSNetService alloc] initWithDomain:kOSBonjourServiceDomain
                                                              type:kOSBonjourServiceType
                                                              name:self.name
                                                              port:[self.listenerSocket localPort]];
        // Configure Service
        [self.publishService setDelegate:self];
        // Publish Service
        [self.publishService publish];
    } else {
        NSLog(@"OSHostUser: Unable to create socket. Error %@ with user info %@.", error, [error userInfo]);
    }
}

- (void)stopBroadcast {
    if (self.listenerSocket) {
        self.listenerSocket.delegate = nil;
        [self.listenerSocket disconnect];
        self.listenerSocket = nil;
    }
    if (self.publishService) {
        self.publishService.delegate = nil;
        [self.publishService stop];
        self.publishService = nil;
    }
}

- (void)dealloc {
    [self stopBroadcast];
}

- (void)handleGuestVote:(NSDictionary*)response socket:(GCDAsyncSocket *)sock{
    NSString* name = response[kOSSocketNameKey];
    NSString* vote = response[kOSSocketInfoKey];
    NSAssert(sock.userData!=nil, @"Guest socket has no tag");
    OSUserRepresentative* user = sock.userData;
    user.name = name;
    user.status = vote;
    //notify delegate about status update
    [self.delegate didUpdateUsers:[self allVoted]];
    //share the vote (status) with other members
    [self broadcastMembers:NO];
}

- (void)handleGuestResponse:(NSDictionary*)response socket:(GCDAsyncSocket *)sock{
    NSString* event = response[kOSSocketEventKey];
    if ([event isEqual:kOSSocketEventTypeGuestVote]) {
        [self handleGuestVote:response socket:sock];
    }else {
        NSLog(@"Host recieved unknown response: %@",response);
    }
}

#pragma mark - OSSocketReaderDelegate
- (void)socket:(GCDAsyncSocket *)sock onMessage:(NSDictionary*)infoDict {
    if([self.sockets containsObject:sock]) {
        [self handleGuestResponse:infoDict socket:sock];
    }
}

#pragma mark - NSNetServiceDelegate
- (void)netServiceDidPublish:(NSNetService *)service {
    //NSLog(@"netServiceDidPublish: [%@:%hu]",[self.listenerSocket localHost], [self.listenerSocket localPort]);
}

- (void)netService:(NSNetService *)service didNotPublish:(NSDictionary *)errorDict {
    NSLog(@"netService (%@) didNotPublish - %@", [service name], errorDict);
    if (service == self.publishService) {
        [self stopBroadcast];
        [self startBroadcast];
    }
}

#pragma mark - GCDAsyncSocketDelegate
- (void)socket:(GCDAsyncSocket *)socket didAcceptNewSocket:(GCDAsyncSocket *)newSocket {
    //NSLog(@"Accepted New Socket from %@:%hu", [newSocket connectedHost], [newSocket connectedPort]);
    if(socket == self.listenerSocket) {
        if(self.sockets.count < [self maxCapacity]) {
            @synchronized (self){
                [self.sockets addObject:newSocket];
            }
            [self welcomeSocket:newSocket];
        }else {
            [self denySocket:newSocket];
        }
    }
}

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag {
    [self.reader socket:sock didReadData:data withTag:tag];
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)socket withError:(NSError *)error {
    //NSLog(@"socketDidDisconnect: [%@:%hu]",[self.listenerSocket localHost], [self.listenerSocket localPort]);
    
    if (self.listenerSocket == socket) {
        [self.listenerSocket setDelegate:nil];
        [self setListenerSocket:nil];
    }
    
    if ([self.sockets containsObject: socket]) {
        [socket setDelegate:nil];
        [socket setUserData:nil];
         @synchronized (self){
             [self.sockets removeObject:socket];
         }
        //notify delegate the user status has changed
        [self.delegate didUpdateUsers:[self allVoted]];
    }
}
@end
