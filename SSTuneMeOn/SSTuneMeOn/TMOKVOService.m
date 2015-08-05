//
//  TMOKVOService.m
//  SSTuneMeOn
//
//  Created by Eric John Adamos on 6/12/15.
//  Copyright (c) 2015 Eric John Adamos. All rights reserved.
//

#import "TMOKVOService.h"

#import <libkern/OSAtomic.h>
#import <objc/message.h>

#pragma mark - Utilities

static NSString* describe_option(NSKeyValueObservingOptions option)
{
  switch (option)
  {
    case NSKeyValueObservingOptionNew:
      return @"NSKeyValueObservingOptionNew";
      break;
    case NSKeyValueObservingOptionOld:
      return @"NSKeyValueObservingOptionOld";
      break;
    case NSKeyValueObservingOptionInitial:
      return @"NSKeyValueObservingOptionInitial";
      break;
    case NSKeyValueObservingOptionPrior:
      return @"NSKeyValueObservingOptionPrior";
      break;
    default:
      NSCAssert(NO, @"unexpected option %lu", (unsigned long)option);
      break;
  }
  return nil;
}

static void append_option_description(NSMutableString* s, NSUInteger option)
{
  if (0 == s.length)
  {
    [s appendString: describe_option(option)];
  } else
  {
    [s appendString: @"|"];
    [s appendString: describe_option(option)];
  }
}

static NSUInteger enumerate_flags(NSUInteger* ptrFlags)
{
  NSCAssert(ptrFlags, @"expected ptrFlags");
  if (!ptrFlags)
  {
    return 0;
  }
  
  NSUInteger flags = *ptrFlags;
  if (!flags)
  {
    return 0;
  }
  
  NSUInteger flag = 1 << __builtin_ctzl(flags);
  flags &= ~flag;
  *ptrFlags = flags;
  return flag;
}

static NSString* describe_options(NSKeyValueObservingOptions options)
{
  NSMutableString* s = [NSMutableString string];
  NSUInteger option;
  while (0 != (option = enumerate_flags(&options)))
  {
    append_option_description(s, option);
  }
  return s;
}

#pragma mark - _FBKVOInfo

/* @abstract The key-value observation info.
 */
@interface _FBKVOInfo : NSObject
@end

@implementation _FBKVOInfo
{
@public
  __weak TMOKVOService* _controller;
  NSString* _keyPath;
  NSKeyValueObservingOptions _options;
  SEL _action;
  void* _context;
  TMOKVONotificationBlock _block;
}

- (instancetype) initWithController: (TMOKVOService*)             controller
                            keyPath: (NSString*)                  keyPath
                            options: (NSKeyValueObservingOptions) options
                              block: (TMOKVONotificationBlock)    block
                             action: (SEL)                        action
                            context: (void*)                      context
{
  self = [super init];
  if (nil != self)
  {
    _controller = controller;
    _block = [block copy];
    _keyPath = [keyPath copy];
    _options = options;
    _action = action;
    _context = context;
  }
  return self;
}

- (instancetype) initWithController: (TMOKVOService*)             controller
                            keyPath: (NSString*)                  keyPath
                            options: (NSKeyValueObservingOptions) options
                              block: (TMOKVONotificationBlock)    block
{
  return [self initWithController: controller
                          keyPath: keyPath
                          options: options
                            block: block
                           action: NULL
                          context: NULL];
}

- (instancetype) initWithController: (TMOKVOService*)             controller
                            keyPath: (NSString*)                  keyPath
                            options: (NSKeyValueObservingOptions) options
                             action: (SEL)                        action
{
  return [self initWithController: controller
                          keyPath: keyPath
                          options: options
                            block: NULL
                           action: action
                          context: NULL];
}

- (instancetype) initWithController: (TMOKVOService*)             controller
                            keyPath: (NSString*)                  keyPath
                            options: (NSKeyValueObservingOptions) options
                            context: (void*)                      context
{
  return [self initWithController: controller
                          keyPath: keyPath
                          options: options
                            block: NULL
                           action: NULL
                          context: context];
}

- (instancetype) initWithController: (TMOKVOService*) controller
                            keyPath: (NSString*)      keyPath
{
  return [self initWithController: controller
                          keyPath: keyPath
                          options: 0
                            block: NULL
                           action: NULL
                          context: NULL];
}

- (NSUInteger) hash
{
  return [_keyPath hash];
}

- (BOOL) isEqual: (id) object
{
  if (nil == object)
  {
    return NO;
  }
  if (self == object)
  {
    return YES;
  }
  if (![object isKindOfClass: [self class]])
  {
    return NO;
  }
  return [_keyPath isEqualToString: ((_FBKVOInfo*)object)->_keyPath];
}

