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
  
  [keyMapping setObject: @466.7f
                 forKey: @"c"];
  [keyMapping setObject: @494.4f
                 forKey: @"d"];
  [keyMapping setObject: @523.8f
                 forKey: @"e"];
  [keyMapping setObject: @415.8f
                 forKey: @"a"];
  [keyMapping setObject: @440.5f
                 forKey: @"b"];
  
  NSMutableDictionary* frequencyMapping
    = [NSMutableDictionary dictionaryWithCapacity: 9];
  
  [frequencyMapping setObject: @"c"
                       forKey: @466.7f];
  [frequencyMapping setObject: @"d"
                       forKey: @494.4];
  [frequencyMapping setObject: @"e"
                       forKey: @523.8f];
  [frequencyMapping setObject: @"a"
                       forKey: @415.8f];
  [frequencyMapping setObject: @"b"
                       forKey: @440.5f];
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
