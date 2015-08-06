//
//  TMOProgressView.h
//  SSTuneMeOn
//
//  Created by Eric John Adamos on 6/28/14.
//  Copyright (c) 2014 Eric John Adamos. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TMOProgressView;

@protocol TMOProgressViewDataSource <NSObject>

- (NSInteger) progressCountWithView: (TMOProgressView*) view;

- (UIView*) progressView: (TMOProgressView*) view
                 atIndex: (NSInteger)        index;

@end

@protocol TMOProgressViewDelegate <NSObject>

- (NSTimeInterval) progressViewAnimationInterval: (TMOProgressView*) view;

- (BOOL) progressView: (TMOProgressView*) view
   selectStateAtIndex: (NSInteger)        index;

@end

@interface TMOProgressView : UIView

@property (nonatomic, weak) id<TMOProgressViewDataSource> dataSource;
@property (nonatomic, weak) id<TMOProgressViewDelegate> delegate;

/*
 * Loads all the views given
 * Dependent on the datasource and delegate implementation
 */
- (void) load;

- (void) startAnimations;
- (void) stopAnimations;

@end
