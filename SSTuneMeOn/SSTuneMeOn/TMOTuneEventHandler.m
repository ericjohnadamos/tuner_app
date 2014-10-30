//
//  TMOTuneEventHandler.m
//  SSTuneMeOn
//
//  Created by Kevin Bernard R. San Gaspar on 6/28/14.
//  Copyright (c) 2014 Eric John Adamos. All rights reserved.
//

#import "TMOTuneEventHandler.h"
#import "TMOUserSettings.h"
#import "TMONote.h"

static NSInteger kMaxHitCount = 10;
static NSInteger kInactiveDuration = 8;

static BOOL sm_isActive = YES;


@interface TMOTuneEventHandler ()

@property (nonatomic, assign) NSInteger hitCount;

@end


@implementation TMOTuneEventHandler

@synthesize callback = m_callback;

- (void) frequencyChangedWithValue: (float) newFrequency
{
  if (sm_isActive)
  {
    TMONote* targetNote = [[TMOUserSettings sharedInstance] selectedNote];
  
    CGFloat newVariance =
      [self varianceForFrequency: newFrequency
             withTargetFrequency: targetNote.frequency];
  
    BOOL isTuned = (ABS(newVariance) <= kTuneVrianceThreshold);
    
    if (isTuned)
    {
      self.hitCount++;
      
      if (self.hitCount == kMaxHitCount)
      {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW,
                                     (int64_t)(  kInactiveDuration
                                               * NSEC_PER_SEC)),
                       dispatch_get_main_queue(), ^
                       {
                         sm_isActive = YES;
                       });
        
        if (self.callback != nil)
        {
          self.callback(true);
        }
        
        sm_isActive = NO;
        self.hitCount = 0;
      }
    }
    else
    {
      self.hitCount--;
      
      if (self.hitCount == -kMaxHitCount)
      {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW,
                                     (int64_t)(  kInactiveDuration
                                               * NSEC_PER_SEC)),
                       dispatch_get_main_queue(), ^
                       {
                         sm_isActive = YES;
                       });
        
        if (self.callback != nil)
        {
          self.callback(false);
        }
        
        sm_isActive = NO;
        
        self.hitCount = 0;
      }
    }
  }
}

- (CGFloat) varianceForFrequency: (CGFloat) frequency
             withTargetFrequency: (CGFloat) target
{
  CGFloat variance = 0;
  
  if (frequency != target && target != 0)
  {
    variance = (frequency - target) / target;
  }
  return variance;
}

@end
