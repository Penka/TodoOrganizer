//
//  TodoCell.h
//  TodoOrganizer
//
//  Created by Apple on 11/7/13.
//  Copyright (c) 2013 Some. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Todo.h"

@interface TodoCell : UITableViewCell
{
    Todo *todo;
    
    UILabel *titleLabel;
    UILabel *descriptionLabel;
}

@property (nonatomic, retain) Todo *todo;

@property (nonatomic, retain) UILabel *titleLabel;
@property (nonatomic, retain) UILabel *descriptionLabel;

@property (strong, nonatomic) UIButton *completeTodoButton;

@end

