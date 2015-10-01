//
//  OSHostUserTests.m
//  OnlineScrumPlanningPoker
//
//  Created by SunHan on 10/1/15.
//  Copyright © 2015 SunHan. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "OSHostUser.h"
#import "OSUserRepresentative.h"
#import "OSConstants.h"

@interface OSHostUserTests : XCTestCase
@property (nonatomic, strong) OSHostUser *host;
@end

@implementation OSHostUserTests

- (void)setUp {
    [super setUp];
    self.host = [[OSHostUser alloc] init];
    self.host.name = @"Allen";
    [self.host startMeeting];
}

- (void)tearDown {
    [self.host exitMeeting];
    [super tearDown];
}

- (void)testHostName {
    XCTAssertEqualObjects(self.host.selfRepresentative.name, @"Allen", @"Host name not correct");
    XCTAssertEqualObjects([self.host meetingHostName], @"Allen", @"Host name not correct");
}


- (void)testNumberOfMembers {
    XCTAssertEqual([self.host numberOfMembers], 1, @"Host name not correct");
}

- (void)testMemberAtIndex {
     XCTAssertEqual([self.host memberAtIndex:0], self.host.selfRepresentative, @"Member not correct at [0]");
     XCTAssertEqual([self.host memberAtIndex:1], nil,  @"Member not correct at [1]");
}

- (void)testRevealAllVotes {
    [self.host restartMeeting];
    XCTAssertEqual([self.host allRevealed], false, @"RevealAllVotes not correct after restart meeting");
    [self.host revealAllVotes];
    XCTAssertEqual([self.host allRevealed], true, @"RevealAllVotes not correct after revealAllVotes");
}

- (void)testVote {
    [self.host restartMeeting];
    XCTAssertEqualObjects(self.host.selfRepresentative.status, kOSSocketVoteUnknown, @"Status not correct after restart meeting");
    [self.host vote: @"8"];
    [self.host revealAllVotes];
    XCTAssertEqualObjects(self.host.selfRepresentative.status, @"8", @"Status not correct after vote");
}





@end
