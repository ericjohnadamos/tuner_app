//
//  TMOStandardTheme.m
//  SSTuneMeOn
//
//  Created by Eric John Adamos <ericjohnadamos@gmail.com> on 4/15/14.
//  Copyright (c) 2014 Eric John Adamos. All rights reserved.
//

#import "TMOStandardTheme.h"
#import "TMOStandardThemeHelpers.h"
#import "UIColor+HexString.h"

@interface TMOStandardTheme ()

@property (nonatomic, retain) NSDictionary* notesIconNames;
@property (nonatomic, retain) NSDictionary* tunedNotesIconNames;

@end

static TMOStandardTheme* sm_theme = nil;

@implementation TMOStandardTheme
@synthesize notesIconNames = m_notesIconNames;
@synthesize tunedNotesIconNames = m_tunedNotesIconNames;

#pragma mark - Memory management

- (void) dealloc
{
  self.notesIconNames = nil;
  self.tunedNotesIconNames = nil;
  [super dealloc];
}

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

#pragma mark - Getters

- (NSDictionary*) notesIconNames
{
  if (m_notesIconNames == nil)
  {
    m_notesIconNames =
      @{
        @"A" : kThemeNoteIconImageNameA,
        @"B" : kThemeNoteIconImageNameB,
        @"D" : kThemeNoteIconImageNameD,
        @"E" : kThemeNoteIconImageNameE,
        @"G" : kThemeNoteIconImageNameG,
      };
    
    [m_notesIconNames retain];
  }
  return m_notesIconNames;
}

- (NSDictionary*) tunedNotesIconNames
{
  if (m_tunedNotesIconNames == nil)
  {
    m_tunedNotesIconNames =
    @{
      @"A" : kThemeNoteIconTunedImageNameA,
      @"B" : kThemeNoteIconTunedImageNameB,
      @"D" : kThemeNoteIconTunedImageNameD,
      @"E" : kThemeNoteIconTunedImageNameE,
      @"G" : kThemeNoteIconTunedImageNameG,
    };
    [m_tunedNotesIconNames retain];
  }
  return m_tunedNotesIconNames;
}

#pragma mark - TMOTheme methods

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

- (void) skinDoneButton: (UIButton*) button
{
  [button setImage: [UIImage imageNamed: kThemeDoneImage]
          forState: UIControlStateNormal];
}

- (void) skinCancelButton: (UIButton*) button
{
  [button setImage: [UIImage imageNamed: kThemeCancelImage]
          forState: UIControlStateNormal];
}

- (void) skinNavigationBar: (UIView*) navBarView
{
  navBarView.backgroundColor
    = [UIColor colorWithHexString: kThemeNavBarBackgroundColor];
}

- (void) skinNavigationTitleLabel: (UILabel*) label
{
  label.backgroundColor = [UIColor clearColor];
  label.font = [UIFont fontWithName: kThemeNavBarTitleFontName
                               size: kThemeNavBarTitleFontSize];
  label.textColor = [UIColor colorWithHexString: kThemeNavBarTitleFontColor];
}

- (void) skinNotesPickerView: (UIPickerView*) pickerView
{
  pickerView.backgroundColor
    = [UIColor colorWithHexString: kThemeNotesPickerBackgroundColor];
}

- (void) skinNotesPickerLabel: (UILabel*) label
{
  UIFont* font = [UIFont fontWithName: kThemeNotesPickerTitleFontName
                                 size: kThemeNotesPickerTitleFontSize];
  UIColor* color
    = [UIColor colorWithHexString: kThemeNotesPickerTitleFontColor];
  
  label.font = font;
  label.textColor = color;
  label.textAlignment = NSTextAlignmentCenter;
}

- (void) skinSelectedNotesPickerLabel: (UILabel*) label
{
  UIFont* font = [UIFont fontWithName: kThemeNotesPickerTitleFontName
                                 size: kThemeNotesPickerTitleFontSizeSelected];
  UIColor* color
    = [UIColor colorWithHexString: kThemeNotesPickerTitleFontColor];
  
  label.font = font;
  label.textColor = color;
  label.textAlignment = NSTextAlignmentCenter;
}

- (UIImage*) iconForSixStringsWithIndex: (NSInteger) index
{
  return [UIImage imageNamed: kThemeSixStringImages[index]];
}

- (UIImage*) iconFourStringsWithIndex: (NSInteger) index
{
  return [UIImage imageNamed: kThemeFourStringImages[index]];
}

- (UIImage*) noteIconForNoteWithName: (NSString*) noteName
{
  return [UIImage imageNamed: self.notesIconNames[noteName]];
}

- (UIImage*) highlightedNoteIconForNoteWithName: (NSString*) noteName
{
  return [UIImage imageNamed: self.tunedNotesIconNames[noteName]];
}

- (void) skinFrequencyLabel: (UILabel*) label
{
  label.textAlignment = NSTextAlignmentCenter;
  label.backgroundColor = [UIColor clearColor];
}

- (NSAttributedString*) attributedStringForFrequencyLabelWithString:
    (NSString*) string
{
  NSRange rangeSpace = [string rangeOfString: @" "
                                     options: NSBackwardsSearch];
  NSRange valueRange
    = NSMakeRange(0, MIN(rangeSpace.location, string.length));
  
  NSMutableAttributedString* attrString
    = [[NSMutableAttributedString alloc] initWithString: string];
  
  /* Frequency value attributes */
  UIFont* numberFont
    = [UIFont fontWithName: kThemeFrequencyLabelFontName
                      size: kThemeFrequencyLabelNumberFontSize];
  UIColor* numberColor
    = [UIColor colorWithHexString: kThemeFrequencyLabelNumberFontColor];
  
  [attrString addAttribute: NSFontAttributeName
                     value: numberFont
                     range: valueRange];
  [attrString addAttribute: NSForegroundColorAttributeName
                     value: numberColor
                     range: valueRange];
  
  /* Frequency unit attributes */
  if (rangeSpace.location != NSNotFound)
  {
    NSRange unitRange
      = NSMakeRange(rangeSpace.location + 1,
                    string.length - rangeSpace.location -1);
    UIFont* unitFont
      = [UIFont fontWithName: kThemeFrequencyLabelFontName
                        size: kThemeFrequencyLabelUnitFontSize];
    UIColor* unitColor
      = [UIColor colorWithHexString: kThemeFrequencyLabelUnitFontColor];
    
    [attrString addAttribute: NSFontAttributeName
                       value: unitFont
                       range: unitRange];
    [attrString addAttribute: NSForegroundColorAttributeName
                       value: unitColor
                       range: unitRange];
  }
  return attrString;
}

@end
