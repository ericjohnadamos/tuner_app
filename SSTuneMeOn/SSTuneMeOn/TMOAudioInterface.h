//
//  TMOAudioInterface.h
//  SSTuneMeOn
//
//  Created by Eric John Adamos <ericjohnadamos@gmail.com> on 3/12/14.
//  Copyright (c) 2014 Eric John Adamos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioUnit/AudioUnit.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import <Accelerate/Accelerate.h>
#include <stdlib.h>


/**
 *	This is a singleton class that manages all the low level CoreAudio/RemoteIO
 *	elements. A singleton is used since we should never be instantiating more
 *  than one instance of this class per application lifecycle.
 */

#define kInputBus 1
#define kOutputBus 0
#define kBufferSize 1024
#define kBufferCount 1
#define N 10

@interface TMOAudioInterface : NSObject

@property(nonatomic, assign) id<AVAudioPlayerDelegate> audioPlayerDelegate;
@property(nonatomic, assign) id<AVAudioSessionDelegate> audioSessionDelegate;

@property(nonatomic, assign) float sampleRate;
@property(nonatomic, assign) float frequency;

#pragma mark - Audio Session / Graph Setup

- (void) initializeAudioSession;
- (void) createAUProcessingGraph;
- (size_t) ASBDForSoundMode;

#pragma mark - Playback Controls

- (void) startPlayback;
- (void) startPlaybackFromEncodedArray: (NSArray*) encodedArray;
- (void) stopPlayback;
- (void) printASBD: (AudioStreamBasicDescription) asbd;

#pragma mark - Listener Controls

#pragma mark - Generic Audio Controls

- (void) initializeAndStartProcessingGraph;
- (void) stopProcessingGraph;

#pragma mark - Initializer

+ (TMOAudioInterface*) sharedInstance;

@end
