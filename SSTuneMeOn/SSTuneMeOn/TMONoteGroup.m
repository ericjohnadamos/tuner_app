//
//  TMONoteGroup.m
//  SSTuneMeOn
//
//  Created by Kevin Bernard R. San Gaspar on 5/2/14.
//  Copyright (c) 2014 Eric John Adamos. All rights reserved.
//

#import "TMONoteGroup.h"

@interface TMONoteGroup ()

@property (nonatomic, strong) NSArray* notes;

@end

@implementation TMONoteGroup
@synthesize groupName = m_groupName;
@synthesize notes = m_notes;


#pragma mark - Public methods

- (id) initWithGroupName: (NSString*) groupName
                   notes: (NSArray*)  notes
{
  if (self = [super init])
  {
    self.groupName = groupName;
    self.notes = notes;
  }
  return self;
}

@end
