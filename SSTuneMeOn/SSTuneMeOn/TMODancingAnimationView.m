//
//  TMODancingAnimationView.m
//  SSTuneMeOn
//
//  Created by Eric John Adamos <ericjohnadamos@gmail.com> on 3/28/14.
//  Copyright (c) 2014 Eric John Adamos. All rights reserved.
//

#import "TMODancingAnimationView.h"
#import <CoreGraphics/CoreGraphics.h>
#import "TMOAnimationHelper.h"

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

#pragma mark - Getters

- (CALayer*) dancerLayer
{
  if (m_dancerLayer == nil)
  {
    CGFloat width = 320.0f;
    CGFloat height = 333.0f;
    
    m_dancerLayer = [CALayer layer];
    m_dancerLayer.frame = CGRectMake(0.0f, 0.0f, width, height);
  }
  return m_dancerLayer;
}

- (NSMutableArray*) animationQueue
{
  if (m_animationQueue == nil)
  {
    m_animationQueue = [NSMutableArray new];
  }
  return m_animationQueue;
}

- (dispatch_queue_t) processQueue
{
  if (m_processQueue == nil)
  {
    m_processQueue = dispatch_queue_create("TMODancingAnimationQueueName",
                                           DISPATCH_QUEUE_SERIAL);
  }
  return m_processQueue;
}

#pragma mark - Private methods

- (void) animationDidStop: (CAAnimation*) anim
                 finished: (BOOL)flag
{
  if (self.animationQueue.count == 0)
  {
    [self.dancerLayer addAnimation: self.defaultAnimation
                            forKey: @"contents"];
  }
  else
  {
    CAKeyframeAnimation* animation = [self.animationQueue lastObject];
    
    /* Apply animation and remove from queue */
    [self.dancerLayer addAnimation: animation
                            forKey: @"contents"];
    [self.animationQueue removeLastObject];
    
  }
}

#pragma mark - Public methods

- (void) startAnimating
{
  [self.dancerLayer addAnimation: self.defaultAnimation
                          forKey: @"contents"];
}

- (void) enqueueAnimationWithKey: (NSString*) animationKey
{
  CAKeyframeAnimation* animation
    = [[TMOAnimationHelper sharedHelper]
        animationForKey: animationKey];
  
  animation.delegate = self;
  
  [self.animationQueue addObject: animation];
}

@end
