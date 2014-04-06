//
//  TMOTutorialView.m
//  SSTuneMeOn
//
//  Created by Eric John Adamos <ericjohnadamos@gmail.com> on 4/6/14.
//  Copyright (c) 2014 Eric John Adamos. All rights reserved.
//

#import "TMOTutorialView.h"

@interface TMOTutorialView ()

@property (nonatomic, retain) UILabel* tutorialLabel;

@end

@implementation TMOTutorialView

@synthesize tutorialLabel = m_tutorialLabel;

#pragma mark - Memory management

- (void) dealloc
{
  self.tutorialLabel = nil;
  
  [super dealloc];
}

#pragma mark - Initializer

- (id) initWithFrame: (CGRect) frame
{
  self = [super initWithFrame: frame];
  
  if (self != nil)
  {
    /* TODO: Initialze here */
  }
  
  return self;
}

#pragma mark - Lazy loaders

- (UILabel*) tutorialLabel
{
  if (m_tutorialLabel == nil)
  {
    /* TODO: Implement me */
  }
  
  return m_tutorialLabel;
}

@end
