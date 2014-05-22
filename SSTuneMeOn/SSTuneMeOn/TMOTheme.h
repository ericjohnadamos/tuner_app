//
//  TMOTheme.h
//  SSTuneMeOn
//
//  Created by Eric John Adamos <ericjohnadamos@gmail.com> on 4/15/14.
//  Copyright (c) 2014 Eric John Adamos. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TMOTheme : NSObject

- (void) skinButton: (UIButton*) button;
- (void) skinHelpButton: (UIButton*) button;
- (void) skinSelectionButton: (UIButton*) button;
- (void) skinDoneButton: (UIButton*) button;
- (void) skinCancelButton: (UIButton*) button;
- (void) skinNavigationBar: (UIView*) navBarView;
- (void) skinNavigationTitleLabel: (UILabel*) label;
- (void) skinNotesPickerView: (UIPickerView*) pickerView;
- (void) skinNotesPickerLabel: (UILabel*) label;
- (void) skinSelectedNotesPickerLabel: (UILabel*) label;
- (UIImage*) iconForSixStringsWithIndex: (NSInteger) index;
- (UIImage*) iconFourStringsWithIndex: (NSInteger) index;
- (UIImage*) noteIconForNoteWithName: (NSString*) noteName;
- (UIImage*) highlightedNoteIconForNoteWithName: (NSString*) noteName;
- (void) skinFrequencyLabel: (UILabel*) label;
- (NSAttributedString*) attributedStringForFrequencyLabelWithString:
    (NSString*) string;

@end