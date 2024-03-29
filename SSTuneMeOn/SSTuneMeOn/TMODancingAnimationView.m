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

@property (nonatomic, strong) CALayer* dancerLayer;
@property (nonatomic, strong) CAKeyframeAnimation* defaultAnimation;
@property (nonatomic, strong) CAKeyframeAnimation* nextAnimation;
@property (nonatomic, strong) NSArray* animationKeys;
@property (nonatomic, strong) NSMutableArray* animationStack;
@property (nonatomic, strong) NSMutableArray* animationQueue;
@property (nonatomic, strong) dispatch_queue_t processQueue;

@end

@implementation TMODancingAnimationView

#pragma mark - Synthesis

@synthesize dancerLayer = m_dancerLayer;
@synthesize defaultAnimation = m_defaultAnimation;
@synthesize animationQueue = m_animationQueue;
@synthesize processQueue = m_processQueue;
@synthesize nextAnimation = m_nextAnimation;
@synthesize animationKeys = m_animationKeys;
@synthesize animationStack = m_animationStack;

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

    [self loadNextAnimation];
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

- (NSArray*) animationKeys
{
  if (m_animationKeys == nil)
  {
    m_animationKeys
      = [[NSArray alloc] initWithObjects:
          kAnimationKeyDance1,
          kAnimationKeyDance2,
          kAnimationKeyDance3,
          kAnimationKeyDance4,
          kAnimationKeyDance5,
          kAnimationKeyDance6,
          kAnimationKeyDance7,
          nil];
  }
  return m_animationKeys;
}

- (NSMutableArray*) animationStack
{
  if (m_animationStack == nil)
  {
    m_animationStack = [NSMutableArray new];
  }
  return m_animationStack;
}

#pragma mark - Private methods

- (void) animationDidStop: (CAAnimation*) anim
                 finished: (BOOL)         flag
{
  [self.dancerLayer removeAllAnimations];
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

- (void) loadNextAnimation
{
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^
  {
    if (self.animationStack.count == 0)
    {
      [self.animationStack addObjectsFromArray: self.animationKeys];
    }
    
    /* Randomly get next animation from animation stack */
    NSInteger nextAnimIndex =  arc4random() % self.animationStack.count;
    
    NSString* nextAnimationKey
      = [self.animationStack objectAtIndex: nextAnimIndex];
    [self.animationStack removeObjectAtIndex: nextAnimIndex];
    
    self.nextAnimation
      = [[TMOAnimationHelper sharedHelper]
          animationForKey: nextAnimationKey];
    
    self.nextAnimation.delegate = self;
  });
}

- (void) enqueueNextAnimation
{
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^
  {
    if (self.nextAnimation != nil)
    {
      [self.animationQueue addObject: self.nextAnimation];
      
      self.nextAnimation = nil;
      [self loadNextAnimation];
    }
  });
}

@end
