//
//  DetailsViewController.m
//  TodoOrganizer
//
//  Created by Apple on 11/7/13.
//  Copyright (c) 2013 Some. All rights reserved.
//

#import "DetailsViewController.h"

@interface DetailsViewController ()

@end

@implementation DetailsViewController

@synthesize todo;
@synthesize steps;

@synthesize tableHeaderView;
@synthesize titleTextField, descriptionTextField, placeTextField, deadlineTextField;


- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    if (tableHeaderView == nil) {
        NSArray* view = [[NSBundle mainBundle] loadNibNamed:@"DetailsHeaderView" owner:self options:nil];
        tableHeaderView = [view objectAtIndex:0];
        self.tableView.tableHeaderView = tableHeaderView;
        self.tableView.allowsSelectionDuringEditing = YES;
        self.titleTextField.enabled = NO;
        self.placeTextField.enabled = NO;
        self.descriptionTextField.enabled = NO;
        self.deadlineTextField.enabled = NO;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
	
	self.navigationItem.title = todo.title;
    titleTextField.text = todo.title;
    placeTextField.text = todo.place;
    //deadlineTextField.text = todo.deadline;
    descriptionTextField.text = todo.todoDescription;

	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"text" ascending:YES];
	NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:&sortDescriptor count:1];
	
	NSMutableArray *sortedSteps = [[NSMutableArray alloc] initWithArray:[todo.steps allObjects]];
	[sortedSteps sortUsingDescriptors:sortDescriptors];
	self.steps = sortedSteps;
    
    [self.tableView reloadData];
}


- (void)viewDidUnload {
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
//    if (self.editing) {
//        return stepsCount + 1;
//    }
    
    return stepsCount;
}


- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    
    [super setEditing:editing animated:animated];
    
	titleTextField.enabled = editing;
	descriptionTextField.enabled = editing;
	placeTextField.enabled = editing;
	deadlineTextField.enabled = editing;
    
	[self.navigationItem setHidesBackButton:editing animated:YES];
	
    
	[self.tableView beginUpdates];
	
    NSUInteger stepsCount = [todo.steps count];
    
    NSArray *stepsInsertIndexPath = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:stepsCount inSection:0]];
    
//    if (editing) {
//        [self.tableView insertRowsAtIndexPaths:stepsInsertIndexPath withRowAnimation:UITableViewRowAnimationTop];
//		descriptionTextField.placeholder = @"Overview";
//	} else {
//        [self.tableView deleteRowsAtIndexPaths:stepsInsertIndexPath withRowAnimation:UITableViewRowAnimationTop];
//		descriptionTextField.placeholder = @"";
//    }
    
    [self.tableView endUpdates];
	
	if (!editing) {
		NSManagedObjectContext *context = todo.managedObjectContext;
		NSError *error = nil;
		if (![context save:&error]) {
			NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
			abort();
		}
	}
}



- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
	
	if (textField == titleTextField) {
		todo.title = titleTextField.text;
		self.navigationItem.title = todo.title;
	}
	else if (textField == descriptionTextField) {
		todo.todoDescription = descriptionTextField.text;
	}
    else if (textField == placeTextField) {
		todo.place = placeTextField.text;
	}
//    else if (textField == deadlineTextField) {
//		todo.deadline = deadlineTextField.text;
//	}
    
    return YES;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[textField resignFirstResponder];
	return YES;
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
        cell.textLabel.text = step.text;
    }
    else{
        static NSString *AddStepCellIdentifier = @"AddStepCell";
        
        cell = [tableView dequeueReusableCellWithIdentifier:AddStepCellIdentifier];
        if (cell == nil) {
            // Create a cell to display "Add Ingredient".
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:AddStepCellIdentifier];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        cell.textLabel.text = @"Add step";
    }
    
    return cell;
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

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

/*
#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here, for example:
    // Create the next view controller.
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];

    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
}
 
 */

@end
