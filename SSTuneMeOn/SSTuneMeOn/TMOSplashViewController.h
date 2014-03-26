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


@protocol TMOSplashViewDatasource <NSObject>

@required

/**
 * Define the number of views to display
 *
 * returns NSInteger as the number of splash views
 */
- (NSInteger) numberOfSplashViews;

/**
 * Identify each views given index
 *
 * param controller as the instance of the splash view controller
 * param index as the index of the displayed view
 *
 * returns UIView as the view of the given index
 */
- (UIView*) splashViewController: (TMOSplashViewController*) controller
                     viewAtIndex: (NSInteger)                index;

@end


@interface TMOSplashViewController : UIViewController

@property (nonatomic, assign) id<TMOSplashViewDelegate> delegate;
@property (nonatomic, assign) id<TMOSplashViewDatasource> datasource;

@end