- (NSString*) debugDescription
{
  NSMutableString* s = [NSMutableString stringWithFormat:
                        @"<%@:%p keyPath:%@",
                        NSStringFromClass([self class]),
                        self,
                        _keyPath];
  if (0 != _options)
  {
    [s appendFormat: @" options:%@", describe_options(_options)];
  }
  if (NULL != _action)
  {
    [s appendFormat: @" action:%@", NSStringFromSelector(_action)];
  }
  if (NULL != _context)
  {
    [s appendFormat: @" context:%p", _context];
  }
  if (NULL != _block)
  {
    [s appendFormat: @" block:%p", _block];
  }
  [s appendString: @">"];
  return s;
}

@end

#pragma mark _FBKVOSharedController -

/* @abstract - The shared KVO controller instance.
 */
@interface _FBKVOSharedController : NSObject

/* @abstract - A shared instance that never deallocates.
 */
+ (instancetype)sharedController;

/* @abstract - Observe an object, info pair
 */
- (void)observe:(id)object info:(_FBKVOInfo*)info;

/* @abstract - Unobserve an object, info pair
 */
- (void)unobserve:(id)object info:(_FBKVOInfo*)info;

/* @abstract - Unobserve an object with a set of infos
 */
- (void)unobserve:(id)object infos:(NSSet *)infos;

@end

@implementation _FBKVOSharedController
{
  NSHashTable* _infos;
  OSSpinLock _lock;
}

+ (instancetype) sharedController
{
  static _FBKVOSharedController* _controller = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^
  {
    _controller = [[_FBKVOSharedController alloc] init];
  });
  return _controller;
}

- (instancetype)init
{
  self = [super init];
  if (nil != self)
  {
    NSHashTable* infos = [NSHashTable alloc];
#ifdef __IPHONE_OS_VERSION_MIN_REQUIRED
    _infos = [infos initWithOptions:
              (  NSPointerFunctionsWeakMemory
               | NSPointerFunctionsObjectPointerPersonality)
                           capacity: 0];
    
#elif defined(__MAC_OS_X_VERSION_MIN_REQUIRED)
    if ([NSHashTable respondsToSelector: @selector(weakObjectsHashTable)])
    {
      _infos = [infos initWithOptions:
                (  NSPointerFunctionsWeakMemory
                 | NSPointerFunctionsObjectPointerPersonality)
                             capacity: 0];
    }
    else
    {
      // silence deprecated warnings
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
      _infos = [infos initWithOptions:NSPointerFunctionsZeroingWeakMemory|NSPointerFunctionsObjectPointerPersonality capacity:0];
#pragma clang diagnostic pop
    }
    
#endif
    _lock = OS_SPINLOCK_INIT;
  }
  return self;
}

- (NSString*) debugDescription
{
  NSMutableString* s = [NSMutableString stringWithFormat:
                        @"<%@:%p", NSStringFromClass([self class]), self];
  
  /* Lock */
  OSSpinLockLock(&_lock);
  
  NSMutableArray* infoDescriptions
    = [NSMutableArray arrayWithCapacity: _infos.count];
  
  for (_FBKVOInfo* info in _infos)
  {
    [infoDescriptions addObject: info.debugDescription];
  }
  
  [s appendFormat: @" contexts:%@", infoDescriptions];
  
  /* Unlock */
  OSSpinLockUnlock(&_lock);
  
  [s appendString: @">"];
  return s;
}

- (void) observe: (id)          object
            info: (_FBKVOInfo*) info
{
  if (nil == info)
  {
    return;
  }
  
  /* Register info */
  OSSpinLockLock(&_lock);
  [_infos addObject: info];
  OSSpinLockUnlock(&_lock);
  
  /* Add observer */
  [object addObserver: self
           forKeyPath: info->_keyPath
              options: info->_options
              context: (void*) info];
}

- (void) unobserve: (id)          object
              info: (_FBKVOInfo*) info
{
  if (nil == info)
  {
    return;
  }
  
  /* Unregister info */
  OSSpinLockLock(&_lock);
  [_infos removeObject:info];
  OSSpinLockUnlock(&_lock);
  
  /* Remove observer */
  [object removeObserver: self
              forKeyPath: info->_keyPath
                 context: (void*) info];
}

- (void) unobserve: (id)     object
             infos: (NSSet*) infos
{
  if (0 == infos.count)
  {
    return;
  }
  
  /* Unregister info */
  OSSpinLockLock(&_lock);
  for (_FBKVOInfo* info in infos)
  {
    [_infos removeObject:info];
  }
  OSSpinLockUnlock(&_lock);
  
  /* Remove observer */
  for (_FBKVOInfo* info in infos)
  {
    [object removeObserver: self
                forKeyPath: info->_keyPath
                   context: (void*) info];
  }
}

