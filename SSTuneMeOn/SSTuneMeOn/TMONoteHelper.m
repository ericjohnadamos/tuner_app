//
//  TMONoteHelper.m
//  SSTuneMeOn
//
//  Created by Eric John Adamos on 6/12/15.
//  Copyright (c) 2015 Eric John Adamos. All rights reserved.
//

#import "TMONoteHelper.h"

#define FSharp4 370.0f
#define F4      349.2f
#define E4      329.6f
#define DSharp4 311.1f
#define D4      293.7f
#define CSharp4 277.2f
#define C4      261.6f
#define B3      246.9f
#define ASharp3 233.1f
#define A3      220.0f
#define GSharp3 207.7f
#define G3      196.0f
#define FSharp3 185.0f
#define F3      174.6f
#define E3      164.8f
#define DSharp3 155.6f
#define D3      146.8f
#define CSharp3 138.6f
#define C3      130.8f
#define B2      123.5f
#define ASharp2 116.5f
#define A2      110.0f
#define GSharp2 103.8f
#define G2      98.0f
#define FSharp2 92.50f
#define F2      87.31f
#define E2      82.41f
#define DSharp2 77.78f

@implementation TMONoteHelper

- (id) init
{
  self = [super init];
  
  if (self != nil)
  {
    _currentFrequency = 0.0f;
    _currentNote = @"E";
    _minFrequency = 0.0f;
    _maxFreqency = 1.0f;
    _targetFrequency = 0.5f;
    _previousFrequency = 0.0f;
  }
  
  return self;
}

- (void) calculateCurrentNote: (double) freqency
{
  double target = 0.0f;
  
  if (   freqency < FSharp4
      && freqency > E4
      && ![self.currentNote isEqualToString: @"F"])
  {
    target = F4;
    self.currentNote = @"F";
  }
  else if (   freqency < F4
           && freqency > DSharp4
           && ![self.currentNote isEqualToString: @"E"])
  {
    target = E4;
    self.currentNote = @"E";
  }
  else if (   freqency < DSharp4
           && freqency > CSharp4
           && ![self.currentNote isEqualToString: @"D"])
  {
    target = D4;
    self.currentNote = @"D";
  }
  else if (   freqency < CSharp4
           && freqency > B3
           && ![self.currentNote isEqualToString: @"C"])
  {
    target = C4;
    self.currentNote = @"C";
  }
  else if (   freqency < C4
           && freqency > ASharp3
           && ![self.currentNote isEqualToString: @"B"])
  {
    target = B3;
    self.currentNote = @"B";
  }
  else if (   freqency < ASharp3
           && freqency > GSharp3
           && ![self.currentNote isEqualToString: @"A"])
  {
    target = A3;
    self.currentNote = @"A";
  }
  else if (   freqency < GSharp3
           && freqency > FSharp3
           && ![self.currentNote isEqualToString: @"G"])
  {
    target = G3;
    self.currentNote = @"G";
  }
  else if (   freqency < FSharp3
           && freqency > E3
           && ![self.currentNote isEqualToString: @"F"])
  {
    target = F3;
    self.currentNote = @"F";
  }
  else if (   freqency < F3
           && freqency > DSharp3
           && ![self.currentNote isEqualToString: @"E"])
  {
    target = E3;
    self.currentNote = @"E";
  }
  else if (   freqency < DSharp3
           && freqency > CSharp3
           && ![self.currentNote isEqualToString: @"D"])
  {
    target = D3;
    self.currentNote = @"D";
  }
  else if (   freqency < CSharp3
           && freqency > B2
           && ![self.currentNote isEqualToString: @"C"])
  {
    target = C3;
    self.currentNote = @"C";
  }
  else if (   freqency < C3
           && freqency > ASharp2
           && ![self.currentNote isEqualToString: @"B"])
  {
    target = B2;
    self.currentNote = @"B";
  }
  else if (   freqency < ASharp2
           && freqency > GSharp2
           && ![self.currentNote isEqualToString: @"A"])
  {
    target = G2;
    self.currentNote = @"A";
  }
  else if (   freqency < GSharp2
           && freqency > FSharp2
           && ![self.currentNote isEqualToString: @"G"])
  {
    target = G2;
    self.currentNote = @"G";
  }
  else if (   freqency < FSharp2
           && freqency > E2
           && ![self.currentNote isEqualToString: @"F"])
  {
    target = F2;
    self.currentNote = @"F";
  }
  else if (   freqency < F2
           && freqency > DSharp2
           && ![self.currentNote isEqualToString: @"E"])
  {
    target = E2;
    self.currentNote = @"E";
  }
  
  if (target > 0.0)
  {
    self.minFrequency = target - 20;
    self.targetFrequency = target;
    self.maxFreqency = target + 20;
  }
  
  self.currentFrequency = freqency;
}

@end
