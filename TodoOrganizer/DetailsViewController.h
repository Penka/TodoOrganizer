//
//  DetailsViewController.h
//  TodoOrganizer
//
//  Created by Apple on 11/7/13.
//  Copyright (c) 2013 Some. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Todo.h"

@interface DetailsViewController : UITableViewController {
@private
    Todo *todo;
    NSMutableArray *steps;
    
    UIView *tableHeaderView;
    UITextField *titleTextField;
    UITextField *descriptionTextField;
    UITextField *placeTextField;
    UITextField *deadlineTextField;
}

@property (nonatomic, retain) Todo *todo;
@property (nonatomic, retain) NSMutableArray *steps;
@property (nonatomic, retain) IBOutlet UIView *tableHeaderView;

@property (retain, nonatomic) IBOutlet UITextField *placeTextField;
@property (retain, nonatomic) IBOutlet UITextField *descriptionTextField;
@property (retain, nonatomic) IBOutlet UITextField *titleTextField;
@property (retain, nonatomic) IBOutlet UITextField *deadlineTextField;


@end
