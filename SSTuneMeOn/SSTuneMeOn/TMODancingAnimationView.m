//
//  TMODancingAnimationView.m
//  SSTuneMeOn
//
//  Created by Eric John Adamos <ericjohnadamos@gmail.com> on 3/28/14.
//  Copyright (c) 2014 Eric John Adamos. All rights reserved.
//

#import "TMODancingAnimationView.h"
#import <CoreGraphics/CoreGraphics.h>
@interface TMODancingAnimationView ()

@property (nonatomic, retain) CALayer* dancerLayer;
@property (nonatomic, retain) CAKeyframeAnimation* defaultAnimation;
@property (nonatomic, retain) NSMutableArray* animationQueue;
@property (nonatomic, assign) dispatch_queue_t processQueue;

@end

@implementation TMODancingAnimationView

#pragma mark - Synthesis

@synthesize dancerLayer = m_dancerLayer;
@synthesize defaultAnimation = m_defaultAnimation;
@synthesize animationQueue = m_animationQueue;
@synthesize processQueue = m_processQueue;

#pragma mark - Memory management

- (void) dealloc
{
  self.dancerLayer = nil;
  self.defaultAnimation = nil;
  self.animationQueue = nil;

  [super dealloc];
}

#pragma mark - Intialisation

- (id) initWithFrame: (CGRect) frame
{
  if (self = [super initWithFrame: frame])
  {
    [self.layer addSublayer: self.dancerLayer];
    
    self.defaultAnimation
      = [[TMOAnimationHelper sharedHelper]
          animationForKey: kAnimationKeyDefault];
    
    self.defaultAnimation.delegate = self;
  }
  return self;
}

@end
