//
//  TodoCell.m
//  TodoOrganizer
//
//  Created by Apple on 11/21/13.
//  Copyright (c) 2013 Some. All rights reserved.
//

#import "TodoCell.h"
#import "BaseNotificationViewController.h"

#define buttonWidthDefault 90
#define cellOffset 20

static NSString * const kTableViewCellContentView = @"UITableViewCellContentView";

@interface TodoCell () <UIScrollViewDelegate> {
    TodoCellState _cellState;
    CGFloat additionalRightPadding;
    Todo* _todo;
}

@property (nonatomic, weak) UIScrollView *cellScrollView;

@property (nonatomic, strong) UIButton *manageTodoButton;
@property (nonatomic, strong) UIButton *deleteTodoButton;

@property (nonatomic) CGFloat height;

// Views that live in the scroll view
@property (nonatomic, weak) UIView *scrollViewContentView;

@property (nonatomic, weak) UITableView *containingTableView;

@end

@implementation TodoCell

#pragma mark Initializers

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier containingTableView:(UITableView *)containingTableView currentTodo: (Todo *)todo
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _todo = todo;
        self.manageTodoButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, buttonWidthDefault, self.bounds.size.height)];
        self.manageTodoButton.backgroundColor = [UIColor greenColor];
        [self.manageTodoButton addTarget:self action:@selector(manageTodo) forControlEvents:UIControlEventTouchDown];
        
        self.deleteTodoButton = [[UIButton alloc] initWithFrame:CGRectMake(self.bounds.size.width - buttonWidthDefault, 0, buttonWidthDefault, self.bounds.size.height)];
        self.deleteTodoButton.backgroundColor = [UIColor redColor];
        [self.deleteTodoButton setTitle:@"Delete" forState:UIControlStateNormal];
        
        self.height = containingTableView.rowHeight;
        self.containingTableView = containingTableView;
        self.highlighted = NO;
        [self initializer];
        
        self.descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(cellOffset, self.height / 2, self.bounds.size.width - cellOffset, self.height / 2)];
        [self.descriptionLabel setFont:[UIFont systemFontOfSize:12.0]];
        [self.descriptionLabel setTextColor:[UIColor darkGrayColor]];
        [self.descriptionLabel setHighlightedTextColor:[UIColor whiteColor]];
        self.descriptionLabel.text = todo.todoDescription;
        [self.contentView addSubview:self.descriptionLabel];
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(cellOffset, 0, self.bounds.size.width - cellOffset, self.height / 2)];
        [self.titleLabel setFont:[UIFont boldSystemFontOfSize:14.0]];
        [self.titleLabel setTextColor:[UIColor blackColor]];
        [self.titleLabel setHighlightedTextColor:[UIColor whiteColor]];
        self.titleLabel.text = todo.title;
        [self.contentView addSubview:self.titleLabel];
    }
    
    return self;
}


- (void) manageTodo
{
    BaseNotificationViewController *notificationsController = [[BaseNotificationViewController alloc ]init];
    UILocalNotification *notification = [notificationsController getLocalNotification:_todo];
    
    NSManagedObjectContext *context = [_todo managedObjectContext];
    BOOL isStepDone = !_todo.isDone.boolValue;
    
    [_todo setValue:[NSNumber numberWithBool:isStepDone] forKey:@"isDone"];
    
    NSError *error = nil;
	if (![context save:&error]) {
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		abort();
	}
    if(notification != nil){
        [[UIApplication sharedApplication] cancelLocalNotification:notification];
    }
    
    [self.containingTableView reloadData];
}

- (void) changeBackgroundColor:(UIColor *) newColor{
    self.contentView.backgroundColor = newColor;
    self.backgroundColor = newColor;
}

-(void) loadUIElements
{
    if(_todo.isDone.boolValue){
        [self.manageTodoButton setTitle:@"Activate" forState:UIControlStateNormal];
        [self changeBackgroundColor:[UIColor orangeColor]];
    }
    else{
        [self.manageTodoButton setTitle:@"Complete" forState:UIControlStateNormal];
        [self changeBackgroundColor:[UIColor whiteColor]];
    }
}

