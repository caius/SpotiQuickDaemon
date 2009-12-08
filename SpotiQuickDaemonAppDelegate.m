//
//  SpotiQuickDaemonAppDelegate.m
//  SpotiQuickDaemon
//
//  Created by Caius Durling on 08/12/2009.
//  Copyright 2009 Swedish Campground Software. All rights reserved.
//

#import "SpotiQuickDaemonAppDelegate.h"

#define QTIdentifier @"com.apple.QuickTimePlayerX"

@interface SpotiQuickDaemonAppDelegate ()

- (BOOL) isQuickTimeRunning;

@end

@implementation SpotiQuickDaemonAppDelegate

@synthesize window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
  // Register to be told about launching applications
  [[[NSWorkspace sharedWorkspace] notificationCenter] addObserver:self selector:@selector(notificationReceived:) name:NSWorkspaceWillLaunchApplicationNotification object:nil];
  
  NSLog(@"Quicktime Running: %@", ([self isQuickTimeRunning] ? @"YES" : @"NO"));
}

- (void) notificationReceived:(NSNotification *)notification
{
  NSRunningApplication *app = [[notification userInfo] objectForKey:NSWorkspaceApplicationKey];
  if ([[app bundleIdentifier] isEqual:@"com.spotify.client"]) {
    NSLog(@"Spotify Launching!!");
    [self spotifyIsLaunching];
  }
}

- (void) spotifyIsLaunching
{
  // If QT is running we don't care about anything else (yet?)
  if ([self isQuickTimeRunning]) {
    NSLog(@"Quicktime is running");
    return;
  }

  NSLog(@"Quicktime not running");
  // It's not running, we need to open it and hide it
  [[NSWorkspace sharedWorkspace] launchAppWithBundleIdentifier:QTIdentifier options:NSWorkspaceLaunchWithoutActivation|NSWorkspaceLaunchAndHide additionalEventParamDescriptor:nil launchIdentifier:nil];
}

#pragma mark Private Methods

- (BOOL) isQuickTimeRunning
{
  // figure this out, QTIdentifier might be useful
  return [[NSRunningApplication runningApplicationsWithBundleIdentifier:QTIdentifier] count] != 0;
}

@end
