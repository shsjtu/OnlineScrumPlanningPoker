//
//  OSHostUser.h
//  OnlineScrumPlanningPoker
//
//  Created by SunHan on 4/13/15.
//  Copyright (c) 2015 SunHan. All rights reserved.
//

#import "OSUser.h"

@interface OSHostUser : OSUser
/*
 * Reveal all members' votes
 */
- (void)revealAllVotes;

/*
 * restart the meeting and reset all users' votes
 */
- (void)restartMeeting;
@end
