//
//  AppDelegate.m
//  SSTuneMeOn
//
//  Created by Eric John Adamos <ericjohnadamos@gmail.com> on 3/10/14.
//  Copyright (c) 2014 Eric John Adamos. All rights reserved.
//

#import "AppDelegate.h"
@interface AppDelegate ()


@end


@implementation AppDelegate

- (BOOL)          application: (UIApplication*) application
didFinishLaunchingWithOptions: (NSDictionary*)  launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:
                   [[UIScreen mainScreen] bounds]];
  
    /* Override point for customization after application launch. */
  
    self.window.backgroundColor = [UIColor whiteColor];
  
    [self.window makeKeyAndVisible];
  
    return YES;
}

- (void) applicationWillResignActive: (UIApplication*) application
{
  
}

- (void) applicationDidEnterBackground: (UIApplication*) application
{
  
}

- (void) applicationWillEnterForeground: (UIApplication*) application
{
  
}

- (void) applicationDidBecomeActive: (UIApplication*) application
{
  
}

- (void) applicationWillTerminate: (UIApplication*) application
{
  
}

@end
