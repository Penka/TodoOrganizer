//
//  BaseNotificationViewController.m
//  TodoOrganizer
//
//  Created by Apple on 11/21/13.
//  Copyright (c) 2013 Some. All rights reserved.
//

#import "BaseNotificationViewController.h"
#import "Todo.h"

@implementation BaseNotificationViewController

- (UILocalNotification *) getLocalNotification:(Todo *) todo
{
    UILocalNotification *notification = nil;
    NSArray *allNotifications = [[UIApplication sharedApplication] scheduledLocalNotifications];
    
    for (UILocalNotification *locanNotification in allNotifications) {
        if(locanNotification.fireDate == [todo.deadline dateByAddingTimeInterval:-(60*30)] && [locanNotification.alertBody isEqualToString:todo.title]){
            notification = locanNotification;
            break;
        }
    }
    
    return notification;
}

- (void) scheduleNotification:(Todo *)todo
{
    if((!todo.isDone.boolValue) && ([todo.deadline compare:[NSDate date]]==NSOrderedDescending)){

        UILocalNotification* localNotification = [[UILocalNotification alloc] init];
    
        //Setting the notification 30 minutes before the deadline.
        NSDate *fireDate = [todo.deadline dateByAddingTimeInterval:-(60*30)];
        localNotification.fireDate = fireDate;
        localNotification.alertBody = todo.title;
        localNotification.timeZone = [NSTimeZone defaultTimeZone];
        localNotification.applicationIconBadgeNumber = [[UIApplication sharedApplication] applicationIconBadgeNumber] + 1;
    
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    }
}

@end
