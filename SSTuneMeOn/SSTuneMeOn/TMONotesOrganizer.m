//
//  TMONotesOrganizer.m
//  SSTuneMeOn
//
//  Created by Kevin Bernard R. San Gaspar on 5/2/14.
//  Copyright (c) 2014 Eric John Adamos. All rights reserved.
//

#import "TMONotesOrganizer.h"
#import "TMONote.h"
#import "TMONoteGroup.h"
#import "TMOLocalizedStrings.h"

@interface TMONotesOrganizer ()

@property (nonatomic, retain) NSArray* noteGroups;

@end

#pragma mark - Static members

static TMONotesOrganizer* sm_sharedInstance;

@implementation TMONotesOrganizer
@synthesize noteGroups = m_noteGroups;

#pragma mark - Memory management

- (void) dealloc
{
  self.noteGroups = nil;
  [super dealloc];
}

#pragma mark - Getters

- (NSArray*) noteGroups
{
  if (m_noteGroups == nil)
  {
    /* Create and group notes here */

    /* Acoustic */
    NSString* acousticGroupName
      = [TMOLocalizedStrings stringForKey: @"TMONoteGroupNameAcoustic"];
    NSArray* acousticNotes
      = @[[TMONote noteWithName: @"E" frequency: 329.63f],
          [TMONote noteWithName: @"B" frequency: 246.94f],
          [TMONote noteWithName: @"G" frequency: 196.00f],
          [TMONote noteWithName: @"D" frequency: 146.83f],
          [TMONote noteWithName: @"A" frequency: 110.00f],
          [TMONote noteWithName: @"E" frequency: 82.41f]];
    TMONoteGroup* acousticGroup
      = [[TMONoteGroup alloc] initWithGroupName: acousticGroupName
                                          notes: acousticNotes];
    [acousticGroup autorelease];
    
    /* Acoustic */
    NSString* bassGroupName
      = [TMOLocalizedStrings stringForKey: @"TMONoteGroupNameBass"];
    NSArray* bassNotes
      = @[[TMONote noteWithName: @"G" frequency: 97.999f],
          [TMONote noteWithName: @"D" frequency: 73.416f],
          [TMONote noteWithName: @"A" frequency: 55.0f],
          [TMONote noteWithName: @"E" frequency: 41.204f]];
    TMONoteGroup* bassGroup
      = [[TMONoteGroup alloc] initWithGroupName: bassGroupName
                                          notes: bassNotes];
    [bassGroup autorelease];
    
    NSArray* noteGroups = @[acousticGroup, bassGroup];
    m_noteGroups = [noteGroups retain];
  }
  return m_noteGroups;
}

#pragma mark - Public methods

- (NSArray*) allGroups
{
  return self.noteGroups;
}

#pragma mark - Static methods

+ (TMONotesOrganizer*) sharedInstance
{
  if (sm_sharedInstance == nil)
  {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,
    ^{
      sm_sharedInstance = [[TMONotesOrganizer alloc] init];
    });
  }
  return sm_sharedInstance;
}

@end
