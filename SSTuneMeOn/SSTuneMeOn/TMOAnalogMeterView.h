//
//  TMOAnalogMeterView.h
//  SSTuneMeOn
//
//  Created by Kevin Bernard R. San Gaspar on 5/4/14.
//  Copyright (c) 2014 Eric John Adamos. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TMOAnalogMeterView : UIView

/**
 * A -1 variance will move the pin to leftmost, 0 to the center,
 * 1 to the rightmost side of the meter 
 */
- (void) updateToVariance: (CGFloat) variance;
- (void) start;
- (void) stop;
@end
