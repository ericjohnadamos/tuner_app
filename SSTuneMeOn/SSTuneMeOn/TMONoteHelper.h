//
//  TMONoteHelper.h
//  SSTuneMeOn
//
//  Created by Eric John Adamos on 6/12/15.
//  Copyright (c) 2015 Eric John Adamos. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TMONoteHelper : NSObject

@property (nonatomic, assign) double currentFrequency;
@property (nonatomic, strong) NSString* currentNote;

@property (nonatomic, assign) double minFrequency;
@property (nonatomic, assign) double targetFrequency;
@property (nonatomic, assign) double maxFreqency;
@property (nonatomic, assign) double previousFrequency;

- (void) calculateCurrentNote: (double) freqency;

@end
