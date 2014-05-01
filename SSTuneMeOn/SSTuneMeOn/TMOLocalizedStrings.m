//
//  TMOLocalizedStrings.m
//  SSTuneMeOn
//
//  Created by Eric John Adamos <ericjohnadamos@gmail.com> on 4/6/14.
//  Copyright (c) 2014 Eric John Adamos. All rights reserved.
//

#import "TMOLocalizedStrings.h"

NSString* const kBCLocalizedStringsTableName = @"TMOLocalizable";

/* Tutorial */
NSString* const kTMOTutorialWebViewText = @"TMOTutorialWebViewText";
NSString* const kTMOTutorialOkayButtonText = @"TMOTutorialOkayButtonText";

/* Main view */
NSString* const kTMOHertz = @"TMOHertz";

/* Navigation Bar */
NSString* const kTMOAcousticGuitar = @"TMOAcousticGuitar";
NSString* const kTMOBassGuitar = @"TMOBassGuitar";


@implementation TMOLocalizedStrings

+ (NSString*) stringForKey: (NSString*) key
{
  return NSLocalizedStringFromTable(key, kBCLocalizedStringsTableName, @"");
}

@end
