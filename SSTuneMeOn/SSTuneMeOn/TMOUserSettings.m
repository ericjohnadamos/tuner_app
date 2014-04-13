//
//  TMOUserSettings.m
//  SSTuneMeOn
//
//  Created by Eric John Adamos <ericjohnadamos@gmail.com> on 4/6/14.
//  Copyright (c) 2014 Eric John Adamos. All rights reserved.
//

#import "TMOUserSettings.h"

static TMOUserSettings* sm_userSettings = nil;

static NSString* kIsDefaultsLoaded = @"IsDefaultsLoaded";
static NSString* kIsFirstTime = @"IsFirstTime";
static NSString* kUserSettingsKeyNote = @"UserSettingsKeyNote";

@implementation TMOUserSettings

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
  }
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
