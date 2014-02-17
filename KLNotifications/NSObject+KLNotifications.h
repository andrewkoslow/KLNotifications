//
//  NSObject+KLNotifications.h
//  KLNotifications
//
//  Created by Andrew Koslow on 16.12.12.
//  Copyright (c) 2012 Andrew Koslow. All rights reserved.
//

@import Foundation;


@interface NSObject (KLNotifications)

- (void)observeNotificationsNames:(NSString *)name, ... NS_REQUIRES_NIL_TERMINATION;
- (void)observeNotificationsForObject:(id)object names:(NSString *)name, ... NS_REQUIRES_NIL_TERMINATION;
- (void)observeWithSelector:(SEL)selector notificationsNames:(NSString *)name, ... NS_REQUIRES_NIL_TERMINATION;
- (void)observeWithSelector:(SEL)selector notificationsForObject:(id)object names:(NSString *)name, ... NS_REQUIRES_NIL_TERMINATION;
- (void)stopObservingNotificationsNames:(NSString *)name, ... NS_REQUIRES_NIL_TERMINATION;
- (void)stopObservingNotificationsForObject:(id)object names:(NSString *)name, ... NS_REQUIRES_NIL_TERMINATION;
- (void)stopObservingNotifications;

@end
