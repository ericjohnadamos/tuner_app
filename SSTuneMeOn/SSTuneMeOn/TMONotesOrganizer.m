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

@property (nonatomic, strong) NSArray* noteGroups;

@end

#pragma mark - Static members

static TMONotesOrganizer* sm_sharedInstance;

@implementation TMONotesOrganizer
@synthesize noteGroups = m_noteGroups;

#pragma mark - Memory management


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
      = @[[TMONote noteWithName: @"E" frequency: 329.6f],
          [TMONote noteWithName: @"B" frequency: 246.9f],
          [TMONote noteWithName: @"G" frequency: 196.0f],
          [TMONote noteWithName: @"D" frequency: 146.8f],
          [TMONote noteWithName: @"A" frequency: 110.0f],
          [TMONote noteWithName: @"E" frequency: 82.41f]];
    TMONoteGroup* acousticGroup
      = [[TMONoteGroup alloc] initWithGroupName: acousticGroupName
                                          notes: acousticNotes];
    
    /* Acoustic */
    NSString* bassGroupName
      = [TMOLocalizedStrings stringForKey: @"TMONoteGroupNameBass"];
    NSArray* bassNotes
      = @[[TMONote noteWithName: @"G" frequency: 196.0f],
          [TMONote noteWithName: @"D" frequency: 146.8f],
          [TMONote noteWithName: @"A" frequency: 110.0f],
          [TMONote noteWithName: @"E" frequency: 82.41f]];
    TMONoteGroup* bassGroup
      = [[TMONoteGroup alloc] initWithGroupName: bassGroupName
                                          notes: bassNotes];
    
    NSArray* noteGroups = @[acousticGroup, bassGroup];
    m_noteGroups = noteGroups;
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
