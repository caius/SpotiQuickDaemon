//
//  SpotiQuickDaemonAppDelegate.h
//  SpotiQuickDaemon
//
//  Created by Caius Durling on 08/12/2009.
//  Copyright 2009 Swedish Campground Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface SpotiQuickDaemonAppDelegate : NSObject <NSApplicationDelegate> {
    NSWindow *window;
}

@property (assign) IBOutlet NSWindow *window;

- (void) notificationReceived:(NSNotification *)notification;
- (void) spotifyIsLaunching;

@end
