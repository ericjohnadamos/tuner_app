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
static const CGFloat kAnimationDelay = 2.0f;


@interface AppDelegate ()

@property (nonatomic, retain) TMOMainViewController* mainController;
@property (nonatomic, retain) NSArray* splashViews;

@end

@implementation AppDelegate

@synthesize window = m_window;
@synthesize mainController = m_mainController;
@synthesize splashViews = m_splashViews;

#pragma mark - Memory deallocation

- (void) dealloc
{
  self.window = nil;
  self.mainController = nil;
  self.splashViews = nil;
  
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

- (NSArray*) splashViews
{
  if (m_splashViews == nil)
  {
    CGRect windowBounds = self.window.bounds;
    
    UIView* splashOne = [[UIView alloc] initWithFrame: windowBounds];
    [splashOne autorelease];
    
    splashOne.backgroundColor = [UIColor purpleColor];
    
    NSArray* splashView = @[splashOne];
    
    m_splashViews = [splashView retain];
  }
  
  return m_splashViews;
}

#pragma mark - Application lifecycle

- (BOOL)          application: (UIApplication*) application
didFinishLaunchingWithOptions: (NSDictionary*)  launchOptions
{
  /* Override point for customization after application launch. */

  [self.window makeKeyAndVisible];
  
  /* Set the main controller as the root view controller */
  self.window.rootViewController = self.mainController;
  
  /* Insert all image views inside the window view */
  for (UIView* view in self.splashViews)
  {
    [self.window addSubview: view];
    [self.window bringSubviewToFront: view];
  }
  
  /* Getting the interface instance */
  RIOInterface* rioRef = [RIOInterface sharedInstance];
  
  /* Set sample rate and frequency */
  [rioRef setSampleRate: 44100];
  [rioRef setFrequency: 294];
  
  /* Initialize components */
  [rioRef initializeAudioSession];
  
  /* Remove the splash view */
  [self fadeSplashView];
  
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

#pragma mark - Private methods

- (void) fadeSplashView
{
  [self decrementFadeSplashViewAtIndex: self.splashViews.count - 1];
}

- (void) decrementFadeSplashViewAtIndex: (NSInteger) index
{
  if (index < 0)
  {
    self.splashViews = nil;
    
    if ([self.window.rootViewController isKindOfClass:
         [TMOMainViewController class]])
    {
      [[RIOInterface sharedInstance] startListening: self.mainController];
    }
  }
  else if (index >= 0 && index < self.splashViews.count)
  {
    UIView* splashView = self.splashViews[index];
    
    [UIView animateWithDuration: kAnimationDuration
                          delay: kAnimationDelay
                        options: UIViewAnimationOptionTransitionNone
                     animations: ^(void)
     {
       splashView.alpha = 0.0f;
     }
                     completion: ^(BOOL isFinished)
     {
       [splashView removeFromSuperview];
       
       [self decrementFadeSplashViewAtIndex: index - 1];
     }];
  }
}

@end
