//
//  AddStepViewController.h
//  TodoOrganizer
//
//  Created by Apple on 11/6/13.
//  Copyright (c) 2013 Some. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Todo.h"

@interface AddStepViewController : UIViewController

@property (strong, nonatomic) Todo *todo;

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@end
