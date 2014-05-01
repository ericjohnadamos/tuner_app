//
//  TMOStandardTheme.m
//  SSTuneMeOn
//
//  Created by Eric John Adamos <ericjohnadamos@gmail.com> on 4/15/14.
//  Copyright (c) 2014 Eric John Adamos. All rights reserved.
//

#import "TMOStandardTheme.h"
#import "TMOStandardThemeHelpers.h"

static TMOStandardTheme* sm_theme = nil;

@implementation TMOStandardTheme

#pragma mark - Initializer

+ (TMOStandardTheme*) sharedInstance
{
  if (sm_theme == nil)
  {
    TMOStandardTheme* theme = [[TMOStandardTheme alloc] init];
    
    sm_theme = theme;
  }
  
  return sm_theme;
}

- (void) skinButton: (UIButton*) button
{
  /* TODO: Implement this if you want to have a default skinning for buttons */
}

- (void) skinHelpButton: (UIButton*) button
{
  [button setImage: [UIImage imageNamed: kThemeHelpImage]
          forState: UIControlStateNormal];
}

- (void) skinSelectionButton: (UIButton*) button
{
  [button setImage: [UIImage imageNamed: kThemeSelectionImage]
          forState: UIControlStateNormal];
}

@end
