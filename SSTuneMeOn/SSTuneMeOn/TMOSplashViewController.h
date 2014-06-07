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

@optional

/**
 * By default it is set to YES.
 *
 * returns BOOL as isAnimated
 */
- (BOOL) displayWithAnimations;

/**
 * Additional methods that will make after splash animations
 *
 * param controller as the instance of the splash view controller
 *
 * no return
 */
- (void) splashViewControllerDidFinishDisplayViews:
(TMOSplashViewController*) controller;

@end

@end


@interface TMOSplashViewController : UIViewController

@property (nonatomic, assign) id<TMOSplashViewDelegate> delegate;

@end
