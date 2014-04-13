//
//  TMOSplashView.m
//  SSTuneMeOn
//
//  Created by Eric John Adamos <ericjohnadamos@gmail.com> on 4/6/14.
//  Copyright (c) 2014 Eric John Adamos. All rights reserved.
//

static const CGFloat kAnimationDuration = 0.35f;
static const CGFloat kAnimationDelay = 2.0f;

#import "TMOSplashView.h"

@implementation TMOSplashView

#pragma mark - Synthesize properties

@synthesize delegate = m_delegate;
@synthesize views = m_views;

#pragma mark - Memory management

- (void) dealloc
{
  self.delegate = nil;
  
  self.views = nil;
  
  [super dealloc];
}

#pragma mark - Initializer

- (id) initWithViews: (NSArray*) views
{
  self = [super init];
  
  if (self != nil)
  {
    self.views = views;
  }
  
  return self;
}

#pragma mark - Lazy loader

- (NSArray*) views
{
  if (m_views == nil)
  {
    UIView* splashOne = [[UIView alloc] initWithFrame: self.bounds];
    [splashOne autorelease];
    
    splashOne.backgroundColor = [UIColor blackColor];
    
    NSArray* views
      = [[NSArray alloc] initWithObjects: splashOne, nil];
    
    m_views = views;
  }
  
  return m_views;
}

- (void) renderViews
{
  for (id view in self.views)
  {
    /* Insert all image views inside the splash view */
    if ([view isKindOfClass: [UIView class]])
    {
      [self addSubview: view];
      [self bringSubviewToFront: view];
    }
  }
}

- (void) animateFadeSplashView
{
  [self decrementFadeSplashViewAtIndex: self.views.count - 1];
}

- (void) decrementFadeSplashViewAtIndex: (NSInteger) index
{
  if (index < 0)
  {
    self.views = nil;
    
    if (   self.delegate != nil
        && [self.delegate respondsToSelector:
            @selector(splashViewDidFinishRenderingViews:)])
    {
      [self.delegate splashViewDidFinishRenderingViews: self];
    }
  }
  else if (index >= 0 && index < self.views.count)
  {
    UIView* splashView = self.views[index];
    
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
