//
//  StepDetailsViewController.m
//  TodoOrganizer
//
//  Created by Apple on 11/8/13.
//  Copyright (c) 2013 Some. All rights reserved.
//

#import "StepDetailsViewController.h"

@interface StepDetailsViewController ()

@end

@implementation StepDetailsViewController

@synthesize todo, step;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tableView registerClass: [UITableViewCell class] forCellReuseIdentifier:@"StepCellIdentifier"];
    
    UINavigationItem *navigationItem = self.navigationItem;
    navigationItem.title = @"Step";
    
    self.tableView.allowsSelection = NO;
    self.tableView.allowsSelectionDuringEditing = NO;
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelStep:)];
    self.navigationItem.leftBarButtonItem = cancelButton;
    //[cancelButton release];
    
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveStep:)];
    self.navigationItem.rightBarButtonItem = saveButton;
        //[saveButton release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)cancelStep:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(UILabel *) configureCompleteLabel
{
    UILabel *completeLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 110, 30)];

    completeLabel.textColor = [UIColor blackColor];
    completeLabel.backgroundColor = [UIColor whiteColor];
    completeLabel.text = @"Complete:";
    
    return completeLabel;
}

-(void) configureTextStepCell
{
    stepTextTextField = [[UITextField alloc] initWithFrame:CGRectMake(30, 10, 210, 30)];
    stepTextTextField.adjustsFontSizeToFitWidth = YES;
    stepTextTextField.textColor = [UIColor blackColor];
    stepTextTextField.backgroundColor = [UIColor whiteColor];
    stepTextTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    stepTextTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    stepTextTextField.tag = 0;
    stepTextTextField.placeholder = @"Step Title";
    
    stepTextTextField.clearButtonMode = UITextFieldViewModeNever;
    [stepTextTextField setEnabled: YES];
    stepTextTextField.text = step.text;
}

-(void) configureIsDoneStepCell
{
    isDoneSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(200, 10, 0, 0)];
    [isDoneSwitch addTarget:self action:@selector(switchToggled:) forControlEvents: UIControlEventTouchUpInside];
    [isDoneSwitch setOn:step.isDone.boolValue animated:YES];
}

- (void) switchToggled:(id)sender {
    if ([isDoneSwitch isOn]) {
        [isDoneSwitch setOn:YES animated:YES];
    } else {
        [isDoneSwitch setOn:NO animated:YES];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"StepCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (indexPath.row == 0) {
        [self configureTextStepCell];
        
        [cell.contentView addSubview:stepTextTextField];
        
    }
    else if (indexPath.row == 1) {
        [self configureIsDoneStepCell];
        
        [cell.contentView addSubview:isDoneSwitch];
        [cell.contentView addSubview:[self configureCompleteLabel]];
    }
    
    return cell;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)saveStep:(id)sender
{
    NSManagedObjectContext *context = [todo managedObjectContext];
    
    if (!step) {
        self.step = [NSEntityDescription insertNewObjectForEntityForName:@"Step" inManagedObjectContext:context];
        [todo addStepsObject:step];
    }
	
    step.text = stepTextTextField.text;
    
    BOOL isStepDone = [isDoneSwitch isOn];

    [self.step setValue:[NSNumber numberWithBool:isStepDone] forKey:@"isDone"];
    
    NSError *error = nil;
	if (![context save:&error]) {
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		abort();
	}
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
