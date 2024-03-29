//
//  TMODancingAnimationView.h
//  SSTuneMeOn
//
//  Created by Eric John Adamos <ericjohnadamos@gmail.com> on 3/28/14.
//  Copyright (c) 2014 Eric John Adamos. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TMODancingAnimationView : UIView

- (void) startAnimating;

- (void) enqueueAnimationWithKey: (NSString*) animationKey;

- (void) enqueueNextAnimation;

@end
