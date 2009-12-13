//
//  SpotiQuickDaemonAppDelegate.m
//  SpotiQuickDaemon
//
//  Created by Caius Durling on 08/12/2009.
//  Copyright 2009 Swedish Campground Software. All rights reserved.
//

#import "SpotiQuickDaemonAppDelegate.h"

// CFBundleIdentifier's
#define SQDQuickTimeIdentifier @"com.apple.QuickTimePlayerX"
#define SQDSpotifyIdentifier @"com.spotify.client"

@interface SpotiQuickDaemonAppDelegate ()

- (BOOL) isQuickTimeRunning;
- (BOOL) isSpotifyRunning;
- (BOOL) isApplicationRunningWithBundleIdentifier:(NSString *)identifier;

@end

@implementation SpotiQuickDaemonAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
  // Register to be told about launching applications
  [[[NSWorkspace sharedWorkspace] notificationCenter] addObserver:self selector:@selector(notificationReceived:) name:NSWorkspaceWillLaunchApplicationNotification object:nil];
  
  if ([self isSpotifyRunning]) {
    [self spotifyIsLaunching];
  }
}

- (BOOL)applicationShouldHandleReopen:(NSApplication *)theApplication hasVisibleWindows:(BOOL)flag
{
  if ([self isSpotifyRunning]) {
    [self spotifyIsLaunching];
  }

  return YES;
}

- (void) notificationReceived:(NSNotification *)notification
{
  NSRunningApplication *app = [[notification userInfo] objectForKey:NSWorkspaceApplicationKey];
  // Check if spotify is being launched
  if ([[app bundleIdentifier] isEqual:SQDSpotifyIdentifier]) {
    // And then act accordingly
    [self spotifyIsLaunching];
  }
}

// Triggered when spotify is launching, and acts accordingly by opening quicktime.
- (void) spotifyIsLaunching
{
  // If QT is running we don't care about anything else, just exit
  if ([self isQuickTimeRunning])
    return;

  // It's not running, we need to open it and hide it
  // NSWorkspaceLaunchAndHide only seems to work the first time for some reason.
  int launchOptions = NSWorkspaceLaunchWithoutActivation|NSWorkspaceLaunchAndHide;
  [[NSWorkspace sharedWorkspace] launchAppWithBundleIdentifier:SQDQuickTimeIdentifier
                                                       options:launchOptions
                                additionalEventParamDescriptor:nil
                                              launchIdentifier:nil];
}

#pragma mark Private Methods

// Works out if Quicktime is open
- (BOOL) isQuickTimeRunning
{
  return [self isApplicationRunningWithBundleIdentifier:SQDQuickTimeIdentifier];
}

- (BOOL) isSpotifyRunning
{
  return [self isApplicationRunningWithBundleIdentifier:SQDSpotifyIdentifier];
}

- (BOOL) isApplicationRunningWithBundleIdentifier:(NSString *)identifier
{
  // figure this out, QTIdentifier might be useful
  return [[NSRunningApplication runningApplicationsWithBundleIdentifier:identifier] count] != 0;
}

@end