- (void) observeValueForKeyPath: (NSString*)     keyPath
                       ofObject: (id)            object
                         change: (NSDictionary*) change
                        context: (void*)         context
{
  NSAssert(context,
           @"missing context keyPath:%@ object:%@ change:%@",
           keyPath,
           object,
           change);
  
  _FBKVOInfo* info;
  
  {
    /* Lookup context in registered infos, taking out a strong reference only if
     * it exists
     */
    OSSpinLockLock(&_lock);
    info = [_infos member: (__bridge id)context];
    OSSpinLockUnlock(&_lock);
  }
  
  if (nil != info)
  {
    /* Take strong reference to controller */
    TMOKVOService* controller = info->_controller;
    
    if (nil != controller)
    {
      /* Take strong reference to observer */
      id observer = controller.observer;
      if (nil != observer)
      {
        /* Dispatch custom block or action, fall back to default action */
        if (info->_block)
        {
          info->_block(observer, object, change);
        }
        else if (info->_action)
        {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
          [observer performSelector: info->_action
                         withObject: change
                         withObject: object];
#pragma clang diagnostic pop
        }
        else
        {
          [observer observeValueForKeyPath: keyPath
                                  ofObject: object
                                    change: change
                                   context: info->_context];
        }
      }
    }
  }
}

@end

#pragma mark TMOKVOService -

@implementation TMOKVOService
{
  NSMapTable* _objectInfosMap;
  OSSpinLock _lock;
}

#pragma mark Lifecycle -

+ (instancetype) controllerWithObserver: (id) observer
{
  return [[self alloc] initWithObserver: observer];
}

- (instancetype) initWithObserver: (id)   observer
                   retainObserved: (BOOL) retainObserved
{
  self = [super init];
  if (nil != self)
  {
    _observer = observer;
    NSPointerFunctionsOptions keyOptions
      = retainObserved ? (  NSPointerFunctionsStrongMemory
                          | NSPointerFunctionsObjectPointerPersonality)
                       : (  NSPointerFunctionsWeakMemory
                          | NSPointerFunctionsObjectPointerPersonality);
    
    _objectInfosMap
      = [[NSMapTable alloc]
         initWithKeyOptions: keyOptions
               valueOptions: (  NSPointerFunctionsStrongMemory
                              | NSPointerFunctionsObjectPersonality)
                   capacity: 0];
    
    _lock = OS_SPINLOCK_INIT;
  }
  return self;
}

- (instancetype) initWithObserver: (id) observer
{
  return [self initWithObserver: observer
                 retainObserved: YES];
}

- (void) dealloc
{
  [self unobserveAll];
}

#pragma mark Properties -

- (NSString*) debugDescription
{
  NSMutableString* s = [NSMutableString stringWithFormat:
                        @"<%@:%p", NSStringFromClass([self class]), self];
  
  [s appendFormat: @" observer:<%@:%p>",
   NSStringFromClass([_observer class]), _observer];
  
  /* Lock */
  OSSpinLockLock(&_lock);
  
  if (0 != _objectInfosMap.count)
  {
    [s appendString: @"\n  "];
  }
  
  for (id object in _objectInfosMap)
  {
    NSMutableSet* infos = [_objectInfosMap objectForKey: object];
    NSMutableArray* infoDescriptions = [NSMutableArray arrayWithCapacity:
                                        infos.count];
    
    [infos enumerateObjectsUsingBlock: ^(_FBKVOInfo* info, BOOL* stop)
     {
      [infoDescriptions addObject: info.debugDescription];
    }];
    
    [s appendFormat: @"%@ -> %@", object, infoDescriptions];
  }
  
  /* Unlock */
  OSSpinLockUnlock(&_lock);
  
  [s appendString: @">"];
  return s;
}

#pragma mark Utilities -

- (void)_observe:(id)object info:(_FBKVOInfo*)info
{
  /* Lock */
  OSSpinLockLock(&_lock);
  
  NSMutableSet* infos = [_objectInfosMap objectForKey: object];
  
  /* Check for info existence */
  _FBKVOInfo* existingInfo = [infos member: info];
  if (nil != existingInfo)
  {
    NSLog(@"observation info already exists %@", existingInfo);
    
    /* Unlock and return */
    OSSpinLockUnlock(&_lock);
    return;
  }
  
  /* Lazilly create set of infos */
  if (nil == infos)
  {
    infos = [NSMutableSet set];
    [_objectInfosMap setObject: infos
                        forKey: object];
  }
  
  /* Add info and observe */
  [infos addObject:info];
  
  /* Unlock prior to callout */
  OSSpinLockUnlock(&_lock);
  
  [[_FBKVOSharedController sharedController] observe: object
                                                info: info];
}

