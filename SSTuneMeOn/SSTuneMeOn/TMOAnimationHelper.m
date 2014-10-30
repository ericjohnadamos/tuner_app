//
//  TMOAnimationHelper.m
//  SSTuneMeOn
//
//  Created by Kevin Bernard R. San Gaspar on 6/13/14.
//  Copyright (c) 2014 Eric John Adamos. All rights reserved.
//

#import "TMOAnimationHelper.h"
#import <CoreGraphics/CoreGraphics.h>

@interface TMOAnimationHelper ()

@property (nonatomic, retain) NSDictionary* animationKeyMap;
@property (nonatomic, retain) NSDictionary* animationLengthMap;
@property (nonatomic, retain) NSMutableDictionary* animationCache;

@end

#pragma mark - Animations Keys Constants

NSString* kAnimationKeySplash = @"splash";
NSString* kAnimationKeyDefault = @"default";
NSString* kAnimationKeyDance1 = @"dance1";
NSString* kAnimationKeyDance2 = @"dance2";
NSString* kAnimationKeyDance3 = @"dance3";
NSString* kAnimationKeyDance4 = @"dance4";
NSString* kAnimationKeyDance5 = @"dance5";
NSString* kAnimationKeyDance6 = @"dance6";
NSString* kAnimationKeyDance7 = @"dance7";

#pragma mark - Static members

TMOAnimationHelper* sm_sharedHelper;

@implementation TMOAnimationHelper

#pragma mark - Synthesize Properties

@synthesize animationKeyMap = m_animationKeyMap;
@synthesize animationLengthMap = m_animationLengthMap;
@synthesize animationCache = m_animationCache;

#pragma mark - Memory management

- (void) dealloc
{
  self.animationKeyMap = nil;
  self.animationLengthMap = nil;
  [super dealloc];
}

#pragma mark - Static methods

+ (TMOAnimationHelper*) sharedHelper
{
  if (sm_sharedHelper == nil)
  {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
      sm_sharedHelper = [TMOAnimationHelper new];
    });
  }
  return sm_sharedHelper;
}

#pragma mark - Getters

- (NSDictionary*) animationKeyMap
{
  if (m_animationKeyMap == nil)
  {
    m_animationKeyMap
      = @{kAnimationKeySplash: @"intro",
          kAnimationKeyDefault: @"loop",
          kAnimationKeyDance1: @"dance_01",
          kAnimationKeyDance2: @"dance_02",
          kAnimationKeyDance3: @"dance_03",
          kAnimationKeyDance4: @"dance_04",
          kAnimationKeyDance5: @"dance_05",
          kAnimationKeyDance6: @"dance_06",
          kAnimationKeyDance7: @"dance_07"};
    
    [m_animationKeyMap retain];
  }
  return m_animationKeyMap;
}

- (NSDictionary*) animationLengthMap
{
  if (m_animationLengthMap == nil)
  {
    m_animationLengthMap
      = @{kAnimationKeySplash: @(59),
          kAnimationKeyDefault: @(104),
          kAnimationKeyDance1: @(231),
          kAnimationKeyDance2: @(180),
          kAnimationKeyDance3: @(279),
          kAnimationKeyDance4: @(262),
          kAnimationKeyDance5: @(235),
          kAnimationKeyDance6: @(289),
          kAnimationKeyDance7: @(392)};
    
    [m_animationLengthMap retain];
  }
  return m_animationLengthMap;
}

- (NSMutableDictionary*) animationCache
{
  if (m_animationCache == nil)
  {
    m_animationCache = [NSMutableDictionary new];
  }
  return m_animationCache;
}

#pragma mark - Private methods

- (NSArray*) CGImagesForPrefix: (NSString*)  prefix
                        length: (NSUInteger) length
{
  NSMutableArray* images = [NSMutableArray arrayWithCapacity: length];
  CGFloat width = 320.0f;
  CGFloat height = 333.0f;
  
  for (NSUInteger cnt = 1; cnt <= length; cnt++)
  {
    NSString* imageName
      = [NSString stringWithFormat: @"%@_%03d@2x", prefix, cnt];
    NSString* fileLocation
      = [[NSBundle mainBundle] pathForResource: imageName
                                        ofType: @"png"];
    /* Preload image */
    UIImage* frameImage = [UIImage imageWithContentsOfFile: fileLocation];
    UIGraphicsBeginImageContext(CGSizeMake(width, height));
    CGRect rect = CGRectMake(0, 0, width, height);
    [frameImage drawInRect: rect];
    UIImage* renderedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [images addObject: (id) renderedImage.CGImage];
  }
  return images;
}

- (CAKeyframeAnimation*) animationForCGImages: (NSArray*) images
{
  CAKeyframeAnimation* animationSequence
    = [CAKeyframeAnimation animationWithKeyPath: @"contents"];
  animationSequence.cumulative = YES;
  animationSequence.calculationMode = kCAAnimationLinear;
  animationSequence.autoreverses = NO;
  animationSequence.duration = images.count / 30;
  animationSequence.repeatCount = 0;
  animationSequence.fillMode = kCAFillModeForwards;
  animationSequence.removedOnCompletion = NO;
  animationSequence.values = images;
  animationSequence.delegate = self;
  return animationSequence;
}

#pragma mark - Public methods

- (CAKeyframeAnimation*) animationForKey: (NSString*) animationKey
{
  CAKeyframeAnimation* animation = self.animationCache[animationKey];
  
  if (animation == nil)
  {
    NSUInteger length
      = ((NSNumber*) self.animationLengthMap[animationKey]).intValue;

    NSArray* images
      = [self CGImagesForPrefix: self.animationKeyMap[animationKey]
                         length: length];
    
    animation = [self animationForCGImages: images];
  }
  return animation;
}

- (void) loadAllAnimations
{
  for (NSString* key in self.animationKeyMap.keyEnumerator)
  {
    self.animationCache[key] = [self animationForKey: key];
  }
}

@end
