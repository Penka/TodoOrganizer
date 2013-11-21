//
//  TodoCell.h
//  TodoOrganizer
//
//  Created by Apple on 11/21/13.
//  Copyright (c) 2013 Some. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIKit/UIGestureRecognizerSubclass.h>
#import "Todo.h"
@class TodoCell;

typedef enum {
    kCellStateCenter,
    kCellStateLeft,
    kCellStateRight
} TodoCellState;

@protocol TodoCellDelegate <NSObject>

@optional
- (void)swippableTableViewCell:(TodoCell *)cell didTriggerLeftUtilityButtonWithIndex:(NSInteger)index;
- (void)swippableTableViewCell:(TodoCell *)cell scrollingToState:(TodoCellState)state;

@end

@interface TodoCell : UITableViewCell

@property (nonatomic, retain) UILabel *titleLabel;
@property (nonatomic, retain) UILabel *descriptionLabel;

@property (nonatomic) id <TodoCellDelegate> delegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier containingTableView:(UITableView *)containingTableView currentTodo: (Todo *)todo;

- (void)hideUtilityButtonsAnimated:(BOOL)animated;

- (void) changeBackgroundColor:(UIColor *) color;

-(void) loadUIElements;

@end

