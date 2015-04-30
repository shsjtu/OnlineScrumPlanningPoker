//
//  OSSocketReader.h
//  OnlineScrumPlanningPoker
//
//  Created by SunHan on 4/27/15.
//  Copyright (c) 2015 SunHan. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GCDAsyncSocket;
@protocol OSSocketReaderDelegate;
@interface OSSocketReader : NSObject
@property (assign) id <OSSocketReaderDelegate> delegate;

- (void)installSocket:(GCDAsyncSocket*)socket;
- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag;
@end

@protocol OSSocketReaderDelegate <NSObject>
- (void)socket:(GCDAsyncSocket *)sock onMessage:(NSDictionary*)infoDict;
@end


