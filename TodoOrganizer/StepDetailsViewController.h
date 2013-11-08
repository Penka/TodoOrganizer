//
//  StepDetailsViewController.h
//  TodoOrganizer
//
//  Created by Apple on 11/8/13.
//  Copyright (c) 2013 Some. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Todo.h"
#import "Step.h"

@interface StepDetailsViewController : UITableViewController
{
    @private
        Todo *todo;
        Step *step;
        UITextField *stepTextTextField;
        UISwitch *isDoneSwitch;
}

@property (nonatomic, retain) Todo *todo;
@property (nonatomic, retain) Step *step;

@end
