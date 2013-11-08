//
//  TodoCell.m
//  TodoOrganizer
//
//  Created by Apple on 11/7/13.
//  Copyright (c) 2013 Some. All rights reserved.
//

#import "TodoCell.h"

@interface TodoCell (SubviewFrames)
- (CGRect) _titleLabelFrame;
- (CGRect) _descriptionLabelFrame;
@end

@implementation TodoCell

@synthesize todo, titleLabel, descriptionLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
	if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        descriptionLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [descriptionLabel setFont:[UIFont systemFontOfSize:12.0]];
        [descriptionLabel setTextColor:[UIColor darkGrayColor]];
        [descriptionLabel setHighlightedTextColor:[UIColor whiteColor]];
        //descriptionLabel.text = todo.todoDescription;
        [self.contentView addSubview:descriptionLabel];
      
        titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [titleLabel setFont:[UIFont boldSystemFontOfSize:14.0]];
        [titleLabel setTextColor:[UIColor blackColor]];
        [titleLabel setHighlightedTextColor:[UIColor whiteColor]];
        //titleLabel.text = todo.title;
        [self.contentView addSubview:titleLabel];
    }
    
    return self;
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
	
    [titleLabel setFrame:[self _nameLabelFrame]];
    [descriptionLabel setFrame:[self _descriptionLabelFrame]];
}


#define EDITING_INSET       10.0
#define TEXT_LEFT_MARGIN    8.0
#define TEXT_RIGHT_MARGIN   5.0
#define PREP_TIME_WIDTH     80.0

/*
 Return the frame of the various subviews -- these are dependent on the editing state of the cell.
 */

- (CGRect)_nameLabelFrame {
    return CGRectMake(EDITING_INSET + TEXT_LEFT_MARGIN, 4.0, self.contentView.bounds.size.width - EDITING_INSET - TEXT_LEFT_MARGIN, 16.0);
}

- (CGRect)_descriptionLabelFrame {
    if (self.editing) {
        return CGRectMake(EDITING_INSET + TEXT_LEFT_MARGIN, 22.0, self.contentView.bounds.size.width - EDITING_INSET - TEXT_LEFT_MARGIN, 16.0);
    }
	else {
        return CGRectMake(TEXT_LEFT_MARGIN, 22.0, self.contentView.bounds.size.width - TEXT_LEFT_MARGIN, 16.0);
    }
}

#pragma mark -
#pragma mark Memory management

- (void)dealloc {
//    [todo release];
//    [titleLabel release];
//    [descriptionLabel release];
    //[super dealloc];
}

-(void) setTodo:(Todo *)currentTodo{
    titleLabel.text = currentTodo.title;
    descriptionLabel.text = currentTodo.todoDescription;
}

@end
