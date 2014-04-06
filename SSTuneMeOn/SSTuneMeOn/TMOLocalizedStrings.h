//
//  TMOLocalizedStrings.h
//  SSTuneMeOn
//
//  Created by Eric John Adamos <ericjohnadamos@gmail.com> on 4/6/14.
//  Copyright (c) 2014 Eric John Adamos. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TMOLocalizedStrings : NSObject

/* Interface method that returns the string from localizable.strings file
 */
+ (NSString*) stringForKey: (NSString*) key;

@end
