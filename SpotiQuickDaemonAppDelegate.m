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

- (void) quicktimeWasTerminated;
- (void) launchQuicktime;
- (BOOL) isQuickTimeRunning;
- (BOOL) isSpotifyRunning;
- (BOOL) isApplicationRunningWithBundleIdentifier:(NSString *)identifier;

@end

@implementation SpotiQuickDaemonAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
  // Register to be told about launching applications
  [[[NSWorkspace sharedWorkspace] notificationCenter] addObserver:self selector:@selector(launchedNotificationReceived:) name:NSWorkspaceWillLaunchApplicationNotification object:nil];
  [[[NSWorkspace sharedWorkspace] notificationCenter] addObserver:self selector:@selector(terminationNotificationReceived:) name:NSWorkspaceDidTerminateApplicationNotification object:nil];
  
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

- (void) launchedNotificationReceived:(NSNotification *)notification
{
  NSRunningApplication *app = [[notification userInfo] objectForKey:NSWorkspaceApplicationKey];
  // Check if spotify is being launched
  if ([[app bundleIdentifier] isEqual:SQDSpotifyIdentifier]) {
    // And then act accordingly
    [self spotifyIsLaunching];
  }
}

- (void) terminationNotificationReceived:(NSNotification*)notification
{
  NSRunningApplication *app = [[notification userInfo] objectForKey:NSWorkspaceApplicationKey];
  if ([[app bundleIdentifier] isEqual:SQDQuickTimeIdentifier]) {
    [self quicktimeWasTerminated];
  }
}

// Triggered when spotify is launching, and acts accordingly by opening quicktime.
- (void) spotifyIsLaunching
{
  // If QT isn't open, open it
  if (![self isQuickTimeRunning])
    [self launchQuicktime];
}

#pragma mark Private Methods

- (void) quicktimeWasTerminated
{
  if ([self isSpotifyRunning])
    [self launchQuicktime];
}


- (void) launchQuicktime
{
  // we need to open it and hide it
  // NSWorkspaceLaunchAndHide only seems to work the first time for some reason.
  int launchOptions = NSWorkspaceLaunchWithoutActivation|NSWorkspaceLaunchAndHide;
  [[NSWorkspace sharedWorkspace] launchAppWithBundleIdentifier:SQDQuickTimeIdentifier
                                                       options:launchOptions
                                additionalEventParamDescriptor:nil
                                              launchIdentifier:nil];
}

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
