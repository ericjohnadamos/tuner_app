//
//  AppDelegate.m
//  SSTuneMeOn
//
//  Created by Eric John Adamos <ericjohnadamos@gmail.com> on 3/10/14.
//  Copyright (c) 2014 Eric John Adamos. All rights reserved.
//

#import "AppDelegate.h"
#import "RIOInterface.h"

#import "TMOUserSettings.h"

#import "TMOMainViewController.h"

#import "TMOAnimationHelper.h"

@interface AppDelegate ()

@property (nonatomic, retain) TMOMainViewController* mainController;

@end

@implementation AppDelegate

@synthesize window = m_window;
@synthesize mainController = m_mainController;

#pragma mark - Memory deallocation

- (void) dealloc
{
  self.window = nil;
  self.mainController = nil;
  
  [super dealloc];
}

#pragma mark - Lazy loaders

- (TMOMainViewController*) mainController
{
  if (m_mainController == nil)
  {
    TMOMainViewController* mainController
      = [[TMOMainViewController alloc] init];
    
    m_mainController = mainController;
  }
  
  return m_mainController;
}

- (UIWindow*) window
{
  if (m_window == nil)
  {
    CGRect rect = [[UIScreen mainScreen] bounds];
    UIWindow* window = [[UIWindow alloc] initWithFrame: rect];
    
    m_window = window;
  }
  
  return m_window;
}

#pragma mark - Application lifecycle

- (BOOL)          application: (UIApplication*) application
didFinishLaunchingWithOptions: (NSDictionary*)  launchOptions
{
  [[UIApplication sharedApplication] setStatusBarStyle:
   UIStatusBarStyleLightContent];
  
  /* Getting the interface instance */
  RIOInterface* rioRef = [RIOInterface sharedInstance];
  
  /* Set sample rate and frequency
   * Default sample rate is 44.1k Hz
   */
  [rioRef setSampleRate: 44100];
  [rioRef setFrequency: 294];
  
  /* Initialize components */
  [rioRef initializeAudioSession];
  
  /* Override point for customization after application launch. */

  [self.window makeKeyAndVisible];
  
  /* Set the main controller as the root view controller */
  self.window.rootViewController = self.mainController;
  
  /* Check if the defaults are loaded */
  TMOUserSettings* userSettings = [TMOUserSettings sharedInstance];
  if (![userSettings isDefaultsLoaded])
  {
    [userSettings loadDefaults];
  }
  
  return YES;
}

- (void) applicationWillResignActive: (UIApplication*) application
{
  /* TODO: Implement me */
}

- (void) applicationDidEnterBackground: (UIApplication*) application
{
  /* TODO: Implement me */
}

- (void) applicationWillEnterForeground: (UIApplication*) application
{
  /* TODO: Implement me */
}

- (void) applicationDidBecomeActive: (UIApplication*) application
{
  /* TODO: Implement me */
}

- (void) applicationWillTerminate: (UIApplication*) application
{
  /* TODO: Implement me */
}

@end
