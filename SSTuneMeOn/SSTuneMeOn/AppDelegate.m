//
//  AppDelegate.m
//  SSTuneMeOn
//
//  Created by Eric John Adamos <ericjohnadamos@gmail.com> on 3/10/14.
//  Copyright (c) 2014 Eric John Adamos. All rights reserved.
//

#import "AppDelegate.h"

#import "RIOInterface.h"
#import "TMOSplashViewController.h"
#import "TMOMainViewController.h"

static const CGFloat kAnimationDuration = 0.35f;


@interface AppDelegate () <TMOSplashViewDelegate, TMOSplashViewDatasource>

@property (nonatomic, retain) TMOSplashViewController* splashController;

@end


@implementation AppDelegate

@synthesize splashController = m_splashController;

#pragma mark - Memory deallocation

- (void) dealloc
{
  self.window = nil;
  self.splashController = nil;
  
  [super dealloc];
}

#pragma mark - Lazy loaders

- (TMOSplashViewController*) splashController
{
  if (m_splashController == nil)
  {
    TMOSplashViewController* splashController
      = [[TMOSplashViewController alloc] init];
    
    m_splashController = splashController;
  }
  
  return m_splashController;
}

#pragma mark - Application lifecycle

- (BOOL)          application: (UIApplication*) application
didFinishLaunchingWithOptions: (NSDictionary*)  launchOptions
{
  self.window = [[UIWindow alloc] initWithFrame:
                 [[UIScreen mainScreen] bounds]];
  
  /* Override point for customization after application launch. */
  
  self.window.backgroundColor = [UIColor whiteColor];
  
  [self.window makeKeyAndVisible];
  
  self.window.rootViewController = self.splashController;
  /* Getting the interface instance */
  RIOInterface* rioRef = [RIOInterface sharedInstance];
  
  /* Set sample rate and frequency */
  [rioRef setSampleRate: 44100];
  [rioRef setFrequency: 294];
  
  /* Initialize components */
  [rioRef initializeAudioSession];
  
  /* Insert the splash view controller */
  TMOSplashViewController* splashViewController
    = [[[TMOSplashViewController alloc] init] autorelease];
  splashViewController.delegate = self;
  splashViewController.datasource = self;
  
  self.window.rootViewController = splashViewController;
  
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

#pragma mark - TMOSplashViewDelegate method

- (BOOL) displayWithAnimations
{
  return YES;
}

- (void) splashViewControllerDidFinishDisplayViews:
  (TMOSplashViewController*) controller
{
  TMOMainViewController* mainViewController
    = [[[TMOMainViewController alloc] init] autorelease];
  
  [UIView transitionWithView: self.window
                    duration: kAnimationDuration
                     options: UIViewAnimationOptionTransitionCrossDissolve
                  animations: ^(void)
   {
     self.window.rootViewController = mainViewController;
   }
                  completion: nil];
}

@end
