//
//  TodoDetailsViewController.m
//  TodoOrganizer
//
//  Created by Apple on 11/11/13.
//  Copyright (c) 2013 Some. All rights reserved.
//

#import "TodoDetailsViewController.h"
#import "Todo.h"

@interface TodoDetailsViewController ()

@end

@implementation TodoDetailsViewController

@synthesize titleTextField, placeTextField, descriptionTextField, deadlineDatePicker, deadlineTextField;


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)isDataValid{
    if([self.titleTextField.text length] > 0){
        return YES;
    }
    return NO;
}

@end