- (void)initializer
{
    UIScrollView *cellScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), _height)];
    cellScrollView.contentSize = CGSizeMake(CGRectGetWidth(self.bounds) + buttonWidthDefault, _height);
    cellScrollView.delegate = self;
    cellScrollView.showsHorizontalScrollIndicator = NO;
    cellScrollView.scrollsToTop = NO;
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollViewPressed:)];
    [cellScrollView addGestureRecognizer:tapGestureRecognizer];
    
    self.cellScrollView = cellScrollView;
    
    [self loadUIElements];
    
    [self.cellScrollView addSubview:self.manageTodoButton];
    [self.cellScrollView addSubview:self.deleteTodoButton];
    
    UIView *scrollViewContentView = [[UIView alloc] initWithFrame:CGRectMake(buttonWidthDefault, 0, CGRectGetWidth(self.bounds), _height)];
    scrollViewContentView.backgroundColor = [UIColor whiteColor];
    [self.cellScrollView addSubview:scrollViewContentView];
    self.scrollViewContentView = scrollViewContentView;
    
    UIView *contentViewParent = self;
    if (![NSStringFromClass([[self.subviews objectAtIndex:0] class]) isEqualToString:kTableViewCellContentView]) {
        // iOS 7
        contentViewParent = [self.subviews objectAtIndex:0];
    }
    NSArray *cellSubviews = [contentViewParent subviews];
    [self insertSubview:cellScrollView atIndex:0];
    for (UIView *subview in cellSubviews) {
        [self.scrollViewContentView addSubview:subview];
    }
}



#pragma mark Selection

- (void)scrollViewPressed:(id)sender {
//    if(_cellState == kCellStateCenter) {
//        // Selection hack
//        if ([self.containingTableView.delegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)]){
//            NSIndexPath *cellIndexPath = [_containingTableView indexPathForCell:self];
//            [self.containingTableView.delegate tableView:_containingTableView didSelectRowAtIndexPath:cellIndexPath];
//        }
//        // Highlight hack
//        if (!self.highlighted) {
//            self.manageTodoButton.hidden = YES;
//            NSTimer *endHighlightTimer = [NSTimer scheduledTimerWithTimeInterval:0.15 target:self selector:@selector(timerEndCellHighlight:) userInfo:nil repeats:NO];
//            [[NSRunLoop currentRunLoop] addTimer:endHighlightTimer forMode:NSRunLoopCommonModes];
//            [self setHighlighted:YES];
//        }
//    } else {
//        // Scroll back to center
//        [self hideUtilityButtonsAnimated:YES];
//    }

    if(_cellState == kCellStateCenter) {
        // Selection hack
        if ([self.containingTableView.delegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)]){
            NSIndexPath *cellIndexPath = [_containingTableView indexPathForCell:self];
            [self.containingTableView.delegate tableView:_containingTableView didSelectRowAtIndexPath:cellIndexPath];
        }
        // Highlight hack
        if (!self.highlighted) {
            self.manageTodoButton.hidden = YES;
            self.deleteTodoButton.hidden = YES;
            NSTimer *endHighlightTimer = [NSTimer scheduledTimerWithTimeInterval:0.15 target:self selector:@selector(timerEndCellHighlight:) userInfo:nil repeats:NO];
            [[NSRunLoop currentRunLoop] addTimer:endHighlightTimer forMode:NSRunLoopCommonModes];
            [self setHighlighted:YES];
        }
    } else {
        // Scroll back to center
        [self hideUtilityButtonsAnimated:YES];
    }

}

- (void)timerEndCellHighlight:(id)sender {
    if (self.highlighted) {
        self.manageTodoButton.hidden = NO;
        self.deleteTodoButton.hidden = NO;
        [self setHighlighted:NO];
    }
}

//- (void)hideUtilityButtonsAnimated:(BOOL)animated {
//    [self.cellScrollView setContentOffset:CGPointMake(buttonWidthDefault, 0) animated:animated];
//    _cellState = kCellStateCenter;
//    
//    if ([_delegate respondsToSelector:@selector(swippableTableViewCell:scrollingToState:)]) {
//        [_delegate swippableTableViewCell:self scrollingToState:kCellStateCenter];
//    }
//}
#pragma mark - Overriden methods

