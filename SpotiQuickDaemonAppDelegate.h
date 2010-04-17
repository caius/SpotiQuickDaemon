//
//  SpotiQuickDaemonAppDelegate.h
//  SpotiQuickDaemon
//
//  Created by Caius Durling on 08/12/2009.
//  Copyright 2009 Swedish Campground Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface SpotiQuickDaemonAppDelegate : NSObject <NSApplicationDelegate> {
}

- (void) launchedNotificationReceived:(NSNotification *)notification;
- (void) terminationNotificationReceived:(NSNotification *)notification;
- (void) spotifyIsLaunching;

@end
