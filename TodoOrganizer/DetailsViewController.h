//
//  DetailsViewController.h
//  TodoOrganizer
//
//  Created by Apple on 11/7/13.
//  Copyright (c) 2013 Some. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Todo.h"
#import "TodoDetailsViewController.h"

@interface DetailsViewController : UITableViewController

@property (nonatomic, strong) TodoDetailsViewController *todoDetailsViewController;

@property (nonatomic, strong) Todo *todo;
@property (nonatomic, strong) NSMutableArray *steps;

@end