//- (void)layoutSubviews {
//    [super layoutSubviews];
//    
//    self.cellScrollView.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds), _height);
//    self.cellScrollView.contentSize = CGSizeMake(CGRectGetWidth(self.bounds) + buttonWidthDefault, _height);
//    self.cellScrollView.contentOffset = CGPointMake(buttonWidthDefault, 0);
//    self.scrollViewContentView.frame = CGRectMake(buttonWidthDefault, 0, CGRectGetWidth(self.bounds), _height);
//}

//#pragma mark UIScrollView helpers
//
//- (void)scrollToCenter:(inout CGPoint *)targetContentOffset {
//    targetContentOffset->x = buttonWidthDefault;
//    _cellState = kCellStateCenter;
//    
//    if ([_delegate respondsToSelector:@selector(swippableTableViewCell:scrollingToState:)]) {
//        [_delegate swippableTableViewCell:self scrollingToState:kCellStateCenter];
//    }
//}
//
//- (void)scrollToLeft:(inout CGPoint *)targetContentOffset{
//    targetContentOffset->x = 0;
//    _cellState = kCellStateLeft;
//    
//    if ([_delegate respondsToSelector:@selector(swippableTableViewCell:scrollingToState:)]) {
//        [_delegate swippableTableViewCell:self scrollingToState:kCellStateLeft];
//    }
//}
//
//#pragma mark UIScrollViewDelegate
//
//- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
//    switch (_cellState) {
//        case kCellStateCenter:
//            if (velocity.x >= 0.5f) {
//            } else if (velocity.x <= -0.5f) {
//                [self scrollToLeft:targetContentOffset];
//            } else {
//                CGFloat leftThreshold = buttonWidthDefault / 2;
//                if (targetContentOffset->x < leftThreshold){
//                    [self scrollToLeft:targetContentOffset];
//                }
//                else{
//                    [self scrollToCenter:targetContentOffset];
//                }
//            }
//            break;
//        case kCellStateLeft:
//            if (velocity.x >= 0.5f) {
//                [self scrollToCenter:targetContentOffset];
//            } else if (velocity.x <= -0.5f) {
//            } else {
//                if (targetContentOffset->x >= buttonWidthDefault){
//                }
//                else if (targetContentOffset->x > buttonWidthDefault / 2)
//                    [self scrollToCenter:targetContentOffset];
//                else
//                    [self scrollToLeft:targetContentOffset];
//            }
//            break;
//        case kCellStateRight:
//            if (velocity.x >= 0.5f) {
//            } else if (velocity.x <= -0.5f) {
//                [self scrollToCenter:targetContentOffset];
//            } else {
//                if (targetContentOffset->x <= buttonWidthDefault / 2)
//                    [self scrollToLeft:targetContentOffset];
//                else if (targetContentOffset->x < buttonWidthDefault)
//                    [self scrollToCenter:targetContentOffset];
//            }
//            break;
//        default:
//            break;
//    }
//}
//
//@end


- (void)hideUtilityButtonsAnimated:(BOOL)animated
{
    [self.cellScrollView setContentOffset:CGPointMake(buttonWidthDefault, 0) animated:animated];
    _cellState = kCellStateCenter;
    
    if ([_delegate respondsToSelector:@selector(swippableTableViewCell:scrollingToState:)]) {
        [_delegate swippableTableViewCell:self scrollingToState:kCellStateCenter];
    }
}


#pragma mark - Overriden methods

- (void)layoutSubviews
{
    [super layoutSubviews];

    
    
//    - (void)layoutSubviews {
//        [super layoutSubviews];
//        
//        self.cellScrollView.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds), _height);
//        self.cellScrollView.contentSize = CGSizeMake(CGRectGetWidth(self.bounds) + buttonWidthDefault, _height);
//        self.cellScrollView.contentOffset = CGPointMake(buttonWidthDefault, 0);
//        self.scrollViewContentView.frame = CGRectMake(buttonWidthDefault, 0, CGRectGetWidth(self.bounds), _height);
//    }
    
    self.cellScrollView.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds), _height);
    self.cellScrollView.contentSize = CGSizeMake(CGRectGetWidth(self.bounds) + [self utilityButtonsPadding], _height);
    self.cellScrollView.contentOffset = CGPointMake(buttonWidthDefault, 0);
