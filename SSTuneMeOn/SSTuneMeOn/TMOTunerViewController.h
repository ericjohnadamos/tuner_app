//
//  TMOTunerViewController.h
//  SSTuneMeOn
//
//  Created by Kevin Bernard R. San Gaspar on 5/8/14.
//  Copyright (c) 2014 Eric John Adamos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TMOFrequencyListener.h"

@class TMONote;
@class TMONoteGroup;

@interface TMOTunerViewController : UIViewController <TMOFrequencyListener>

- (id) initWithFrame: (CGRect) frame;
- (void) frequencyChangedWithValue: (float) newFrequency;
- (void) updateWithNote: (TMONote*)      note
              noteGroup: (TMONoteGroup*) noteGroup;
- (void) increaseProgress;
- (void) decreaseProgress;

@end
