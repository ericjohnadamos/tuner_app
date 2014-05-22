//
//  TMOStandardThemeHelpers.m
//  SSTuneMeOn
//
//  Created by Eric John Adamos <ericjohnadamos@gmail.com> on 4/15/14.
//  Copyright (c) 2014 Eric John Adamos. All rights reserved.
//

#import "TMOStandardThemeHelpers.h"

@implementation TMOStandardThemeHelpers

/* Main View */
NSString* const kThemeHelpImage = @"navbar_btn_help";
NSString* const kThemeSelectionImage = @"navbar_btn_select";
NSString* const kThemeNavBarBackgroundColor = @"#FF000000";
CGFloat const kThemeNavBarTitleFontSize = 20.0f;
NSString* const kThemeNavBarTitleFontName = @"HelveticaNeue-Light";
NSString* const kThemeNavBarTitleFontColor = @"#FFFFFF";

/* Notes Selector View */
NSString* const kThemeDoneImage = @"navbar_btn_done";
NSString* const kThemeCancelImage = @"navbar_btn_cancel";
NSString* const kThemeNotesPickerBackgroundColor = @"#FF000000";
NSString* const kThemeNotesPickerTitleFontName = @"HelveticaNeue-Light";
NSString* const kThemeNotesPickerTitleFontColor = @"#FFFFFF";
CGFloat const kThemeNotesPickerTitleFontSize = 20.0f;
CGFloat const kThemeNotesPickerTitleFontSizeSelected = 40.0f;

/* Note strings icons */
NSString* const kThemeSixStringImages[]
  = {
    @"icn_acoustic_string_1",
    @"icn_acoustic_string_2",
    @"icn_acoustic_string_3",
    @"icn_acoustic_string_4",
    @"icn_acoustic_string_5",
    @"icn_acoustic_string_6"
  };
NSString* const kThemeFourStringImages[]
  = {
    @"icn_bass_string_1",
    @"icn_bass_string_2",
    @"icn_bass_string_3",
    @"icn_bass_string_4"
  };
@end