//    self.scrollViewButtonViewLeft.frame = CGRectMake([self leftUtilityButtonsWidth], 0, [self leftUtilityButtonsWidth], _height);
//    self.scrollViewButtonViewRight.frame = CGRectMake(CGRectGetWidth(self.bounds), 0, [self rightUtilityButtonsWidth], _height);
    self.scrollViewContentView.frame = CGRectMake(buttonWidthDefault, 0, CGRectGetWidth(self.bounds), _height);
}

#pragma mark - Setup helpers



- (CGFloat)utilityButtonsPadding {
    return (2 * buttonWidthDefault);
}

#pragma mark UIScrollView helpers

- (void)scrollToRight:(inout CGPoint *)targetContentOffset{
    targetContentOffset->x = [self utilityButtonsPadding];
    _cellState = kCellStateRight;
    
    if ([_delegate respondsToSelector:@selector(swippableTableViewCell:scrollingToState:)]) {
        [_delegate swippableTableViewCell:self scrollingToState:kCellStateRight];
    }
}

- (void)scrollToCenter:(inout CGPoint *)targetContentOffset {
    targetContentOffset->x = buttonWidthDefault;
    _cellState = kCellStateCenter;
    
    if ([_delegate respondsToSelector:@selector(swippableTableViewCell:scrollingToState:)]) {
        [_delegate swippableTableViewCell:self scrollingToState:kCellStateCenter];
    }
}

- (void)scrollToLeft:(inout CGPoint *)targetContentOffset{
    targetContentOffset->x = 0;
    _cellState = kCellStateLeft;
    
    if ([_delegate respondsToSelector:@selector(swippableTableViewCell:scrollingToState:)]) {
        [_delegate swippableTableViewCell:self scrollingToState:kCellStateLeft];
    }
}

#pragma mark UIScrollViewDelegate

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    switch (_cellState) {
        case kCellStateCenter:
            if (velocity.x >= 0.5f) {
                [self scrollToRight:targetContentOffset];
            } else if (velocity.x <= -0.5f) {
                [self scrollToLeft:targetContentOffset];
            } else {
                CGFloat rightThreshold = buttonWidthDefault - (buttonWidthDefault / 2);
                CGFloat leftThreshold = buttonWidthDefault / 2;
                if (targetContentOffset->x > rightThreshold)
                    [self scrollToRight:targetContentOffset];
                else if (targetContentOffset->x < leftThreshold)
                    [self scrollToLeft:targetContentOffset];
                else
                    [self scrollToCenter:targetContentOffset];
            }
            break;
        case kCellStateLeft:
            if (velocity.x >= 0.5f) {
                [self scrollToCenter:targetContentOffset];
            } else if (velocity.x <= -0.5f) {
                // No-op
            } else {
                if (targetContentOffset->x >= ([self utilityButtonsPadding] - buttonWidthDefault / 2))
                    [self scrollToRight:targetContentOffset];
                else if (targetContentOffset->x > buttonWidthDefault / 2)
                    [self scrollToCenter:targetContentOffset];
                else
                    [self scrollToLeft:targetContentOffset];
            }
            break;
        case kCellStateRight:
            if (velocity.x >= 0.5f) {
                // No-op
            } else if (velocity.x <= -0.5f) {
                [self scrollToCenter:targetContentOffset];
            } else {
                if (targetContentOffset->x <= buttonWidthDefault / 2)
                    [self scrollToLeft:targetContentOffset];
                else if (targetContentOffset->x < ([self utilityButtonsPadding] - buttonWidthDefault / 2))
                    [self scrollToCenter:targetContentOffset];
                else
                    [self scrollToRight:targetContentOffset];
            }
            break;
        default:
            break;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.x > buttonWidthDefault) {
        // Expose the right button view
        self.deleteTodoButton.frame = CGRectMake(scrollView.contentOffset.x + (CGRectGetWidth(self.bounds) - buttonWidthDefault), 0.0f, buttonWidthDefault, _height);
    } else {
        // Expose the left button view
        self.manageTodoButton.frame = CGRectMake(scrollView.contentOffset.x, 0.0f, buttonWidthDefault, _height);
    }
}

@end
