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
    
    self.navigationController.navigationBar.translucent = NO;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveTodo:)];

    saveButton.title = @"Save";
    
    self.navigationItem.rightBarButtonItem = saveButton;
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)];
    self.navigationItem.leftBarButtonItem = cancelButton;

    self.todoDetailsViewController = [[TodoDetailsViewController alloc] init];
    [self.view addSubview:self.todoDetailsViewController.view];
    [self.todoDetailsViewController.deadlineTextField setHidden:YES];
    self.todoDetailsViewController.viewPlaceButton.hidden = YES;
    self.todoDetailsViewController.fbShareButton.hidden = YES;
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)saveTodo:(id)sender
{
    if(![self.todoDetailsViewController isDataValid]){
        UIAlertView *ErrorAlert = [[UIAlertView alloc] initWithTitle:@"Error!"
                                                             message:@"Todo title is mandatory." delegate:nil
                                                   cancelButtonTitle:@"OK"
                                                   otherButtonTitles:nil, nil];
        [ErrorAlert show];
        //[ErrorAlert release];
    }
    else{
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
}

- (void)cancel:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
