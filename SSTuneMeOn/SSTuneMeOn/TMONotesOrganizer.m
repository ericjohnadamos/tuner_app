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
      = @[[TMONote noteWithName: @"E"
                    frequencies: @[@329.63f, @659.25f, @1318.51f]],
          [TMONote noteWithName: @"B"
                    frequencies: @[@246.94f, @493.88f, @987.77f, @1975.53f]],
          [TMONote noteWithName: @"G"
                    frequencies: @[@196.0f, @392.0f, @783.99f]],
          [TMONote noteWithName: @"D"
                    frequencies: @[@146.83f, @293.66f, @587.33f]],
          [TMONote noteWithName: @"A"
                    frequencies: @[@220.0f, @440.0f, @880.0f]],
          [TMONote noteWithName: @"E"
                    frequencies: @[@164.81f, @329.63f, @659.25f]]];
    TMONoteGroup* acousticGroup
      = [[TMONoteGroup alloc] initWithGroupName: acousticGroupName
                                          notes: acousticNotes];
    
    /* Acoustic */
    NSString* bassGroupName
      = [TMOLocalizedStrings stringForKey: @"TMONoteGroupNameBass"];
    NSArray* bassNotes
      = @[[TMONote noteWithName: @"G"
                    frequencies: @[@98.0f, @196.0f, @392.0f, @783.99f]],
          [TMONote noteWithName: @"D"
                    frequencies: @[@73.42f, @146.83f, @293.66f, @587.33f]],
          [TMONote noteWithName: @"A"
                    frequencies: @[@110.0f, @220.0f, @440.0f, @880.0f]],
          [TMONote noteWithName: @"E"
                    frequencies: @[@82.41f, @164.81f, @329.63f, @659.25f]]];
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
