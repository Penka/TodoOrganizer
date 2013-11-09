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
    UITextField *deadlineTextField;
    UITextField *placeTextField;
    UIDatePicker *deadlineDatePicker;
}

@property (nonatomic, retain) Todo *todo;
@property (nonatomic, retain) NSMutableArray *steps;
@property (nonatomic, retain) IBOutlet UIView *tableHeaderView;

@property (nonatomic, retain) IBOutlet UITextField *placeTextField;
@property (nonatomic, retain) IBOutlet UITextField *descriptionTextField;
@property (nonatomic, retain) IBOutlet UITextField *titleTextField;
@property (nonatomic, retain) IBOutlet UITextField *deadlineTextField;

@property (retain, nonatomic) IBOutlet UIDatePicker *deadlineDatePicker;



@end
