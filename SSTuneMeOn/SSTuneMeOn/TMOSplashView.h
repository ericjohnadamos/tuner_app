//
//  TMOSplashView.h
//  SSTuneMeOn
//
//  Created by Eric John Adamos <ericjohnadamos@gmail.com> on 4/6/14.
//  Copyright (c) 2014 Eric John Adamos. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TMOSplashView;
@protocol TMOSplashViewDelegate <NSObject>

- (void) splashViewDidFinishRenderingViews: (TMOSplashView*) splashView;

@end

@interface TMOSplashView : UIView

@property (nonatomic, assign) id<TMOSplashViewDelegate> delegate;

@property (nonatomic, retain) NSArray* views;

/* Initializer method which also sets splash views
 *
 * param views - An NSArray property that represents splash views
 * return id - instance of the view
 */
- (id) initWithViews: (NSArray*) views;

/* Insert and bring the subview in front of the main view
 */
- (void) renderViews;

/* Start the fading animation of the splash view
 */
- (void) animateFadeSplashView;

@end
