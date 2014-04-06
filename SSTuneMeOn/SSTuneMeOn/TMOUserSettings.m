//
//  TMOUserSettings.m
//  SSTuneMeOn
//
//  Created by Eric John Adamos <ericjohnadamos@gmail.com> on 4/6/14.
//  Copyright (c) 2014 Eric John Adamos. All rights reserved.
//

#import "TMOUserSettings.h"

static NSString* kUserSettingsKeyNote = @"UserSettingsKeyNote";

@implementation TMOUserSettings

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

@end
