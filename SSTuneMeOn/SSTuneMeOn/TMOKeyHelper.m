//
//  TMOKeyHelper.m
//  SSTuneMeOn
//
//  Created by Eric John Adamos <ericjohnadamos@gmail.com> on 3/10/14.
//  Copyright (c) 2014 Eric John Adamos. All rights reserved.
//

#import "TMOKeyHelper.h"


static TMOKeyHelper* sm_keyHelper;

@interface TMOKeyHelper ()

@end


@implementation TMOKeyHelper

#pragma mark - Synthesize properties

#pragma mark - Lazy loaders

#pragma mark - Exposed methods

+ (TMOKeyHelper*) sharedInstance
{
  if (sm_keyHelper == nil)
  {
    TMOKeyHelper* keyHelper = [[TMOKeyHelper alloc] init];
    
    sm_keyHelper = keyHelper;
  }
  
  return sm_keyHelper;
}

+ (id) allocWithZone: (NSZone*) zone
{
  @synchronized(self)
  {
    if (sm_keyHelper == nil)
    {
      sm_keyHelper = [super allocWithZone: zone];
      
      return sm_keyHelper;
    }
  }
  
  return nil;
}

- (id) copyWithZone: (NSZone*) zone
{
  return self;
}

- (void) buildKeyMapping
{
  NSMutableDictionary* keyMapping
    = [NSMutableDictionary dictionaryWithCapacity: 9];
  
  [keyMapping setObject: @130.8f
                 forKey: @"c"];
  [keyMapping setObject: @146.8f
                 forKey: @"d"];
  [keyMapping setObject: @164.8f
                 forKey: @"e"];
  [keyMapping setObject: @220.0f
                 forKey: @"a"];
  [keyMapping setObject: @246.9f
                 forKey: @"b"];
  
  NSMutableDictionary* frequencyMapping
    = [NSMutableDictionary dictionaryWithCapacity: 9];
  
  [frequencyMapping setObject: @"c"
                       forKey: @130.8f];
  [frequencyMapping setObject: @"d"
                       forKey: @146.8f];
  [frequencyMapping setObject: @"e"
                       forKey: @164.8f];
  [frequencyMapping setObject: @"a"
                       forKey: @220.0f];
  [frequencyMapping setObject: @"b"
                       forKey: @246.9f];
}

- (NSString*) closestCharForFrequency: (CGFloat) frequency
{
  /* Gets the character closest to the frequency passed in */
  NSString* closestKey = nil;
  
  /* Init to largest float value so all ranges closer */
	CGFloat closestFloat = MAXFLOAT;
	
	/* Check each values distance to the actual frequency */
	for (NSNumber* number in [self.keyMapping allValues])
  {
    float mappedFreq = [number floatValue];
    float tempVal = fabsf(mappedFreq - frequency);
    
		if (tempVal < closestFloat)
    {
			closestFloat = tempVal;
			closestKey = [self.frequencyMapping objectForKey: number];
		}
	}
	
	return closestKey;
}


#pragma mark - Memory deallocation

- (void) dealloc
{
  self.keyMapping = nil;
  self.frequencyMapping = nil;
  
  [super dealloc];
}

@end
