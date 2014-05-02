//
//  TMONoteGroup.h
//  SSTuneMeOn
//
//  Created by Kevin Bernard R. San Gaspar on 5/2/14.
//  Copyright (c) 2014 Eric John Adamos. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TMONoteGroup : NSObject

@property (nonatomic, copy) NSString* groupName;
@property (nonatomic, retain, readonly) NSArray* notes;

- (id) initWithGroupName: (NSString*) groupName
                   notes: (NSArray*)  notes;

@end
