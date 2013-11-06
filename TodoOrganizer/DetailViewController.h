//
//  DetailViewController.h
//  TodoOrganizer
//
//  Created by Apple on 11/5/13.
//  Copyright (c) 2013 Some. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Todo.h"
#import "StepsViewController.h"

@interface DetailViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) Todo *todo;

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@property (nonatomic, retain) UITableView *stepsTableView;

@property (nonatomic, strong) StepsViewController *stepsViewController;

@end
