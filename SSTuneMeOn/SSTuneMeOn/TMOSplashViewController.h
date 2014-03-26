//
//  TMOSplashViewController.h
//  SSTuneMeOn
//
//  Created by Eric John Adamos <ericjohnadamos@gmail.com> on 3/10/14.
//  Copyright (c) 2014 Eric John Adamos. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TMOSplashViewController;

@protocol TMOSplashViewDelegate <NSObject>

- (NSInteger) numberOfSplashViews;

- (UIView*) splashViewController: (TMOSplashViewController*) controller
                     viewAtIndex: (NSInteger)                index;

- (void) splashViewControllerDidFinishDisplayViews:
  (TMOSplashViewController*) controller;

@end

@interface TMOSplashViewController : UIViewController

@property (nonatomic, assign) id<TMOSplashViewDelegate> delegate;

@end
