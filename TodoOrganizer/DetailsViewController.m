//
//  DetailsViewController.m
//  TodoOrganizer
//
//  Created by Apple on 11/7/13.
//  Copyright (c) 2013 Some. All rights reserved.
//

#import "DetailsViewController.h"
#import "StepDetailsViewController.h"
#import "PlaceViewController.h"
#import "TodosTableViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import "BaseNotificationViewController.h"

@interface DetailsViewController()

@property (strong, nonatomic) NSMutableDictionary *postParams;

@end

@implementation DetailsViewController



@synthesize todo;
@synthesize steps;

- (void) navigateBack
{
    TodosTableViewController *todosViewController = [[TodosTableViewController alloc] init];
    todosViewController.managedObjectContext = [self.todo managedObjectContext];
    todosViewController.title = @"My todos";
    
    [self.navigationController pushViewController:todosViewController animated:YES];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
   
    
    self.postParams = [@{
                         @"link" : @"https://developers.facebook.com/ios",
                         @"picture" : @"https://developers.facebook.com/attachment/iossdk_logo.png",
                         @"name" : @"Facebook SDK for iOS",
                         @"caption" : @"Build great social apps and get more installs.",
                         @"description" : @"The Facebook SDK for iOS makes it easier and faster to develop Facebook integrated iOS apps."
                         } mutableCopy];


    self.tableView.allowsSelectionDuringEditing = YES;
    self.navigationItem.rightBarButtonItem = self.editButtonItem;

    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"My todos" style:UIBarButtonItemStylePlain target:self action:@selector(navigateBack)];
    
    [self.tableView registerClass: [UITableViewCell class] forCellReuseIdentifier:@"AddStepCell"];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.todoDetailsViewController = [[TodoDetailsViewController alloc] init];
    self.tableView.tableHeaderView = self.todoDetailsViewController.view;
    
    [self configureTextFields:NO];
    
    [self.todoDetailsViewController.viewPlaceButton addTarget:self action:@selector(viewPlaceInMaps) forControlEvents:UIControlEventTouchDown];
    [self.todoDetailsViewController.fbShareButton addTarget:self action:@selector(shareToFacebookWall) forControlEvents:UIControlEventTouchDown];


    self.todoDetailsViewController.deadlineDatePicker.hidden = YES;
	self.navigationItem.title = todo.title;
    self.todoDetailsViewController.titleTextField.text = todo.title;
    self.todoDetailsViewController.placeTextField.text = todo.place;
    [self handleViewPlaceButtonVisibility];
    [self updateDeadlineTextField];
    
    if(todo.deadline != nil){
        self.todoDetailsViewController.deadlineDatePicker.date = todo.deadline;
    }
    
    self.todoDetailsViewController.descriptionTextField.text = todo.todoDescription;

	self.steps = [[NSMutableArray alloc] initWithArray:[todo.steps allObjects]];;
    
    [self.tableView reloadData];
    
}

- (void) handleViewPlaceButtonVisibility
{
    if([self.todo.place length] <= 0){
        self.todoDetailsViewController.viewPlaceButton.hidden = YES;
    }
    else{
        self.todoDetailsViewController.viewPlaceButton.hidden = NO;
    }

}

- (void)viewDidUnload
{
	[super viewDidUnload];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    
    [self configureTextFields:editing];
    
	[self.navigationItem setHidesBackButton:editing animated:YES];
    [self.tableView beginUpdates];

    NSUInteger stepsCount = [todo.steps count];
    
    NSArray *stepsInsertIndexPath = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:stepsCount inSection:0]];
    
    if (editing) {
        [self.tableView insertRowsAtIndexPaths:stepsInsertIndexPath withRowAnimation:UITableViewRowAnimationBottom];
	} else {
        [self.tableView deleteRowsAtIndexPaths:stepsInsertIndexPath withRowAnimation:UITableViewRowAnimationBottom];
    }

    [self.tableView endUpdates];

	if (!editing) {
        if(![self.todoDetailsViewController isDataValid]){
            UIAlertView *ErrorAlert = [[UIAlertView alloc] initWithTitle:@"Error!"
                                                                 message:@"Todo title is mandatory." delegate:nil
                                                       cancelButtonTitle:@"OK"
                                                       otherButtonTitles:nil, nil];
            [ErrorAlert show];
            self.editing = YES;
            //[ErrorAlert release];
        }
        else{
            BaseNotificationViewController *notificationsController = [[BaseNotificationViewController alloc] init];
            
            UILocalNotification *notification = [notificationsController getLocalNotification:self.todo];
            
            [self updateTodoFields];
            NSManagedObjectContext *context = todo.managedObjectContext;
        
            NSError *error = nil;
            if (![context save:&error]) {
                NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
                abort();
            }
            
            if(notification !=nil){
                [[UIApplication sharedApplication] cancelLocalNotification:notification];
            }
            [notificationsController scheduleNotification:self.todo];

            if((!todo.isDone.boolValue) && ([todo.deadline compare:[NSDate date]]==NSOrderedDescending)){
                UILocalNotification* localNotification = [[UILocalNotification alloc] init];
                
                //Setting the notification 30 minutes before the deadline.
                NSDate *fireDate = [todo.deadline dateByAddingTimeInterval:-(60*30)];
                localNotification.fireDate = fireDate;
                localNotification.alertBody = todo.title;
                localNotification.timeZone = [NSTimeZone defaultTimeZone];
                localNotification.applicationIconBadgeNumber = [[UIApplication sharedApplication] applicationIconBadgeNumber] + 1;
                
                [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
            }

            self.todoDetailsViewController.deadlineTextField.hidden = NO;
            self.todoDetailsViewController.deadlineDatePicker.hidden = YES;
            self.todoDetailsViewController.fbShareButton.hidden = NO;
            [self handleViewPlaceButtonVisibility];
            [self updateDeadlineTextField];
        }
    }
    else{
        self.todoDetailsViewController.deadlineTextField.hidden = YES;
        self.todoDetailsViewController.deadlineDatePicker.hidden = NO;
        self.todoDetailsViewController.fbShareButton.hidden = YES;
    }
}

