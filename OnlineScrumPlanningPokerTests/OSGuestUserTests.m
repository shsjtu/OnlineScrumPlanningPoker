//
//  OSGuestUserTests.m
//  OnlineScrumPlanningPoker
//
//  Created by SunHan on 10/1/15.
//  Copyright © 2015 SunHan. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "OSGuestUser.h"

@interface OSGuestUserTests : XCTestCase
@property (nonatomic, strong) OSGuestUser *guest;
@end

@implementation OSGuestUserTests

- (void)setUp {
    [super setUp];
    self.guest = [[OSGuestUser alloc] init];
    self.guest.name = @"Sam";
    [self.guest startMeeting];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testNumberOfMembers {
    XCTAssertEqual(self.guest.numberOfMembers, 0, @"Host name not correct");
}
@end
