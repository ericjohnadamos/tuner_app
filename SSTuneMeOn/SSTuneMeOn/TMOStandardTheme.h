//
//  TMOStandardTheme.h
//  SSTuneMeOn
//
//  Created by Eric John Adamos <ericjohnadamos@gmail.com> on 4/15/14.
//  Copyright (c) 2014 Eric John Adamos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TMOTheme.h"

@interface TMOStandardTheme : TMOTheme

/* Method that returns an instance of itself
 * The implementation of this code represents this entire class is a singleton
 */
+ (TMOStandardTheme*) sharedInstance;

@end
