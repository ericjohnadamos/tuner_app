//
//  TMOUserSettings.m
//  SSTuneMeOn
//
//  Created by Eric John Adamos <ericjohnadamos@gmail.com> on 4/6/14.
//  Copyright (c) 2014 Eric John Adamos. All rights reserved.
//

#import "TMOUserSettings.h"
#import "TMONotesOrganizer.h"
#import "TMONoteGroup.h"
#import "TMONote.h"

@interface TMOUserSettings ()

@property (nonatomic, strong) NSNumber* noteIndexNumber;
@property (nonatomic, strong) NSNumber* noteGroupIndexNumber;
@property (nonatomic, strong) TMONote* internalSelectedNote;
@property (nonatomic, strong) TMONoteGroup* internalSelectedGroup;

@end

CGFloat kTuneVrianceThreshold = 0.1;

static TMOUserSettings* sm_userSettings = nil;

static NSString* kIsDefaultsLoaded = @"IsDefaultsLoaded";
static NSString* kIsFirstTime = @"IsFirstTime";
static NSString* kUserSettingsKeyNote = @"UserSettingsKeyNote";
static NSString* kUserSettingsNoteGroupIndex = @"UserSettingsNoteGroupIndex";
static NSString* kUserSettingsNoteIndex = @"UserSettingsNoteIndex";

@implementation TMOUserSettings
@synthesize noteIndexNumber = m_noteIndexNumber;
@synthesize noteGroupIndexNumber = m_noteGroupIndexNumber;
@synthesize internalSelectedNote = m_internalSelectedNote;
@synthesize internalSelectedGroup = m_internalSelectedGroup;

#pragma mark - Memory management


- (BOOL) isDefaultsLoaded
{
  NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
  
  return [userDefaults boolForKey: kIsDefaultsLoaded];
}

- (void) setDefaultsLoaded: (BOOL) defaultsLoaded
{
  NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
  [userDefaults setBool: defaultsLoaded
                 forKey: kIsDefaultsLoaded];
  [userDefaults synchronize];
}

- (BOOL) isFirstTime
{
  NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
  
  return [userDefaults boolForKey: kIsFirstTime];
}

- (void) setFirstTime: (BOOL) firstTime
{
  NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
  [userDefaults setBool: firstTime
                 forKey: kIsFirstTime];
  [userDefaults synchronize];
}

- (NSString*) keyNote
{
  NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
  
  return [userDefaults valueForKey: kUserSettingsKeyNote];
}

- (void) setKeyNote: (NSString*) keyNote
{
  if (keyNote.length > 0)
  {
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setValue: keyNote
                    forKey: kUserSettingsKeyNote];
    [userDefaults synchronize];
  }
}

- (NSInteger) noteGroupIndex
{
  NSInteger noteGroupIndex = 0;
  
  if (self.noteGroupIndexNumber == nil)
  {
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    NSNumber* noteGroupNumber
      = [userDefaults valueForKey: kUserSettingsNoteGroupIndex];
    
    if (noteGroupNumber != nil)
    {
      noteGroupIndex = [noteGroupNumber integerValue];
    }
    self.noteGroupIndexNumber = noteGroupNumber;
  }
  else
  {
    noteGroupIndex = [self.noteGroupIndexNumber integerValue];
  }
  return noteGroupIndex;
}

- (void) setNoteGroupIndex: (NSInteger) noteGroupIndex
{
  NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
  [userDefaults setValue: @(noteGroupIndex)
                  forKey: kUserSettingsNoteGroupIndex];
  [userDefaults synchronize];
  
  self.noteGroupIndexNumber = @(noteGroupIndex);
  self.internalSelectedGroup = nil;
  self.internalSelectedNote = nil;
}

- (NSInteger) noteIndex
{
  NSInteger noteIndex = 0;
  
  if (self.noteIndexNumber == nil)
  {
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    NSNumber* noteNumber
      = [userDefaults valueForKey: kUserSettingsNoteIndex];
    
    if (noteNumber != nil)
    {
      noteIndex = [noteNumber integerValue];
    }
    self.noteIndexNumber = noteNumber;
  }
  else
  {
    noteIndex = [self.noteIndexNumber integerValue];
  }
  return noteIndex;
}

- (void) setNoteIndex: (NSInteger) noteIndex
{
  NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
  [userDefaults setValue: @(noteIndex)
                  forKey: kUserSettingsNoteIndex];
  [userDefaults synchronize];
  self.noteIndexNumber = @(noteIndex);
  self.internalSelectedNote = nil;
}

#pragma mark - Public method

+ (TMOUserSettings*) sharedInstance
{
  if (sm_userSettings == nil)
  {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,
   ^{
      sm_userSettings = [TMOUserSettings new];
    });
  }
  
  return sm_userSettings;
}

- (void) loadDefaults
{
  self.defaultsLoaded = YES;
  
  self.firstTime = YES;
  
  /* TODO: Implement me */
}

- (TMONote*) selectedNote
{
  if (self.self.internalSelectedNote == nil)
  {
    NSInteger noteIndex = self.noteIndex;
    TMONoteGroup* selectedGroup = [self selectedGroup];
    
    if (selectedGroup.notes.count > noteIndex)
    {
      self.self.internalSelectedNote = selectedGroup.notes[noteIndex];
    }
  }
  return self.internalSelectedNote;
}

- (TMONoteGroup*) selectedGroup
{
  if (self.internalSelectedGroup == nil)
  {
    TMONotesOrganizer* organizer = [TMONotesOrganizer sharedInstance];
    NSArray* noteGroups = organizer.allGroups;
    NSInteger groupIndex = self.noteGroupIndex;
    
    if (noteGroups.count > groupIndex)
    {
      self.internalSelectedGroup = noteGroups[groupIndex];
    }
  }
  return self.internalSelectedGroup;
}

@end
