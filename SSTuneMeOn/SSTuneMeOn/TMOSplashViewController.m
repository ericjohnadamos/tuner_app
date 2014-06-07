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

#pragma mark - Memory management

- (void) didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
}

- (void) dealloc
{
  self.delegate = nil;
  
  [super dealloc];
}

#pragma mark - Application lifecycle

- (void) viewDidLoad
{
  [super viewDidLoad];
  
  BOOL isAnimated = YES;
  
  if (   self.delegate != nil
      && [self.delegate respondsToSelector: @selector(displayWithAnimations)])
  {
    isAnimated = [self.delegate displayWithAnimations];
  }
  
  [self displaySplashViewAnimated: isAnimated];
}

#pragma mark - Private methods

- (void) displaySplashViewAnimated: (BOOL) animated
{
  /* Delegate should be implemented in order to handle the animations */
  if (self.datasource != nil)
  {
    NSInteger splashViewCount = 0;
    if ([self.datasource respondsToSelector: @selector(numberOfSplashViews)])
    {
      splashViewCount = [self.datasource numberOfSplashViews];
    }
    
    /* Add all views as a subview */
    for (NSInteger index = 0; index < splashViewCount; index++)
    {
      if ([self.datasource respondsToSelector:
           @selector(splashViewController:viewAtIndex:)])
      {
        NSInteger representedIndex
          = ABS(((index - (splashViewCount - 1)) % splashViewCount));
        
        UIView* presentedView
          = [self.datasource splashViewController: self
                                    viewAtIndex: representedIndex];
        presentedView.tag = index;
        
        [self.view addSubview: presentedView];
      }
    }
    
    /* Dissolve animate them */
    if (animated)
    {
      [self removeSubviewsFromLastIndex: splashViewCount - 1];
    }
    else
    {
      for (UIView* subview in [self.view subviews])
      {
        [subview removeFromSuperview];
      }
      
      [self didFinishSplashView];
    }
  }
  else
  {
    [self didFinishSplashView];
  }
}

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
