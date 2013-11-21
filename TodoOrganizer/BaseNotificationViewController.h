//
//  BaseNotificationViewController.h
//  TodoOrganizer
//
//  Created by Apple on 11/21/13.
//  Copyright (c) 2013 Some. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Todo.h"

@interface BaseNotificationViewController : UITableViewController<NSFetchedResultsControllerDelegate>

- (void ) scheduleNotification:(Todo *)todo;
- (UILocalNotification *) getLocalNotification:(Todo *) todo;

@end
