//
//  TMOButtonGenerator.m
//  SSTuneMeOn
//
//  Created by Eric John Adamos <ericjohnadamos@gmail.com> on 4/15/14.
//  Copyright (c) 2014 Eric John Adamos. All rights reserved.
//

#import "TMOButtonGenerator.h"
#import "TMOTheme.h"
#import "TMOStandardTheme.h"

@class TMOTheme;
@implementation TMOButtonGenerator

+ (UIButton*) helpButtonWithFrame: (CGRect) frame
{
  UIButton* button = [UIButton buttonWithType: UIButtonTypeCustom];
  button.frame = frame;
  
  TMOTheme* theme = [TMOStandardTheme sharedInstance];
  [theme skinHelpButton: button];
  
  return button;
}

+ (UIButton*) selectionButtonWithFrame: (CGRect) frame
{
  UIButton* button = [UIButton buttonWithType: UIButtonTypeCustom];
  button.frame = frame;
  
  TMOTheme* theme = [TMOStandardTheme sharedInstance];
  [theme skinSelectionButton: button];
  
  return button;
}

@end
