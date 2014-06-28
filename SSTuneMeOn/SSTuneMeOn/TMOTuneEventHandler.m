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

@interface TMOTuneEventHandler ()

@end

static NSInteger kInactiveDuration = 8;

static BOOL sm_isActive = YES;

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
      dispatch_after(dispatch_time(DISPATCH_TIME_NOW,
                                  (int64_t)(kInactiveDuration * NSEC_PER_SEC)),
                                  dispatch_get_main_queue(), ^
      {
        sm_isActive = YES;
      });
      
      if (self.callback != nil)
      {
        self.callback();
      }
      sm_isActive = NO;
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
