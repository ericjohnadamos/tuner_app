//
//  TMOProgressControl.h
//  SSTuneMeOn
//
//  Created by Eric John Adamos <ericjohnadamos@gmail.com> on 8/9/14.
//  Copyright (c) 2014 Eric John Adamos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum
{
	DDPageControlTypeOnFullOffFull = 0,
	DDPageControlTypeOnFullOffEmpty = 1,
	DDPageControlTypeOnEmptyOffFull = 2,
	DDPageControlTypeOnEmptyOffEmpty = 3,
} DDPageControlType;

@interface TMOProgressControl : UIControl

/* Get UIPageControl features */
@property (nonatomic) NSInteger numberOfPages;
@property (nonatomic) NSInteger currentPage;

@property (nonatomic) CGFloat indicatorDiameter;
@property (nonatomic) CGFloat indicatorSpace;

@property (nonatomic) BOOL hidesForSinglePage;
@property (nonatomic) BOOL defersCurrentPageDisplay;

@property (nonatomic) DDPageControlType type;

@property (nonatomic, retain) UIColor* onColor;
@property (nonatomic, retain) UIColor* offColor;

- (id) initWithType: (DDPageControlType) theType;

- (void) updateCurrentPageDisplay;

- (CGSize) sizeForNumberOfPages: (NSInteger) pageCount;

@end