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

@end
