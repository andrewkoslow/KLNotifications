//
//  NSObject+KLNotifications.m
//  KLNotifications
//
//  Created by Andrew Koslow on 16.12.12.
//  Copyright (c) 2012 Andrew Koslow. All rights reserved.
//

#import "NSObject+KLNotifications.h"


@interface NSObject (KLNotificationsPrivate)

- (void)observeNotificationsForObject:(id)object name:(NSString *)name namesVA:(va_list)names;
- (void)observeWithSelector:(SEL)selector notificationsForObject:(id)object name:(NSString *)name namesVA:(va_list)names;
- (void)stopObservingNotificationsForObject:(id)object name:(NSString *)name namesVA:(va_list)names;

@end


@implementation NSObject (KLNotifications)


- (void)observeNotificationsNames:(NSString *)name, ... {
    va_list args;
    va_start(args, name);
    
    [self observeNotificationsForObject:nil name:name namesVA:args];
    
    va_end(args);
}


- (void)observeNotificationsForObject:(id)object names:(NSString *)name, ... {
    va_list args;
    va_start(args, name);
    
    [self observeNotificationsForObject:object name:name namesVA:args];
    
    va_end(args);
}


- (void)observeNotificationsForObject:(id)object name:(NSString *)name namesVA:(va_list)names {
    NSString *suffix = @"Notification";
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    
    for (; name != nil; name = va_arg(names, NSString *)) {
        NSString *proposedSelector = nil;
        
        if (name.length > suffix.length && [name hasSuffix:suffix]) {
            NSScanner *scanner = [NSScanner scannerWithString:name];
            scanner.caseSensitive = YES;
            
            NSString *prefix = nil;
            BOOL result = [scanner scanCharactersFromSet:[NSCharacterSet uppercaseLetterCharacterSet] intoString:&prefix];
            if (result) proposedSelector = [name substringFromIndex:(prefix.length - 1)];
            
            if (proposedSelector.length > suffix.length) {
                NSString *lowercasedFirstCharacter = [[proposedSelector substringToIndex:1] lowercaseString];
                NSString *remainingPart = [proposedSelector substringFromIndex:1];
                remainingPart = [remainingPart substringToIndex:(remainingPart.length - suffix.length)];
                proposedSelector = [lowercasedFirstCharacter stringByAppendingString:remainingPart];
            }
            
            if (proposedSelector.length == 0) proposedSelector = nil;
        }
        
        SEL selector = NSSelectorFromString(proposedSelector);
        if ([self respondsToSelector:selector] == NO) {
            proposedSelector = [proposedSelector stringByAppendingString:@":"];
            selector = NSSelectorFromString(proposedSelector);
        }
        
        NSAssert1([self respondsToSelector:selector], @"[self respondsToSelector:(%@)]", NSStringFromSelector(selector));
        
        [center addObserver:self selector:selector name:name object:object];
    }
}


- (void)observeWithSelector:(SEL)selector notificationsNames:(NSString *)name, ... {
    va_list args;
    va_start(args, name);
    
    [self observeWithSelector:selector notificationsForObject:nil name:name namesVA:args];
    
    va_end(args);
}


- (void)observeWithSelector:(SEL)selector notificationsForObject:(id)object names:(NSString *)name, ... {
    va_list args;
    va_start(args, name);
    
    [self observeWithSelector:selector notificationsForObject:object name:name namesVA:args];
    
    va_end(args);
}


- (void)observeWithSelector:(SEL)selector notificationsForObject:(id)object name:(NSString *)name namesVA:(va_list)names {
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    
    for (; name != nil; name = va_arg(names, NSString *)) {
        NSAssert1([self respondsToSelector:selector], @"[self respondsToSelector:(%@)]", NSStringFromSelector(selector));
        [center addObserver:self selector:selector name:name object:object];
    }
}


- (void)stopObservingNotificationsNames:(NSString *)name, ... {
    va_list names;
    va_start(names, name);
    
	[self stopObservingNotificationsForObject:nil name:name namesVA:names];
    
    va_end(names);
}


- (void)stopObservingNotificationsForObject:(id)object names:(NSString *)name, ... {
    va_list names;
    va_start(names, name);
    
	[self stopObservingNotificationsForObject:object name:name namesVA:names];
    
    va_end(names);
}


- (void)stopObservingNotificationsForObject:(id)object name:(NSString *)name namesVA:(va_list)names {
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    
    for (; name != nil; name = va_arg(names, NSString *)) {
        [center removeObserver:self name:name object:object];
    }
}


- (void)stopObservingNotifications {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
