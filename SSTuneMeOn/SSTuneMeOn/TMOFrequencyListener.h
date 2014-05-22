//
//  TMOFrequencyListener.h
//  SSTuneMeOn
//
//  Created by Kevin Bernard R. San Gaspar on 5/8/14.
//  Copyright (c) 2014 Eric John Adamos. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TMOFrequencyListener <NSObject>

- (void) frequencyChangedWithValue: (float) newFrequency;

@end
