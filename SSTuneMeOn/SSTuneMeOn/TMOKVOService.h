//
//  TMOKVOService.h
//  SSTuneMeOn
//
//  Created by Eric John Adamos on 6/12/15.
//  Copyright (c) 2015 Eric John Adamos. All rights reserved.
//

#import <Foundation/Foundation.h>

/* @abstract - Block called on key-value change notification.
 * @param observer - The observer of the change.
 * @param object - The object changed.
 * @param change - The change in dictionary (key-value pair).
 */
typedef void
  (^TMOKVONotificationBlock)(id observer, id object, NSDictionary* change);

/* @abstract - This class makes the key-value observing simplier and safer.
 */
@interface TMOKVOService : NSObject

/* @abstract - Creates and returns an instance of the service with observer.
 * @param observer - The observer of the change.
 */
+ (instancetype) controllerWithObserver: (id) observer;

/* @abstract - Designated initializer
 * @param observer - The observer of the change.
 * @param retainObserved - Flag indicating whether observed objects should be
 *   retained.
 * @return - The initialized TMOKVOService instance.
 */
- (instancetype) initWithObserver: (id)   observer
                   retainObserved: (BOOL) retainObserved;

/* @abstract - Convenience initializer
 * @param observer - The object notified on key-value change.
 *   The specified observer must support weak references.
 * @return - The initialized TMOKVOService instance.
 */
- (instancetype) initWithObserver: (id) observer;

/* Observer that is being notified on key-value change. Must be specified on
 * initialization
 */
@property (atomic, weak, readonly) id observer;

/* @abstract - Registers observer for key-value change notification.
 * @param object The object to observe.
 * @param keyPath The key path to observe.
 * @param options The NSKeyValueObservingOptions to use for observation.
 * @param block The block to execute on notification.
 */
- (void) observe: (id)                         object
         keyPath: (NSString*)                  keyPath
         options: (NSKeyValueObservingOptions) options
           block: (TMOKVONotificationBlock)    block;

/* @abstract Registers observer for key-value change notification.
 * @param object The object to observe.
 * @param keyPath The key path to observe.
 * @param options The NSKeyValueObservingOptions to use for observation.
 * @param action The observer selector called on key-value change.
 */
- (void) observe: (id)                         object
         keyPath: (NSString*)                  keyPath
         options: (NSKeyValueObservingOptions) options
          action: (SEL)                        action;

/* @abstract Unobserve object key path.
 * @param object The object to unobserve.
 * @param keyPath The key path to observe.
 */
- (void) unobserve: (id)        object
           keyPath: (NSString*) keyPath;

/* @abstract Unobserve all object key paths.
 * @param object The object to unobserve.
 */
- (void) unobserve: (id) object;

/* @abstract Unobserve all objects.
 */
- (void) unobserveAll;

@end
