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
@synthesize frequencies = m_frequencies;

#pragma mark - Static methods

+ (TMONote*) noteWithName: (NSString*) name
              frequencies: (NSArray*)  frequencies
{
  return [[self alloc] initWithName: name
                        frequencies: frequencies];
}

#pragma mark - Public methods

- (id) initWithName: (NSString*) name
        frequencies: (NSArray*)  frequencies
{
  if (self = [super init])
  {
    self.name = name;
    self.frequencies = frequencies;
  }
  return self;
}

@end
