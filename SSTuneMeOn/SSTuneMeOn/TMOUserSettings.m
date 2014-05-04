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

@property (nonatomic, retain) NSNumber* noteIndexNumber;
@property (nonatomic, retain) NSNumber* noteGroupIndexNumber;
@property (nonatomic, retain) TMONote* selectedNote;

@end

static TMOUserSettings* sm_userSettings = nil;

static NSString* kIsDefaultsLoaded = @"IsDefaultsLoaded";
static NSString* kIsFirstTime = @"IsFirstTime";
static NSString* kUserSettingsKeyNote = @"UserSettingsKeyNote";
static NSString* kUserSettingsNoteGroupIndex = @"UserSettingsNoteGroupIndex";
static NSString* kUserSettingsNoteIndex = @"UserSettingsNoteIndex";

@implementation TMOUserSettings
@synthesize noteIndexNumber = m_noteIndexNumber;
@synthesize noteGroupIndexNumber = m_noteGroupIndexNumber;
@synthesize selectedNote = m_selectedNote;

#pragma mark - Memory management

- (void) dealloc
{
  self.noteIndexNumber = nil;
  self.noteGroupIndexNumber = nil;
  self.selectedNote = nil;
  [super dealloc];
}

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
  self.selectedNote = nil;
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
  self.selectedNote = nil;
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
  if (self.selectedNote == nil)
  {
    TMONote* selectedNote = nil;
    
    TMONotesOrganizer* organizer = [TMONotesOrganizer sharedInstance];
    NSArray* noteGroups = organizer.allGroups;
    NSInteger groupIndex = self.noteGroupIndex;
    NSInteger noteIndex = self.noteIndex;
    
    if (noteGroups.count > groupIndex)
    {
      NSArray* notes = ((TMONoteGroup*) noteGroups[groupIndex]).notes;
      
      if (notes.count > noteIndex)
      {
        selectedNote = notes[noteIndex];
      }
    }
    self.selectedNote = selectedNote;
  }
  return self.selectedNote;
}

@end
