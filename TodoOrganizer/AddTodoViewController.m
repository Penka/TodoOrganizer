//
//  AddTodoViewController.m
//  TodoOrganizer
//
//  Created by Apple on 11/5/13.
//  Copyright (c) 2013 Some. All rights reserved.
//

#import "AddTodoViewController.h"
#import "Todo.h"
#import "DetailsViewController.h"

@interface AddTodoViewController ()

@property (nonatomic, strong) TodoDetailsViewController *todoDetailsViewController;

@end

@implementation AddTodoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.todoDetailsViewController = [[TodoDetailsViewController alloc] init];
    
    [self.view addSubview:self.todoDetailsViewController.view];
    
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveTodo:)];

    saveButton.title = @"Save";
    
    
    self.navigationItem.rightBarButtonItem = saveButton;
    
}

- (void)saveTodo:(id)sender
{
    NSManagedObjectContext *context = self.managedObjectContext;

    Todo *todo = [NSEntityDescription insertNewObjectForEntityForName:@"Todo" inManagedObjectContext:context];
	
    todo.title = self.todoDetailsViewController.titleTextField.text;
    todo.place = self.todoDetailsViewController.placeTextField.text;
    todo.todoDescription = self.todoDetailsViewController.descriptionTextField.text;
    todo.deadline = self.todoDetailsViewController.deadlineDatePicker.date;
    
    NSError *error = nil;
	if (![context save:&error]) {
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		abort();
	}
	
    DetailsViewController *detailsViewController = [[DetailsViewController alloc] init];
    detailsViewController.todo = todo;
    
    [self.navigationController pushViewController:detailsViewController animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
