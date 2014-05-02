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
@property (nonatomic, assign) CGFloat frequency;

+ (TMONote*) noteWithName: (NSString*) name
                frequency: (CGFloat)   frequency;

- (id) initiWithName: (NSString*) name
           frequency: (CGFloat)   frequency;

- (BOOL) isEqualToNote: (TMONote*) aNote;

@end
