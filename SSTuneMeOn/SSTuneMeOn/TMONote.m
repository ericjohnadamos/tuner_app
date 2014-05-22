//
//  TMONote.m
//  SSTuneMeOn
//
//  Created by Kevin Bernard R. San Gaspar on 5/2/14.
//  Copyright (c) 2014 Eric John Adamos. All rights reserved.
//

#import "TMONote.h"

@implementation TMONote
@synthesize name = m_name;
@synthesize frequency = m_frequency;

#pragma mark - Memory management

- (void) dealloc
{
  self.name = nil;
  [super dealloc];
}

#pragma mark - Static methods

+ (TMONote*) noteWithName: (NSString*) name
                frequency: (CGFloat)   frequency
{
  return [[[self alloc] initiWithName: name
                            frequency: frequency] autorelease];
}

#pragma mark - Public methods

- (id) initiWithName: (NSString*) name
           frequency: (CGFloat)   frequency
{
  if (self = [super init])
  {
    self.name = name;
    self.frequency = frequency;
  }
  return self;
}

- (BOOL) isEqualToNote: (TMONote*) aNote
{
  return aNote.frequency == self.frequency;
}

@end
