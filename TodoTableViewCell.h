//
//  TodoTableViewCell.h
//  TodoOrganizer
//
//  Created by Apple on 11/15/13.
//  Copyright (c) 2013 Some. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIKit/UIGestureRecognizerSubclass.h>
#import "Todo.h"
@class TodoTableViewCell;

typedef enum {
    kCellStateCenter,
    kCellStateLeft,
    kCellStateRight
} TodoCellState;

@protocol TodoTableViewCellDelegate <NSObject>

@optional
- (void)swippableTableViewCell:(TodoTableViewCell *)cell didTriggerLeftUtilityButtonWithIndex:(NSInteger)index;
- (void)swippableTableViewCell:(TodoTableViewCell *)cell scrollingToState:(TodoCellState)state;

@end

@interface TodoTableViewCell : UITableViewCell

@property (nonatomic, retain) UILabel *titleLabel;
@property (nonatomic, retain) UILabel *descriptionLabel;

@property (nonatomic) id <TodoTableViewCellDelegate> delegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier containingTableView:(UITableView *)containingTableView currentTodo: (Todo *)todo;

- (void)hideUtilityButtonsAnimated:(BOOL)animated;

- (void) changeBackgroundColor:(UIColor *) color;

-(void) loadUIElements;

@end

