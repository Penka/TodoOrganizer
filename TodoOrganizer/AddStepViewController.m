//
//  AddStepViewController.m
//  TodoOrganizer
//
//  Created by Apple on 11/6/13.
//  Copyright (c) 2013 Some. All rights reserved.
//

#import "AddStepViewController.h"

@interface AddStepViewController ()

@property (nonatomic, strong) UITextField *textFieldStepText;


-(void) addTodoStep;

@end

@implementation AddStepViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] init];
    addButton.action = @selector(addTodoStep);
    addButton.target = self;
    addButton.title = @"Add";

    self.navigationItem.rightBarButtonItem = addButton;
    
    self.view.backgroundColor = [UIColor whiteColor];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, 100, 120)];
    label.text = self.todo.title;
    label.backgroundColor = [UIColor yellowColor];
    
    
    [self.view addSubview:label];
    
    self.textFieldStepText = [[UITextField alloc] initWithFrame:CGRectMake(0, 270, 100, 100)];
    self.textFieldStepText.backgroundColor = [UIColor blueColor];

    [self.view addSubview:self.textFieldStepText];

	// Do any additional setup after loading the view.
}

-(void) addTodoStep{
    NSManagedObjectContext *context = self.managedObjectContext;
    
    NSManagedObject *newStep = [NSEntityDescription
                                    insertNewObjectForEntityForName:@"Step"
                                    inManagedObjectContext:context];
    NSString *text = self.textFieldStepText.text;
        
    [newStep setValue:text forKey:@"text"];
    [newStep setValue:self.todo forKey:@"todo"];
        
    NSError *error;
    if (![context save:&error]) {
            NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
    
    [[self navigationController] popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
