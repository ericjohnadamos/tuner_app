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

@interface TMOUserSettings ()

@property (nonatomic, retain) NSNumber* noteIndexNumber;
@end

static TMOUserSettings* sm_userSettings = nil;

static NSString* kIsDefaultsLoaded = @"IsDefaultsLoaded";
static NSString* kIsFirstTime = @"IsFirstTime";
static NSString* kUserSettingsKeyNote = @"UserSettingsKeyNote";
static NSString* kUserSettingsNoteGroupIndex = @"UserSettingsNoteGroupIndex";

@implementation TMOUserSettings
@synthesize noteIndexNumber = m_noteIndexNumber;
#pragma mark - Memory management

- (void) dealloc
{
  self.noteGroupIndexNumber = nil;
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

#pragma mark - Public method

+ (TMOUserSettings*) sharedInstance
{
  if (sm_userSettings == nil)
  {
    TMOUserSettings* userSettings = [[TMOUserSettings alloc] init];
    
    sm_userSettings = userSettings;
  }
  
  return sm_userSettings;
}

- (void) loadDefaults
{
  self.defaultsLoaded = YES;
  
  self.firstTime = YES;
  
  /* TODO: Implement me */
}

@end
