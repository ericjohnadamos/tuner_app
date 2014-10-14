//
//  TMOProgressView.m
//  SSTuneMeOn
//
//  Created by Eric John Adamos on 6/28/14.
//  Copyright (c) 2014 Eric John Adamos. All rights reserved.
//

#import "TMOProgressView.h"
#import "TMOProgressDot.h"
#import "TMOStandardTheme.h"

@interface TMOProgressView ()

@property (nonatomic, retain) NSTimer* timer;

@property (nonatomic, assign) TMOTheme* theme;

@end

@implementation TMOProgressView

#pragma mark - Synthesize properties

@synthesize timer = m_timer;

@synthesize theme = m_theme;

#pragma mark - Memory management

- (void) dealloc
{
  self.dataSource = nil;
  self.delegate = nil;
  self.theme = nil;
  
  [self.timer invalidate];
  self.timer = nil;
  
  [super dealloc];
}

#pragma mark - Lazy loaders

- (NSTimer*) timer
{
  if (m_timer == nil)
  {
    m_timer = [[NSTimer alloc] init];
    [m_timer invalidate];
  }
  
  return m_timer;
}

- (TMOTheme*) theme
{
  if (m_theme == nil)
  {
    m_theme = [TMOStandardTheme sharedInstance];
  }
  
  return m_theme;
}

#pragma mark - User-defined methods

- (void) load
{
  /*
   * Validate protocols
   */
  bool validDataSource = (   self.dataSource != nil
                          && [self.dataSource respondsToSelector:
                              @selector(progressCountWithView:)]
                          && [self.dataSource respondsToSelector:
                              @selector(progressView:atIndex:)]);
  
  if (validDataSource)
  {
    /* Load all progress dots needed */
    NSInteger count = [self.dataSource progressCountWithView: self];
    
    for (NSInteger index = 0; index < count; index++)
    {
      UIView* view = [self.dataSource progressView: self
                                           atIndex: index];
      
      if (view != nil && [view isKindOfClass: [UIView class]])
      {
        [self addSubview: view];
      }
    }
  }
  
  [self performSelector: @selector(updateViews)
             withObject: nil
             afterDelay: 1.0f];
}

- (void) startAnimations
{
  if (   self.delegate != nil
      && [self.delegate respondsToSelector:
          @selector(progressViewAnimationInterval:)])
  {
    NSTimeInterval interval
      = [self.delegate progressViewAnimationInterval: self];
    
    self.timer
      = [NSTimer scheduledTimerWithTimeInterval: interval
                                         target: self
                                       selector: @selector(updateViews)
                                       userInfo: nil
                                        repeats: YES];
  }
}

- (void) stopAnimations
{
  [self.timer invalidate];
}

- (void) updateViews
{
  bool validDataSource = (   self.dataSource != nil
                          && [self.dataSource respondsToSelector:
                              @selector(progressCountWithView:)]);
  bool validDelegate = (   self.delegate != nil
                        && [self.delegate respondsToSelector:
                            @selector(progressView:selectStateAtIndex:)]);
  
  if (validDataSource && validDelegate)
  {
    NSInteger count = [self.dataSource progressCountWithView: self];
    
    for (NSInteger index = 0; index < count; index++)
    {
      BOOL isSelected = [self.delegate progressView: self
                                 selectStateAtIndex: index];
      
      UIView* subview = [self.subviews objectAtIndex: index];
      
      if ([subview isKindOfClass: [TMOProgressDot class]])
      {
        [((TMOProgressDot*) subview) setSelected: isSelected
                                        animated: NO];
      }
    }
  }
}

@end
