//
//  TMOMainViewController.h
//  SSTuneMeOn
//
//  Created by Eric John Adamos <ericjohnadamos@gmail.com> on 3/10/14.
//  Copyright (c) 2014 Eric John Adamos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TMOPitchDetector.h"

@interface TMOMainViewController : UIViewController

@property (nonatomic, strong) TMOPitchDetector* pitchDetector;
@property (nonatomic, strong) NSMutableArray* medianPitchFollow;

- (void) updateToFrequency: (double) frequency;

@end
