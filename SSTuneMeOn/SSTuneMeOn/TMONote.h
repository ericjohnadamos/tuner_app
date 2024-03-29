//
//  TMONote.h
//  SSTuneMeOn
//
//  Created by Kevin Bernard R. San Gaspar on 5/2/14.
//  Copyright (c) 2014 Eric John Adamos. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TMONote : NSObject

@property (nonatomic, copy) NSString* name;
@property (nonatomic, strong) NSArray* frequencies;

+ (TMONote*) noteWithName: (NSString*) name
              frequencies: (NSArray*)  frequencies;

- (id) initWithName: (NSString*) name
        frequencies: (NSArray*)  frequencies;

@end
