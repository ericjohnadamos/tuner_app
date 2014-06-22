//
//  TMOAnimationHelper.h
//  SSTuneMeOn
//
//  Created by Kevin Bernard R. San Gaspar on 6/13/14.
//  Copyright (c) 2014 Eric John Adamos. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString* kAnimationKeySplash;
extern NSString* kAnimationKeyDefault;
extern NSString* kAnimationKeyDance1;
extern NSString* kAnimationKeyDance2;
extern NSString* kAnimationKeyDance3;
extern NSString* kAnimationKeyDance4;
extern NSString* kAnimationKeyDance5;
extern NSString* kAnimationKeyDance6;
extern NSString* kAnimationKeyDance7;

@interface TMOAnimationHelper : NSObject

+ (TMOAnimationHelper*) sharedHelper;

- (CAKeyframeAnimation*) animationForKey: (NSString*) animationKey;

- (void) loadAllAnimations;

@end
