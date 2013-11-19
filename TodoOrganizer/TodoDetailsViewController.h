//
//  TodoDetailsViewController.h
//  TodoOrganizer
//
//  Created by Apple on 11/11/13.
//  Copyright (c) 2013 Some. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TodoDetailsViewController : UIViewController

@property (nonatomic, retain) IBOutlet UITextField *titleTextField;
@property (nonatomic, retain) IBOutlet UITextField *placeTextField;
@property (nonatomic, retain) IBOutlet UITextField *descriptionTextField;
@property (nonatomic, retain) IBOutlet UIDatePicker *deadlineDatePicker;
@property (nonatomic, retain) IBOutlet UIButton *viewPlaceButton;

@property (nonatomic, retain) IBOutlet UITextField *deadlineTextField;

- (BOOL) isDataValid;
@end