#pragma mark - UI elements

- (void) configureTextFields:(BOOL) editing
{
    self.todoDetailsViewController.titleTextField.enabled = editing;
	self.todoDetailsViewController.descriptionTextField.enabled = editing;
	self.todoDetailsViewController.placeTextField.enabled = editing;
    self.todoDetailsViewController.deadlineTextField.enabled = editing;
    self.todoDetailsViewController.viewPlaceButton.hidden = editing;
    [self.todoDetailsViewController.deadlineDatePicker setUserInteractionEnabled:editing];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)updateDeadlineTextField
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd-MM-yyyy HH:mm"];
    
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

#pragma mark - Navigation controllers

- (void)loadStepDetailsView:(Step*) selectedStep
{
    StepDetailsViewController *stepDetailViewController = [[StepDetailsViewController alloc] init];
    
    stepDetailViewController.todo = todo;
    stepDetailViewController.step = selectedStep;
    
    [self.navigationController pushViewController:stepDetailViewController animated:YES];
}

- (void)viewPlaceInMaps
{
    PlaceViewController *vc = [[PlaceViewController alloc] init];
    vc.todoPlace = self.todo.place;
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger stepsCount = todo.steps.count;
    
    if ([self isEditing]) {
        stepsCount++;
    }
    
    return stepsCount;
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
        
        if(step.isDone.boolValue){
            cell.backgroundColor = [UIColor greenColor];
        }
        else {
            cell.backgroundColor = [UIColor whiteColor];
        }
        
        cell.textLabel.text = step.text;
    }
    else {
        static NSString *AddStepCellIdentifier = @"AddStepCell";
        cell = [tableView dequeueReusableCellWithIdentifier:AddStepCellIdentifier];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:AddStepCellIdentifier];
        }

        cell.textLabel.text = @"Add step";
    }
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCellEditingStyle style = UITableViewCellEditingStyleDelete;
    
    if (indexPath.row == [todo.steps count]) {
        style = UITableViewCellEditingStyleInsert;
    }
    
    return style;
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
        
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationTop];
    }
}

#pragma mark - Table view delegate

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	NSIndexPath *rowToSelect = indexPath;
  
	return rowToSelect;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Step *selectedStep = nil;

    NSInteger stepsCount = todo.steps.count;

    if(indexPath.row < stepsCount) {
        selectedStep = [steps objectAtIndex:indexPath.row];
    }
    
    [self loadStepDetailsView:selectedStep];
}


#pragma mark - Facebook methods

- (void)publishStory
{
    [FBRequestConnection
     startWithGraphPath:@"me/feed"
     parameters:self.postParams
     HTTPMethod:@"POST"
     completionHandler:^(FBRequestConnection *connection,
                         id result,
                         NSError *error) {
         NSString *alertText;
         if (error) {
             alertText = [NSString stringWithFormat:
                          @"error: domain = %@, code = %d",
                          error.domain, error.code];
         } else {
             alertText = [NSString stringWithFormat:
                          @"Posted %@ at the wall with id: %@",
                          self.todo.title,
                          result[@"id"]];
         }
         // Show the result in an alert
         [[[UIAlertView alloc] initWithTitle:@"Result"
                                     message:alertText
                                    delegate:self
                           cancelButtonTitle:@"OK!"
                           otherButtonTitles:nil]
          show];
     }];
}

- (void)shareToFacebookWall
{
    self.postParams[@"message"] = self.todo.title;

    if ([[FBSession activeSession]isOpen]) {
        /*
         * if the current session has no publish permission we need to reauthorize
         */
        if ([[[FBSession activeSession]permissions]indexOfObject:@"publish_actions"] == NSNotFound) {
            
            [[FBSession activeSession] requestNewPublishPermissions:[NSArray arrayWithObject:@"publish_action"] defaultAudience:FBSessionDefaultAudienceFriends
                                                  completionHandler:^(FBSession *session,NSError *error){
                                                      [self publishStory];
                                                  }];
            
        }else{
            [self publishStory];
        }
    }else{
        /*
         * open a new session with publish permission
         */
        [FBSession openActiveSessionWithPublishPermissions:[NSArray arrayWithObject:@"publish_actions"]
                                           defaultAudience:FBSessionDefaultAudienceOnlyMe
                                              allowLoginUI:YES
                                         completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
                                             if (!error && status == FBSessionStateOpen) {
                                                 [self publishStory];
                                             }else{
                                                 NSLog(@"error");
                                             }
                                         }];
    }

}

@end