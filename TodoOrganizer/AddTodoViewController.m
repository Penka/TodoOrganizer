//
//  AddTodoViewController.m
//  TodoOrganizer
//
//  Created by Apple on 11/5/13.
//  Copyright (c) 2013 Some. All rights reserved.
//

#import "AddTodoViewController.h"

@interface AddTodoViewController ()

@property (strong, nonatomic) UILabel *someLabel;

@end

@implementation AddTodoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.someLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 100, 200, 150)];
    self.someLabel.text = @"Adding logic";
    self.someLabel.backgroundColor = [UIColor blueColor];
    
    [self.view addSubview:self.someLabel];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
