//
//  DetailsViewController.m
//  TodoOrganizer
//
//  Created by Apple on 11/7/13.
//  Copyright (c) 2013 Some. All rights reserved.
//

#import "DetailsViewController.h"
#import "StepDetailsViewController.h"

@interface DetailsViewController ()

//@property (strong, nonatomic) UITextField *deadlineTextField;

@end

@implementation DetailsViewController

@synthesize todo;
@synthesize steps;

- (void)viewDidLoad
{
    [super viewDidLoad];

//    self.deadlineTextField = [[UITextField alloc] initWithFrame:CGRectMake(67, 134, 244, 30)];
//    
//    [self.deadlineTextField.layer setBorderColor:[[[UIColor grayColor] colorWithAlphaComponent:0.5] CGColor]];
//    [self.deadlineTextField.layer setBorderWidth:1.0];
//    
//    //The rounded corner part, where you specify your view's corner radius:
//    self.deadlineTextField.layer.cornerRadius = 5;
//    self.deadlineTextField.clipsToBounds = YES;
    
    
    self.todoDetailsViewController = [[TodoDetailsViewController alloc] init];
    //[self.todoDetailsViewController.view addSubview:self.deadlineTextField];
    self.tableView.tableHeaderView = self.todoDetailsViewController.view;
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self.tableView registerClass: [UITableViewCell class] forCellReuseIdentifier:@"AddStepCell"];
    [self configureTextFields:NO];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.todoDetailsViewController.deadlineDatePicker.hidden = YES;
	self.navigationItem.title = todo.title;
    self.todoDetailsViewController.titleTextField.text = todo.title;
    self.todoDetailsViewController.placeTextField.text = todo.place;
    [self updateDeadlineTextField];
    
    if(todo.deadline != nil){
        self.todoDetailsViewController.deadlineDatePicker.date = todo.deadline;
    }
    self.todoDetailsViewController.descriptionTextField.text = todo.todoDescription;

	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"text" ascending:YES];
	NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:&sortDescriptor count:1];
	
	NSMutableArray *sortedSteps = [[NSMutableArray alloc] initWithArray:[todo.steps allObjects]];
	[sortedSteps sortUsingDescriptors:sortDescriptors];
	self.steps = sortedSteps;
    
    [self.tableView reloadData];
}

- (void)viewDidUnload
{
	[super viewDidUnload];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger stepsCount = steps.count;

    return stepsCount + 1;
}

- (void) configureTextFields:(BOOL) editing
{
    self.todoDetailsViewController.titleTextField.enabled = editing;
	self.todoDetailsViewController.descriptionTextField.enabled = editing;
	self.todoDetailsViewController.placeTextField.enabled = editing;
    self.todoDetailsViewController.deadlineTextField.enabled = editing;
    [self.todoDetailsViewController.deadlineDatePicker setUserInteractionEnabled:editing];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    
    [self configureTextFields:editing];
	   
	[self.navigationItem setHidesBackButton:editing animated:YES];

	if (!editing) {
        [self updateTodoFields];

		NSManagedObjectContext *context = todo.managedObjectContext;
        
        NSError *error = nil;
		if (![context save:&error]) {
			NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
			abort();
		}
        
        self.todoDetailsViewController.deadlineTextField.hidden = NO;
        self.todoDetailsViewController.deadlineDatePicker.hidden = YES;
        [self updateDeadlineTextField];
    }
    else{
        self.todoDetailsViewController.deadlineTextField.hidden = YES;
        self.todoDetailsViewController.deadlineDatePicker.hidden = NO;
    }
}

- (void)updateDeadlineTextField
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd-MM-yyyy hh:mm"];
    
    NSString *stringFromDate = [formatter stringFromDate:todo.deadline];
    self.todoDetailsViewController.deadlineTextField.text = stringFromDate;
}

- (void)updateTodoFields
{
    todo.title = self.todoDetailsViewController.titleTextField.text;
    todo.place = self.todoDetailsViewController.placeTextField.text;
    todo.todoDescription = self.todoDetailsViewController.descriptionTextField.text;
    todo.deadline = self.todoDetailsViewController.deadlineDatePicker.date;
    self.title = todo.title;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    if(indexPath.row < steps.count){
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
    
        Step *step = [steps objectAtIndex:indexPath.row];
        if(step.isDone){
            cell.backgroundColor = [UIColor greenColor];
        }
        cell.textLabel.text = step.text;
    } else{
        static NSString *AddStepCellIdentifier = @"AddStepCell";
        
        cell = [tableView dequeueReusableCellWithIdentifier:AddStepCellIdentifier];
                cell.textLabel.text = @"Add step";
    }
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger stepsCount = steps.count;
    
    if(indexPath.row == stepsCount)
    {
        return NO;
    }

    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        Step *step = [steps objectAtIndex:indexPath.row];
        [todo removeStepsObject:step];
        [steps removeObject:step];
        
        NSManagedObjectContext *context = todo.managedObjectContext;
        [context deleteObject:step];
        
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationTop];    }
    }

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Step *selectedStep = nil;

    NSInteger stepsCount = steps.count;

    if(indexPath.row < stepsCount)
    {
        selectedStep = [steps objectAtIndex:indexPath.row];
    }
    
    [self loadStepDetailsView:selectedStep];
}

- (void)loadStepDetailsView:(Step*) selectedStep
{
    StepDetailsViewController *stepDetailViewController = [[StepDetailsViewController alloc] init];
    
    stepDetailViewController.todo = todo;
    stepDetailViewController.step = selectedStep;
    
    [self.navigationController pushViewController:stepDetailViewController animated:YES];
}

@end
