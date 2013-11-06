//
//  DetailViewController.h
//  TodoOrganizer
//
//  Created by Apple on 11/5/13.
//  Copyright (c) 2013 Some. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Todo.h"

@interface DetailViewController : UIViewController

@property (strong, nonatomic) Todo *todo;

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

-(void) completeTodo;

@end
