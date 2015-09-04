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
 * Restart the meeting and reset all users' votes
 */
- (void)restartMeeting;

/*
 * If everyone in the room has voted
 */
- (BOOL)allRevealed;
@end
