//
//  TMOAudioInterface.m
//  SSTuneMeOn
//
//  Created by Eric John Adamos <ericjohnadamos@gmail.com> on 3/12/14.
//  Copyright (c) 2014 Eric John Adamos. All rights reserved.
//

#import "TMOAudioInterface.h"


@implementation TMOAudioInterface

#pragma mark - Synthesize properties

@synthesize audioPlayerDelegate = m_audioPlayerDelegate;
@synthesize audioSessionDelegate = m_audioSessionDelegate;

#pragma mark - Memory management

- (void) dealloc
{
  /* Clean up the audio session */
	AVAudioSession* session = [AVAudioSession sharedInstance];
	[session setActive: NO
               error: nil];
  
  self.audioPlayerDelegate = nil;
  self.audioSessionDelegate = nil;
  
  [super dealloc];
}

@end
