//
//  TodoTableViewCell.m
//  TodoOrganizer
//
//  Created by Apple on 11/15/13.
//  Copyright (c) 2013 Some. All rights reserved.
//

#import "TodoTableViewCell.h"

#define buttonWidthDefault 90
#define cellOffset 20

static NSString * const kTableViewCellContentView = @"UITableViewCellContentView";

@interface TodoTableViewCell () <UIScrollViewDelegate> {
    TodoCellState _cellState;
    CGFloat additionalRightPadding;
    Todo* _todo;
}

@property (nonatomic, weak) UIScrollView *cellScrollView;

@property (nonatomic, strong) UIButton *completeTodoButton;

@property (nonatomic) CGFloat height;

// Views that live in the scroll view
@property (nonatomic, weak) UIView *scrollViewContentView;

@property (nonatomic, weak) UITableView *containingTableView;

@end

@implementation TodoTableViewCell

#pragma mark Initializers

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier containingTableView:(UITableView *)containingTableView currentTodo: (Todo *)todo
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _todo = todo;
        self.completeTodoButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, buttonWidthDefault, self.bounds.size.height)];
        self.completeTodoButton.backgroundColor = [UIColor greenColor];
        [self.completeTodoButton addTarget:self action:@selector(completeTodo) forControlEvents:UIControlEventTouchDown];

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
        
        //self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    return self;
}


- (void) completeTodo{
    NSManagedObjectContext *context = [_todo managedObjectContext];
    BOOL isStepDone = !_todo.isDone.boolValue;
    
    [_todo setValue:[NSNumber numberWithBool:isStepDone] forKey:@"isDone"];
    
    NSError *error = nil;
	if (![context save:&error]) {
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		abort();
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
        [self.completeTodoButton setTitle:@"Activate" forState:UIControlStateNormal];
        [self changeBackgroundColor:[UIColor orangeColor]];
    }
    else{
        [self.completeTodoButton setTitle:@"Complete" forState:UIControlStateNormal];
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
    
    [self.cellScrollView addSubview:self.completeTodoButton];
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
- (void)scrollViewPressed:(id)sender {
    if(_cellState == kCellStateCenter) {
        // Selection hack
        if ([self.containingTableView.delegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)]){
            NSIndexPath *cellIndexPath = [_containingTableView indexPathForCell:self];
            [self.containingTableView.delegate tableView:_containingTableView didSelectRowAtIndexPath:cellIndexPath];
        }
        // Highlight hack
        if (!self.highlighted) {
            self.completeTodoButton.hidden = YES;
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
        self.completeTodoButton.hidden = NO;
        [self setHighlighted:NO];
    }
}

- (void)hideUtilityButtonsAnimated:(BOOL)animated {
    [self.cellScrollView setContentOffset:CGPointMake(buttonWidthDefault, 0) animated:animated];
    _cellState = kCellStateCenter;
    
    if ([_delegate respondsToSelector:@selector(swippableTableViewCell:scrollingToState:)]) {
        [_delegate swippableTableViewCell:self scrollingToState:kCellStateCenter];
    }
}
#pragma mark - Overriden methods

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.cellScrollView.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds), _height);
    self.cellScrollView.contentSize = CGSizeMake(CGRectGetWidth(self.bounds) + buttonWidthDefault, _height);
    self.cellScrollView.contentOffset = CGPointMake(buttonWidthDefault, 0);
    self.scrollViewContentView.frame = CGRectMake(buttonWidthDefault, 0, CGRectGetWidth(self.bounds), _height);
}

#pragma mark UIScrollView helpers

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
            } else if (velocity.x <= -0.5f) {
                [self scrollToLeft:targetContentOffset];
            } else {
                CGFloat leftThreshold = buttonWidthDefault / 2;
                if (targetContentOffset->x < leftThreshold){
                    [self scrollToLeft:targetContentOffset];
                }
                else{
                    [self scrollToCenter:targetContentOffset];
                }
            }
            break;
        case kCellStateLeft:
            if (velocity.x >= 0.5f) {
                [self scrollToCenter:targetContentOffset];
            } else if (velocity.x <= -0.5f) {
            } else {
                if (targetContentOffset->x >= buttonWidthDefault){
                }
                else if (targetContentOffset->x > buttonWidthDefault / 2)
                    [self scrollToCenter:targetContentOffset];
                else
                    [self scrollToLeft:targetContentOffset];
            }
            break;
        case kCellStateRight:
            if (velocity.x >= 0.5f) {
            } else if (velocity.x <= -0.5f) {
                [self scrollToCenter:targetContentOffset];
            } else {
                if (targetContentOffset->x <= buttonWidthDefault / 2)
                    [self scrollToLeft:targetContentOffset];
                else if (targetContentOffset->x < buttonWidthDefault)
                    [self scrollToCenter:targetContentOffset];
            }
            break;
        default:
            break;
    }
}

@end
