//
//  TMOTuneEventHandler.h
//  SSTuneMeOn
//
//  Created by Kevin Bernard R. San Gaspar on 6/28/14.
//  Copyright (c) 2014 Eric John Adamos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TMOFrequencyListener.h"

typedef void(^TuneEventCallback)(BOOL);

@interface TMOTuneEventHandler : NSObject <TMOFrequencyListener>

@property (nonatomic, copy) TuneEventCallback callback;

@end
