//
//  TMOProgressDot.h
//  SSTuneMeOn
//
//  Created by Eric John Adamos on 6/26/14.
//  Copyright (c) 2014 Eric John Adamos. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TMOProgressDot : UIView

@property (nonatomic, strong) UIColor* fillColor;
@property (nonatomic, strong) UIColor* strokeColor;

- (void) setSelected: (BOOL) selected
            animated: (BOOL) animated;

@end