- (void) _unobserve: (id)          object
               info: (_FBKVOInfo*) info
{
  /* Lock */
  OSSpinLockLock(&_lock);
  
  /* Get observation infos */
  NSMutableSet* infos = [_objectInfosMap objectForKey: object];
  
  /* Lookup registered info instance */
  _FBKVOInfo* registeredInfo = [infos member: info];
  
  if (nil != registeredInfo)
  {
    [infos removeObject: registeredInfo];
    
    /* Remove no longer used infos */
    if (0 == infos.count)
    {
      [_objectInfosMap removeObjectForKey: object];
    }
  }
  
  /* Unlock */
  OSSpinLockUnlock(&_lock);
  
  /* Unobserve */
  [[_FBKVOSharedController sharedController] unobserve: object
                                                  info: registeredInfo];
}

- (void) _unobserve: (id) object
{
  /* Lock */
  OSSpinLockLock(&_lock);
  
  NSMutableSet* infos = [_objectInfosMap objectForKey: object];
  
  /* Remove infos */
  [_objectInfosMap removeObjectForKey:object];
  
  /* Unlock */
  OSSpinLockUnlock(&_lock);
  
  /* Unobserve */
  [[_FBKVOSharedController sharedController] unobserve: object
                                                 infos: infos];
}

- (void) _unobserveAll
{
  /* Lock */
  OSSpinLockLock(&_lock);
  
  NSMapTable* objectInfoMaps = [_objectInfosMap copy];
  
  /* Clear table and map */
  [_objectInfosMap removeAllObjects];
  
  /* Unlock */
  OSSpinLockUnlock(&_lock);
  
  _FBKVOSharedController* shareController
    = [_FBKVOSharedController sharedController];
  
  for (id object in objectInfoMaps)
  {
    /* Unobserve each registered object and infos */
    NSSet *infos = [objectInfoMaps objectForKey: object];
    [shareController unobserve: object
                         infos: infos];
  }
}

#pragma mark - API

- (void) observe: (id)                         object
         keyPath: (NSString*)                  keyPath
         options: (NSKeyValueObservingOptions) options
           block: (TMOKVONotificationBlock)    block
{
  NSAssert(0 != keyPath.length && NULL != block,
           @"missing required parameters observe:%@ keyPath:%@ block:%p",
           object,
           keyPath,
           block);
  
  if (nil == object || 0 == keyPath.length || NULL == block)
  {
    return;
  }
  
  /* Create info */
  _FBKVOInfo* info = [[_FBKVOInfo alloc] initWithController: self
                                                    keyPath: keyPath
                                                    options: options
                                                      block: block];
  
  /* Observe object with info */
  [self _observe: object
            info: info];
}

- (void) observe: (id)                         object
         keyPath: (NSString*)                  keyPath
         options: (NSKeyValueObservingOptions) options
          action: (SEL)                        action
{
  NSAssert(0 != keyPath.length && NULL != action,
           @"missing required parameters observe:%@ keyPath:%@ action:%@",
           object,
           keyPath,
           NSStringFromSelector(action));
  
  NSAssert([_observer respondsToSelector: action],
           @"%@ does not respond to %@",
           _observer,
           NSStringFromSelector(action));
  
  if (nil == object || 0 == keyPath.length || NULL == action)
  {
    return;
  }
  
  /* Create info */
  _FBKVOInfo* info = [[_FBKVOInfo alloc] initWithController: self
                                                    keyPath: keyPath
                                                    options: options
                                                     action: action];
  
  /* Observe object with info */
  [self _observe: object
            info: info];
}

- (void) observe: (id)                         object
         keyPath: (NSString*)                  keyPath
         options: (NSKeyValueObservingOptions) options
         context: (void*)                      context
{
  NSAssert(0 != keyPath.length,
           @"missing required parameters observe:%@ keyPath:%@",
           object,
           keyPath);
  
  if (nil == object || 0 == keyPath.length)
  {
    return;
  }
  
  /* Create info */
  _FBKVOInfo* info = [[_FBKVOInfo alloc] initWithController: self
                                                    keyPath: keyPath
                                                    options: options
                                                    context: context];
  
  /* Observe object with info */
  [self _observe: object
            info: info];
}

- (void) unobserve: (id)        object
           keyPath: (NSString*) keyPath
{
  /* Create representative info */
  _FBKVOInfo* info = [[_FBKVOInfo alloc] initWithController: self
                                                    keyPath: keyPath];
  
  /* Unobserve object property */
  [self _unobserve: object
              info: info];
}

- (void) unobserve: (id) object
{
  if (nil == object)
  {
    return;
  }
  
  [self _unobserve: object];
}

- (void) unobserveAll
{
  [self _unobserveAll];
}

@end
