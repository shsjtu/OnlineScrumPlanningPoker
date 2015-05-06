//
//  Constants.h
//  OnlineScrumPlanningPoker
//
//  Created by SunHan on 4/12/15.
//  Copyright (c) 2015 SunHan. All rights reserved.
//

#ifndef OnlineScrumPlanningPoker_Constants_h
#define OnlineScrumPlanningPoker_Constants_h

#define kOSSegueIdMasterToHostsBrowser @"MasterToBrowserSegue"
#define kOSSegueIdHostToMeetingRoom @"HostToMeetingRoomSegue"
#define kOSSegueIdGuestToMeetingRoom @"GuestToMeetingRoomSegue"

#define kOSBonjourServiceType @"_online_scrum_services._tcp."
#define kOSBonjourServiceDomain @"local."

typedef enum OSEstimationSize{
    kOSEstimationSize_Reserved = 0,
    kOSEstimationSize_XS,
    kOSEstimationSize_S,
    kOSEstimationSize_M,
    kOSEstimationSize_L,
    kOSEstimationSize_XL,
    kOSEstimationSize_2XL,
    kOSEstimationSize_3XL,
    kOSEstimationSize_4XL,
    kOSEstimationSize_5XL,
    kOSEstimationSize_Customize
} OSEstimationSize;

static NSString* kOSEstimationSizeStringSet[] = {@"Reserved",@"XS",@"S",@"M",@"L",@"XL",@"2XL",@"3XL",@"4XL",@"5XL",@"Customize"};
static NSInteger kOSEstimationSizePointSet[] = {0,1,2,3,5,8,13,21,34,55,-1};

//socket constants
static const NSInteger kOSSocketHeaderTag = 1;
static const NSInteger kOSSocketPayloadTag = 2;

#define kOSSocketEventKey @"SocketEventKey"
#define kOSSocketEventTypeWelcomeGuest @"SocketEventTypeWelcomeGuest"
#define kOSSocketEventTypeDenyGuest @"SocketEventTypeDenyGuest"
#define kOSSocketEventTypeGuestVote @"SocketEventTypeGuestVote"
#define kOSSocketEventTypeHostBroadcast @"SocketEventTypeHostBroadcast"

#define kOSSocketNameKey @"SocketNameKey"
#define kOSSocketInfoKey @"SocketInfoKey"

#define kOSSocketVoteUnknown @"?"
#define kOSSocketVoteTBR @"√"

#endif
