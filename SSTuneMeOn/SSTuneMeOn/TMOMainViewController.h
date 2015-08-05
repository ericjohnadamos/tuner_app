//
//  TMOMainViewController.h
//  SSTuneMeOn
//
//  Created by Eric John Adamos <ericjohnadamos@gmail.com> on 3/10/14.
//  Copyright (c) 2014 Eric John Adamos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EZAudio.h"

@interface TMOMainViewController : UIViewController <EZMicrophoneDelegate,
                                                     EZAudioFFTDelegate>

@property (nonatomic, strong) NSMutableArray* medianPitchFollow;

- (void) updateToFrequency: (double) frequency;

/* @description - microphone used to get input.
 */
@property (nonatomic, strong) EZMicrophone* microphone;

/* @description - used to calculate a rolling FFT of the incoming audio data.
 */
@property (nonatomic, strong) EZAudioFFTRolling* fft;

@property (nonatomic, weak) EZAudioPlot* audioPlotFreq;

@property (nonatomic, weak) EZAudioPlot* audioPlotTime;

@end
