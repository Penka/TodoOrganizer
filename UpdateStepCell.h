//
//  UpdateStepCell.h
//  TodoOrganizer
//
//  Created by Apple on 11/8/13.
//  Copyright (c) 2013 Some. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Step.h"

@interface UpdateStepCell : UITableViewCell

{
    Step *step;
    
    UITextField *stepTextTextField;
    UISwitch *isDoneSwitch;
}

@property (nonatomic, retain) Step *step;

@property (nonatomic, retain) UITextField *stepTextTextField;
@property (nonatomic, retain) UISwitch *isDoneSwitch;


@end
