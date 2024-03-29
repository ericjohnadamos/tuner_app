//
//  TMOUserSettings.h
//  SSTuneMeOn
//
//  Created by Eric John Adamos <ericjohnadamos@gmail.com> on 4/6/14.
//  Copyright (c) 2014 Eric John Adamos. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TMONote;
@class TMONoteGroup;

extern CGFloat kTuneVrianceThreshold;

@interface TMOUserSettings : NSObject

@property (nonatomic, assign, getter = isDefaultsLoaded) BOOL defaultsLoaded;
@property (nonatomic, assign, getter = isFirstTime) BOOL firstTime;
@property (nonatomic, weak) NSString* keyNote;
@property (nonatomic, assign) NSInteger noteGroupIndex;
@property (nonatomic, assign) NSInteger noteIndex;

+ (TMOUserSettings*) sharedInstance;
- (void) loadDefaults;
- (TMONote*) selectedNote;
- (TMONoteGroup*) selectedGroup;

@end
