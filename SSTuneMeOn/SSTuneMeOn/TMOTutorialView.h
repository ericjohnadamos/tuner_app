//
//  TMOTutorialView.h
//  SSTuneMeOn
//
//  Created by Eric John Adamos <ericjohnadamos@gmail.com> on 4/6/14.
//  Copyright (c) 2014 Eric John Adamos. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TMOTutorialView;
@protocol TMOTutorialViewDelegate <NSObject>

- (void) tutorialView: (TMOTutorialView*) tutorialView
     didTapOkayButton: (UIButton*)        okayButton;

@end

@interface TMOTutorialView : UIView

- (void) loadWebView;

@end
