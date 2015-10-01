//
//  OnlineScrumPlanningPokerTests.m
//  OnlineScrumPlanningPokerTests
//
//  Created by SunHan on 3/5/15.
//  Copyright (c) 2015 SunHan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "OSUserRepresentative.h"
#import "OSConstants.h"

@interface OSUserRepresentativeTests : XCTestCase
@property (nonatomic, strong) OSUserRepresentative * userRep;
@end

@implementation OSUserRepresentativeTests

- (void)setUp {
    [super setUp];
    self.userRep = [[OSUserRepresentative alloc] initWithDictionary:@{@"Peter": @"55"}];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testInit {
    OSUserRepresentative *newUserRep = [[OSUserRepresentative alloc] initWithDictionary:@{@"Peter": @"55"}];
    XCTAssertEqualObjects(newUserRep.name, @"Peter", @"Name not correct");
    XCTAssertEqualObjects(newUserRep.status, kOSSocketVoteTBR, @"Status not correct");
}

- (void)testVoted {
    self.userRep.status = @"55";
    XCTAssertEqual(self.userRep.voted, true, @"voted not correct");
    [self.userRep reset];
    XCTAssertEqual(self.userRep.voted, false, @"voted not correct after reset");
}

- (void)testVoteRevealed {
    self.userRep.status = @"1";
    XCTAssertEqual([self.userRep voteRevealed], true, @"voteRevealed not correct");
    [self.userRep reset];
    XCTAssertEqual([self.userRep voteRevealed], false, @"voteRevealed not correct after reset");
    self.userRep.status = kOSSocketVoteTBR;
    XCTAssertEqual([self.userRep voteRevealed], false, @"voteRevealed not correct after set TBR");
}

- (void)testSerialized {
    self.userRep.status = @"3";
    self.userRep.revealed = NO;
    XCTAssertEqualObjects(self.userRep.serialized.description, @{@"Peter": kOSSocketVoteTBR}.description, @"serialized not correct before revealed");
    self.userRep.revealed = YES;
    XCTAssertEqualObjects(self.userRep.serialized.description, @{@"Peter": @"3"}.description, @"serialized not correct after revealed");
    [self.userRep reset];
    XCTAssertEqualObjects(self.userRep.serialized, @{@"Peter": kOSSocketVoteUnknown}, @"serialized not correct after reset");
}

@end
