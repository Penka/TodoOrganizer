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

@end

@implementation DetailsViewController

@synthesize todo;
@synthesize steps;

@synthesize tableHeaderView;
@synthesize titleTextField, descriptionTextField, placeTextField, deadlineDatePicker, deadlineTextField;


- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self.tableView registerClass: [UITableViewCell class] forCellReuseIdentifier:@"AddStepCell"];
    
    deadlineTextField.enabled = NO;
    
    if (tableHeaderView == nil) {
        NSArray* view = [[NSBundle mainBundle] loadNibNamed:@"DetailsHeaderView" owner:self options:nil];
        tableHeaderView = [view objectAtIndex:0];
        self.tableView.tableHeaderView = tableHeaderView;
        
        [self configureTextFields:NO];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    deadlineDatePicker.hidden = YES;
	
	self.navigationItem.title = todo.title;
    titleTextField.text = todo.title;
    placeTextField.text = todo.place;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd-MM-yyyy hh:mm"];
    
    NSString *stringFromDate = [formatter stringFromDate:todo.deadline];
    
    self.deadlineTextField.text = stringFromDate;
    
    if(todo.deadline != nil){
        deadlineDatePicker.date = todo.deadline;
    }
    descriptionTextField.text = todo.todoDescription;

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
    self.tableHeaderView = nil;
	self.titleTextField = nil;
	self.descriptionTextField = nil;
	self.placeTextField = nil;
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
    titleTextField.enabled = editing;
	descriptionTextField.enabled = editing;
	placeTextField.enabled = editing;
    [deadlineDatePicker setUserInteractionEnabled:editing];
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
        
        [self.tableView reloadData];
        deadlineTextField.hidden = NO;
        deadlineDatePicker.hidden = YES;
	} else {
        deadlineTextField.hidden = YES;
        deadlineDatePicker.hidden = NO;
    }
}

- (void)updateTodoFields{
    todo.title = titleTextField.text;
    todo.place = placeTextField.text;
    todo.todoDescription = descriptionTextField.text;
    todo.deadline = deadlineDatePicker.date;
    self.title = todo.title;

}

//- (void) getTodoDetailsData{
//    todo.title = titleTextField.text;
//    todo.todoDescription = descriptionTextField.text;
//    todo.place = placeTextField.text;
//
//}

//- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
//	if (textField == titleTextField) {
//		todo.title = titleTextField.text;
//	}
//	else if (textField == descriptionTextField) {
//		todo.todoDescription = descriptionTextField.text;
//	}
//    else if (textField == placeTextField) {
//		todo.place = placeTextField.text;
//	}
////    else if (textField == deadlineTextField) {
////		todo.deadline = deadlineTextField.text;
////	}
//    
//    return YES;
//}
//
//- (BOOL)textFieldShouldReturn:(UITextField *)textField {
//	[textField resignFirstResponder];
//	return YES;
//}

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

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Step *selectedStep = nil;

    NSInteger stepsCount = steps.count;

    NSLog(@"%d", indexPath.row);
    
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
