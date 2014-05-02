//
//  TMONotesOrganizer.h
//  SSTuneMeOn
//
//  Created by Kevin Bernard R. San Gaspar on 5/2/14.
//  Copyright (c) 2014 Eric John Adamos. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TMONoteGroup;
@class TMONote;

@interface TMONotesOrganizer : NSObject

+ (TMONotesOrganizer*) sharedInstance;

- (NSArray*) allGroups;

- (NSArray*) groupKeys;

- (TMONoteGroup*) groupForKey: (NSString*) key;

- (TMONote*) noteWithGroupKey: (NSString*) key
                        index: (NSInteger) index;

@end
