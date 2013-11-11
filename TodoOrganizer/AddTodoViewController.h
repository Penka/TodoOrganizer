//
//  AddTodoViewController.h
//  TodoOrganizer
//
//  Created by Apple on 11/5/13.
//  Copyright (c) 2013 Some. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TodoDetailsViewController.h"

@interface AddTodoViewController : UIViewController

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@end
