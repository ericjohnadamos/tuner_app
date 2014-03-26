//
//  TMOSplashViewController.m
//  SSTuneMeOn
//
//  Created by Eric John Adamos <ericjohnadamos@gmail.com> on 3/10/14.
//  Copyright (c) 2014 Eric John Adamos. All rights reserved.
//

#import "TMOSplashViewController.h"

static const CGFloat kAnimationDelay = 2.0f;
static const CGFloat kAnimationDuration = 0.35f;

@implementation TMOSplashViewController

#pragma mark - Synthesize properties

@synthesize delegate = m_delegate;
@synthesize datasource = m_datasource;

#pragma mark - Memory management

- (void) didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
}

- (void) dealloc
{
  self.delegate = nil;
  self.datasource = nil;
  
  [super dealloc];
}

#pragma mark - Application lifecycle

- (void) viewDidLoad
{
  [super viewDidLoad];
- (void) removeSubviewsFromLastIndex: (NSInteger) index;
{
  if (index == 0)
  {
    [self performSelector: @selector(didFinishSplashView)
               withObject: nil
               afterDelay: kAnimationDelay];
  }
  else
  {
    UIView* currentView = [self.view viewWithTag: index];
    
    [UIView animateWithDuration: kAnimationDuration
                          delay: kAnimationDelay
                        options: UIViewAnimationOptionTransitionNone
                     animations: ^(void)
     {
       currentView.alpha = 0.0f;
     }
                     completion: ^(BOOL isFinished)
     {
       [currentView removeFromSuperview];
       
       return [self removeSubviewsFromLastIndex: index - 1];
     }];
  }
}

- (void) didFinishSplashView
{
  if ([self.delegate respondsToSelector:
       @selector(splashViewControllerDidFinishDisplayViews:)])
  {
    [self.delegate splashViewControllerDidFinishDisplayViews: self];
  }
}

@end
