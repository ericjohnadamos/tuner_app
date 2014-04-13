//
//  AppDelegate.m
//  SSTuneMeOn
//
//  Created by Eric John Adamos <ericjohnadamos@gmail.com> on 3/10/14.
//  Copyright (c) 2014 Eric John Adamos. All rights reserved.
//

#import "AppDelegate.h"
#import "RIOInterface.h"

#import "TMOMainViewController.h"
#import "TMOSplashView.h"

@interface AppDelegate () <TMOSplashViewDelegate>

@property (nonatomic, retain) TMOMainViewController* mainController;

@property (nonatomic, retain) TMOSplashView* splashView;

@end

@implementation AppDelegate

@synthesize window = m_window;
@synthesize mainController = m_mainController;
@synthesize splashView = m_splashView;

#pragma mark - Memory deallocation

- (void) dealloc
{
  self.window = nil;
  self.mainController = nil;
  self.splashView = nil;
  
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

- (TMOSplashView*) splashView
{
  if (m_splashView == nil)
  {
    CGRect windowBounds = self.window.bounds;
    
    UIImageView* firstImageView = [[UIImageView alloc] initWithImage:
                                   [UIImage imageNamed: @"splash-one"]];
    firstImageView.frame = windowBounds;
    
    TMOSplashView* splashView
      = [[TMOSplashView alloc] initWithViews: @[[firstImageView autorelease]]];
    splashView.delegate = self;
    
    m_splashView = splashView;
  }
  
  return m_splashView;
}

#pragma mark - Application lifecycle

- (BOOL)          application: (UIApplication*) application
didFinishLaunchingWithOptions: (NSDictionary*)  launchOptions
{
  [[UIApplication sharedApplication] setStatusBarStyle:
   UIStatusBarStyleLightContent];
  
  /* Override point for customization after application launch. */

  [self.window makeKeyAndVisible];
  
  /* Set the main controller as the root view controller */
  self.window.rootViewController = self.mainController;
  
  /* Insert all image views inside the window view */
  [self.window addSubview: self.splashView];
  
  /* Load and animate splash view */
  [self.splashView renderViews];
  [self.splashView animateFadeSplashView];
  
  /* Getting the interface instance */
  RIOInterface* rioRef = [RIOInterface sharedInstance];
  
  /* Set sample rate and frequency
   * Default sample rate is 44.1k Hz
   */
  [rioRef setSampleRate: 33100];
  [rioRef setFrequency: 294];
  
  /* Initialize components */
  [rioRef initializeAudioSession];
  [rioRef startPlayback];
  [rioRef stopPlayback];
  
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

#pragma mark - TMOSplashViewDelegate method

- (void) splashViewDidFinishRenderingViews: (TMOSplashView*) splashView
{
  if (self.splashView.superview != nil)
  {
    [self.splashView removeFromSuperview];
  }
  
  if ([self.window.rootViewController isKindOfClass:
       [TMOMainViewController class]])
  {
    [[RIOInterface sharedInstance] startListening: self.mainController];
  }
}

@end
