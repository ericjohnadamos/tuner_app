//
//  TMOPitchDetector.h
//  SSTuneMeOn
//
//  Created by Eric John Adamos on 5/27/15.
//  Copyright (c) 2015 Eric John Adamos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioUnit/AudioUnit.h>
#import <AudioToolbox/AudioToolbox.h>
#import <Accelerate/Accelerate.h>

@class test_1_4096_0;
@class test_1_4096_50;
@class test_1_8192_0;
@class test_1_8192_50;
@class test_1_16384_0;
@class test_1_16384_50;
@class TMOMainViewController;

/* This is a singleton class that manages all the low level CoreAudio/RemoteIO
 * elements. A singleton is used since we should never be instantiating more
 * than one instance of this class per application lifecycle.
 */
#define kInputBus 1
#define kOutputBus 0

@interface TMOPitchDetector : NSObject
{
  test_1_4096_0* test_1_4096_0UI;
  test_1_4096_50* test_1_4096_50UI;
  test_1_8192_0* test_1_8192_0UI;
  test_1_8192_50* test_1_8192_50UI;
  test_1_16384_0* test_1_16384_0UI;
  test_1_16384_50* test_1_16384_50UI;
  TMOMainViewController* mainViewPitch;
  
  /* Call MainViewController* mainViewPitch here */
  
  NSUserDefaults* userDefaults;
  
  /* Fix this sample rate, as Human Pitch Range A0(27.5Hz) to B8(7900Hz)*/
  float sampleRate;
  /* in %, [0-100) Percentage of Frame overlap */
  long percentageOfOverlap;
  
  /* Audio Unit Processing Graph */
  AUGraph processingGraph;
  
  /* Microphone */
  AudioUnit ioUnit;
  
  /* Buffer for 1 frame, 1 frame = 1024samples */
  AudioBufferList* bufferList;
  
  /* Sample Rate: 44100, bytes per sample: 2 bytes */
  AudioStreamBasicDescription streamFormat;
  
  /* vDSP_create_fftsetup(log2n, FF_RADIX2) */
  FFTSetup fftSetup;
  
  /* Convert from outputBuffer to split complex vector */
  COMPLEX_SPLIT FFT;
  COMPLEX_SPLIT Cepstrum;
  
  /* default: 11, 2048, 1024 */
  int log2n, n, nOver2;
  
  /* Buffer for Obtaining data from Microphone Audio Unit */
  void* dataBuffer;
  
  /* Convert from dataBuffer, but still in interleaved Complex vector
   * After FFT, convert back from A(in frequency value), and find the pitch
   */
  float* outputBuffer;
  
  /* Current buffer usage of dataBuffer */
  size_t index;
  
  /* default: 2048 (bytes) as 2 bytes per sample */
  size_t bufferCapacity;
  
  UInt32 maxFrames;
}

/* Setup the singleton Detector */
+ (id) sharedDetector;
- (id) init;
- (Boolean) isDetectorRunning;

/* Initialize Audio Session - Setup Sample Rate, Specify the Stream Format and
 * FFT Setup
 */
- (void) initializePitchDetecter;
- (size_t) ASBDForSoundMode;
- (void) realFFTSetup;

/* Setup the microphone and attach it with analysis callback function */
- (void) createMicrophone;

/* Initialise and Turn On, Turn On and Turn Off the microphone */
- (void) bootUpAndTurnOnMicrophone;

- (void) TurnOnMicrophone_test_1_4096_0: (test_1_4096_0*) aUI;
- (void) TurnOnMicrophone_test_1_4096_50: (test_1_4096_50*) aUI;
- (void) TurnOnMicrophone_test_1_8192_0: (test_1_8192_0*) aUI;
- (void) TurnOnMicrophone_test_1_8192_50: (test_1_8192_50*) aUI;
- (void) TurnOnMicrophone_test_1_16384_0: (test_1_16384_0*) aUI;
- (void) TurnOnMicrophone_test_1_16384_50: (test_1_16384_50*) aUI;
- (void) TurnOnMicrophoneTuner: (TMOMainViewController*) aUI;


- (void) TurnOffMicrophone;

/* For Debug Only */
- (void) printPitchDetecterConfig;
- (void) printASBD: (AudioStreamBasicDescription) asbd;

@end
