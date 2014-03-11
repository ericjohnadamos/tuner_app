//
//  TMOKeyHelper.h
//  SSTuneMeOn
//
//  Created by Eric John Adamos <ericjohnadamos@gmail.com> on 3/10/14.
//  Copyright (c) 2014 Eric John Adamos. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface TMOKeyHelper : NSObject

@property (nonatomic, retain) NSMutableDictionary* keyMapping;
@property (nonatomic, retain) NSMutableDictionary* frequencyMapping;

#pragma mark - Key generation

- (void) buildKeyMapping;

- (NSString*) closestCharForFrequency: (CGFloat) frequency;

#pragma mark - Initializer

+ (TMOKeyHelper*) sharedInstance;

@end
